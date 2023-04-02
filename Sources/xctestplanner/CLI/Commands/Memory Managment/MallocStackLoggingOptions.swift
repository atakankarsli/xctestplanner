//
//  MallocStackLoggingOptions.swift
//  
//
//  Created by Eugene Nearbe on 02.04.2023.
//

import ArgumentParser
import Foundation

extension Command {
    struct MallocStackLoggingOptions: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "malloc-stack-logging-options",
            abstract: "Updates malloc stack logging options."
        )
        
        @Argument(help: "The logging type to update. Possible values: 'liveAllocations', 'allAllocations'")
        var loggingType: String
        
        @Option(name: .shortAndLong, help: "The path to the JSON file to parse.")
        var filePath: String
        
        func run() throws {
            var testPlan = try TestPlanHelper.readTestPlan(filePath: filePath)
            
            TestPlanHelper.setMallocStackLoggingOptions(testPlan: &testPlan, loggingType: loggingType)
            
            try TestPlanHelper.writeTestPlan(testPlan, filePath: filePath)
        }
    }
}
