//
//  TestExecutionOrdering.swift
//  
//
//  Created by Eugene Nearbe on 02.04.2023.
//

import ArgumentParser
import Foundation

extension Command {
    struct TestExecutionOrdering: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "ordering",
            abstract: "Set the specified ordering for test execution"
        )
        
        @Argument(help: "Ordering. Possible value: 'random'")
        var ordering: String
        
        @Option(name: .shortAndLong, help: "The path to the JSON file to parse.")
        var filePath: String
        
        func run() throws {
            var testPlan = try TestPlanHelper.readTestPlan(filePath: filePath)
            
            TestPlanHelper.setTestExecutionOrdering(testPlan: &testPlan, ordering: ordering)
            
            try TestPlanHelper.writeTestPlan(testPlan, filePath: filePath)
        }
    }
}
