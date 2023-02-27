//
//  Remove.swift
//  
//
//  Created by Atakan Karslı on 27/02/2023.
//

import ArgumentParser
import Foundation

extension Command {
    struct Remove: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "remove",
            abstract: "Removes the specified tests from the selected tests. "
        )
        
        @Argument(help: "A list of tests to remove from selected tests.")
        var tests: [String]
        
        @Option(name: .shortAndLong, help: "The path to the JSON file to parse.")
        var filePath: String
        
        func run() throws {
            var testPlan = try TestPlanHelper.readTestPlan(filePath: filePath)
            
            TestPlanHelper.removeTests(testPlan: &testPlan, with: tests)
            
            try TestPlanHelper.writeTestPlan(testPlan, filePath: filePath)
        }
    }
}
