//
//  TestPlanHelper.swift
//
//
//  Created by Atakan Karslı on 20/12/2022.
//

import ArgumentParser
import Foundation

class TestPlanHelper {
    static func readTestPlan(filePath: String) throws -> TestPlanModel {
        Logger.log("Reading test plan from file: \(filePath)", level: .info)
        let url = URL(fileURLWithPath: filePath)
        let data = try Data(contentsOf: url)
        
        let decoder = JSONDecoder()
        return try decoder.decode(TestPlanModel.self, from: data)
    }
    
    static func writeTestPlan(_ testPlan: TestPlanModel, filePath: String) throws {
        Logger.log("Writing updated test plan to file: \(filePath)", level: .info)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let updatedData = try encoder.encode(testPlan)
        
        let url = URL(fileURLWithPath: filePath)
        try updatedData.write(to: url)
    }
    
    static func updateSkippedTests(testPlan: inout TestPlanModel, tests: [String], override: Bool) {
        checkForTestTargets(testPlan: testPlan)
        for (index, _) in testPlan.testTargets.enumerated() {
            if testPlan.testTargets[index].selectedTests != nil {
                testPlan.testTargets[index].selectedTests = nil
            }
            if override {
                Logger.log("Overriding skipped tests in test plan", level: .warning)
                testPlan.testTargets[index].skippedTests = tests
            } else {
                if testPlan.testTargets[index].skippedTests == nil {
                    testPlan.testTargets[index].skippedTests = []
                }
                Logger.log("Append given tests to skipped tests in test plan", level: .info)
                testPlan.testTargets[index].skippedTests?.append(contentsOf: tests)
            }
        }
    }
    
    static func updateSelectedTests(testPlan: inout TestPlanModel, with tests: [String], override: Bool) {
        checkForTestTargets(testPlan: testPlan)
        for (index, _) in testPlan.testTargets.enumerated() {
            if testPlan.testTargets[index].skippedTests != nil {
                testPlan.testTargets[index].skippedTests = nil
            }
            if override {
                Logger.log("Overriding selected tests in test plan", level: .warning)
                testPlan.testTargets[index].selectedTests = tests
            } else {
                if testPlan.testTargets[index].selectedTests == nil {
                    testPlan.testTargets[index].selectedTests = []
                }
                Logger.log("Append given tests to selected tests in test plan", level: .info)
                testPlan.testTargets[index].selectedTests?.append(contentsOf: tests)
            }
        }
    }
    
    static func removeTests(testPlan: inout TestPlanModel, with tests: [String]) {
        checkForTestTargets(testPlan: testPlan)
        for (index, _) in testPlan.testTargets.enumerated() {
            Logger.log("Remove given tests from selected tests in test plan", level: .info)
            for test in tests {
                testPlan.testTargets[index].selectedTests?.remove(object: test)
            }
        }
    }
    
    static func updateRerunCount(testPlan: inout TestPlanModel, to count: Int) {
        Logger.log("Updating rerun count in test plan to: \(count)", level: .info)
        if testPlan.defaultOptions.testRepetitionMode == nil {
            testPlan.defaultOptions.testRepetitionMode = TestPlanValue.retryOnFailure.rawValue
        }
        testPlan.defaultOptions.maximumTestRepetitions = count
    }
    
    static func updateLanguage(testPlan: inout TestPlanModel, to language: String) {
        Logger.log("Updating language in test plan to: \(language)", level: .info)
        testPlan.defaultOptions.language = language.lowercased()
    }
    
    static func updateRegion(testPlan: inout TestPlanModel, to region: String) {
        Logger.log("Updating region in test plan to: \(region)", level: .info)
        testPlan.defaultOptions.region = region.uppercased()
    }
    
    static func setEnvironmentVariable(testPlan: inout TestPlanModel, key: String, value: String, enabled: Bool? = true) {
        Logger.log("Setting environment variable with key '\(key)' and value '\(value)' in test plan", level: .info)
        if testPlan.defaultOptions.environmentVariableEntries == nil {
            testPlan.defaultOptions.environmentVariableEntries = []
        }
        testPlan.defaultOptions.environmentVariableEntries?.append(EnvironmentVariableEntry(key: key, value: value, enabled: enabled))
    }
    
    static func setArgument(testPlan: inout TestPlanModel, key: String, disabled: Bool) {
        if testPlan.defaultOptions.commandLineArgumentEntries == nil {
            testPlan.defaultOptions.commandLineArgumentEntries = []
        }
        if disabled {
            Logger.log("Setting command line argument with key '\(key)' in test plan as disabled", level: .info)
            testPlan.defaultOptions.commandLineArgumentEntries?.append(CommandLineArgumentEntry(argument: key, enabled: !disabled))
        } else {
            Logger.log("Setting command line argument with key '\(key)', enabled by default", level: .info)
            testPlan.defaultOptions.commandLineArgumentEntries?.append(CommandLineArgumentEntry(argument: key, enabled: nil))
        }
    }
    
    static func checkForTestTargets(testPlan: TestPlanModel) {
        if testPlan.testTargets.isEmpty {
            Logger.log("Error: Test plan does not have any test targets. Add a test target before attempting to update the selected or skipped tests.", level: .error)
            exit(1)
        }
    }
    
    static func updateTestPlanTargets(testPlan: inout TestPlanModel, affectedTargets: Set<String>) {
        checkForTestTargets(testPlan: testPlan)
        testPlan.testTargets = testPlan.testTargets.map { testTarget in
            let isEnabled = affectedTargets.contains(testTarget.target.name)
            return TestTarget(parallelizable: testTarget.parallelizable,
                              skippedTests: testTarget.skippedTests,
                              selectedTests: testTarget.selectedTests,
                              target: testTarget.target,
                              enabled: isEnabled)
        }
    }
    
    static func runGitDiffAndGetSelectedTargets() -> String {
        printWithColor("Code diff analysis in progress. This may take a moment (up to 30 seconds)...", color: .yellow)
        let output = shell(launchPath: "/bin/bash", arguments: ["-c", "git diff --name-only HEAD~1"])
        
        let testFiles = output
            .split(separator: "\n")
            .filter { $0.contains("Tests/") }
            .map { String($0) }
        
        guard !testFiles.isEmpty else {
            printWithColor("No changes detected affecting tests. No tests have been selected", color: .red)
            return ""
        }
        
        let selectedTests = testFiles.joined(separator: " ")
        printWithColor("Selected test files: \(selectedTests)", color: .green)
        return selectedTests
    }
    
    static func selectTests(withTargets targets: String, testPlanPath: String) {
        printWithColor("Selecting tests with xctestplanner...", color: .yellow)
        
        let targetsArray = targets.components(separatedBy: " ")
        let quotedTargets = targetsArray.map { "'\($0)'" }.joined(separator: " ")
        
        let command = "xctestplanner select-target \(quotedTargets) -f \(testPlanPath)"
        printWithColor("Executing command: \(command)", color: .yellow)
        
        let result = shell(launchPath: "/bin/bash", arguments: ["-c", command])
        
        printWithColor("\(result)", color: .green)
    }
    
    static func shell(launchPath: String, arguments: [String]) -> String {
        let process = Process()
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        
        process.executableURL = URL(fileURLWithPath: launchPath)
        process.arguments = arguments
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        
        do {
            try process.run()
        } catch {
            print("Error executing process: \(error)")
            return ""
        }
        
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        
        if let output = String(data: outputData, encoding: .utf8), !output.isEmpty {
            return output
        } else if let error = String(data: errorData, encoding: .utf8), !error.isEmpty {
            return error
        }
        
        process.waitUntilExit()
        return ""
    }
    
    static func getFirstTestTarget(filePath: String) throws -> String {
        let testPlan = try readTestPlan(filePath: filePath)
        guard let firstTarget = testPlan.testTargets.first else {
            printWithColor("No test targets found in the test plan.", color: .red)
            throw NSError(domain: "TestPlanHelper", code: 1, userInfo: [NSLocalizedDescriptionKey: "No test targets found in the test plan."])
        }
        return firstTarget.target.name
    }
    
}

enum TestPlanValue: String {
    case retryOnFailure
}


enum Colors: String {
    case red = "\u{001B}[0;31m"
    case green = "\u{001B}[0;34m"
    case yellow = "\u{001B}[0;33m"
    case `default` = "\u{001B}[0;0m"
}

func printWithColor(_ text: String, color: Colors = .default) {
    print(color.rawValue + text + Colors.default.rawValue)
}
