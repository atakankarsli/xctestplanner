//
//  CodeCoverage.swift
//  
//
//  Created by Eugene Nearbe on 02.04.2023.
//

import ArgumentParser
import Foundation

extension Command {
    struct CodeCoverage: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "code-coverage-target",
            abstract: "Setting the specified target for code coverage"
        )
        
        @Option(name: .shortAndLong, help: "Name of .xcodeproj file")
        var xcodeProj: String
        
        @Option(name: .shortAndLong, help: "Target identifier")
        var identifier: String
        
        @Option(name: .shortAndLong, help: "Target name")
        var name: String
        
        @Option(name: .shortAndLong, help: "The path to the JSON file to parse.")
        var filePath: String
        
        func run() throws {
            var testPlan = try TestPlanHelper.readTestPlan(filePath: filePath)
            
            let target = Target(containerPath: xcodeProj, identifier: identifier, name: name)
            TestPlanHelper.setCodeCoverage(testPlan: &testPlan, target: target)
            
            try TestPlanHelper.writeTestPlan(testPlan, filePath: filePath)
        }
    }
}
