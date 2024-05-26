//
//  SelectiveTesting.swift
//
//
//  Created by Atakan Karslı on 26/05/2024.
//

import ArgumentParser
import Foundation

extension Command {
    struct SelectiveTesting: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "selective-testing",
            abstract: "Selectively enables tests in the specified test plan based on code changes."
        )

        @Option(name: .shortAndLong, help: "The path to the test plan file.")
        var filePath: String

        @Option(name: .shortAndLong, help: "The target branch for git diff. Defaults to 'origin/develop'.")
        var targetBranch: String = "origin/develop"

        @Option(name: .shortAndLong, parsing: .upToNextOption, help: "List of modules to ignore. Defaults to an empty list.")
        var ignoreList: [String] = []

        @Option(name: .shortAndLong, help: "The path to the project directory.")
        var projectPath: String

        func run() throws {
            Logger.log("Starting selective testing process...", level: .info)

            let selectedTargets = TestAnalyzer.handleTests(targetBranch: targetBranch, ignoreList: ignoreList, projectPath: projectPath)
            
            if selectedTargets.isEmpty {
                Logger.log("No test targets were selected based on git diff.", level: .warning)
                Command.SelectiveTesting.exit()
            }

            Logger.log("Selected test targets: \(selectedTargets)", level: .info)

            var testPlan = try TestPlanHelper.readTestPlan(filePath: filePath)
            let affectedTargets = Set(selectedTargets.split(separator: " ").map { String($0) })

            TestPlanHelper.updateTestPlanTargets(testPlan: &testPlan, affectedTargets: affectedTargets)
            try TestPlanHelper.writeTestPlan(testPlan, filePath: filePath)

            Logger.log("Test plan successfully updated and written to file: \(filePath)", level: .info)
        }
    }
}

struct TestAnalyzer {
    static func handleTests(targetBranch: String, ignoreList: [String], projectPath: String) -> String {
        do {
            let gitDiffOutput = try executeShellCommand("cd \(projectPath) && git diff --name-only \(targetBranch)")
            let diffPaths = gitDiffOutput.components(separatedBy: "\n").filter { !$0.isEmpty }
            let moduleNames = findModuleNames(in: diffPaths, ignoreList: ignoreList, projectPath: projectPath)
            let dependentModules = Set<String>()
            let combinedModules = Set(moduleNames + dependentModules).sorted()
            return selectedTestTargets(combinedModules)
        } catch {
            Logger.log("Error: \(error)", level: .error)
            return ""
        }
    }
    
    static func executeShellCommand(_ command: String) throws -> String {
        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")

        try task.run()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(decoding: data, as: UTF8.self)
    }

    static func findModuleNames(in paths: [String], ignoreList: [String], projectPath: String) -> [String] {
        var moduleNames = Set<String>()
        let corePath = URL(fileURLWithPath: projectPath)

        for path in paths {
            let processedNames = processPath(path, startingAt: corePath)
            let filteredNames = processedNames.filter { !ignoreList.contains($0) }
            moduleNames.formUnion(filteredNames)
        }

        return Array(moduleNames)
    }

    static func processPath(_ path: String, startingAt basePath: URL) -> Set<String> {
        var folderPath = basePath
        var moduleNames = Set<String>()

        path.components(separatedBy: "/").forEach { component in
            if !component.hasSuffix(".swift") {
                folderPath.appendPathComponent(component)
                if let moduleName = extractModuleName(from: folderPath) {
                    moduleNames.insert(moduleName)
                    return
                }
            }
        }

        return moduleNames
    }

    static func extractModuleName(from folderPath: URL) -> String? {
        do {
            let folderContents = try FileManager.default.contentsOfDirectory(atPath: folderPath.relativePath)
            return folderContents.first(where: { $0.contains(".xcodeproj") })?.replacingOccurrences(of: ".xcodeproj", with: "")
        } catch {
            return nil
        }
    }

    static func selectedTestTargets(_ modules: [String]) -> String {
        let targets = modules.map { $0 + "Tests" }
        return targets.joined(separator: " ")
    }
}
