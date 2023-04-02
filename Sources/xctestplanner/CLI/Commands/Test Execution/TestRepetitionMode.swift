//
//  TestRepetitionMode.swift
//  
//
//  Created by Eugene Nearbe on 04.04.2023.
//

import ArgumentParser
import Foundation

extension Command {
    struct TestRepetitionMode: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "test-repetition-mode",
            abstract: "Set the specified mode for test repetition"
        )
        
        @Argument(help: "Mode. Possible value: 'untilFailure', 'retryOnFailure', 'fixedIterations'")
        var mode: String
        
        @Option(name: .shortAndLong, help: "The path to the JSON file to parse.")
        var filePath: String
        
        func run() throws {
            var testPlan = try TestPlanHelper.readTestPlan(filePath: filePath)
            
            TestPlanHelper.setTestRepetitionMode(testPlan: &testPlan, mode: mode)
            
            try TestPlanHelper.writeTestPlan(testPlan, filePath: filePath)
        }
    }
}
