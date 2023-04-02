//
//  EnvironmentVariables.swift
//  
//
//  Created by Eugene Nearbe on 02.04.2023.
//

import ArgumentParser
import Foundation

extension Command {
    struct EnvironmentVariables: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "environments",
            abstract: "Sets the environment variables."
        )
        
        @Option(name: .shortAndLong, help: "The path to the JSON file to parse.")
        var filePath: String
        
        @Option(name: .shortAndLong, parsing: .upToNextOption, help: "The key of the environment variable.")
        var keys: [String]
        
        @Option(name: .shortAndLong, parsing: .upToNextOption, help: "The value of the environment variable.")
        var values: [String]
        
        func run() throws {
            var testPlan = try TestPlanHelper.readTestPlan(filePath: filePath)
            
            TestPlanHelper.setEnvironmentVariables(testPlan: &testPlan, keys: keys, values: values)
            
            try TestPlanHelper.writeTestPlan(testPlan, filePath: filePath)
        }
    }
}
