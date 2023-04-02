//
//  MaximumTestExecutionTimeAllowance.swift
//  
//
//  Created by Eugene Nearbe on 02.04.2023.
//

import ArgumentParser
import Foundation

extension Command {
    struct MaximumTestExecutionTimeAllowance: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "maximum-execution-time",
            abstract: "Set the specified maximum time for test execution."
        )
        
        @Argument(help: "Time.")
        var time: Int
        
        @Option(name: .shortAndLong, help: "The path to the JSON file to parse.")
        var filePath: String
        
        func run() throws {
            var testPlan = try TestPlanHelper.readTestPlan(filePath: filePath)
            
            TestPlanHelper.setMaximumTestExecutionTimeAllowance(testPlan: &testPlan, time: time)
            
            try TestPlanHelper.writeTestPlan(testPlan, filePath: filePath)
        }
    }
}
