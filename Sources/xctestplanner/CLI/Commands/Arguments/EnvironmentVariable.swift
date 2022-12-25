//
//  EnvironmentVariable.swift
//  
//
//  Created by Atakan Karslı on 24/12/2022.
//

import ArgumentParser
import Foundation

extension Command {
    struct EnvironmentVariable: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "environment",
            abstract: "Sets the environment variable in the test plan."
        )
        
        @Option(name: .shortAndLong, help: "The path to the JSON file to parse.")
        var filePath: String
        
        @Option(name: .shortAndLong, help: "The key of the environment variable.")
        var key: String
        
        @Option(name: .shortAndLong, help: "The value of the environment variable.")
        var value: String
        
        func run() throws {
            var testPlan = try TestPlanHelper.readTestPlan(filePath: filePath)
            
            TestPlanHelper.setEnvironmentVariable(testPlan: &testPlan, key: key, value: value)
            
            try TestPlanHelper.writeTestPlan(testPlan, filePath: filePath)
        }
    }
}

