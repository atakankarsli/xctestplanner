//
//  UndefinedBehaviorSanitizerEnabled.swift
//  
//
//  Created by Eugene Nearbe on 02.04.2023.
//

import ArgumentParser
import Foundation

extension Command {
    struct UndefinedBehaviorSanitizerEnabled: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "undefined-behaviour-sanitizer",
            abstract: "Enable undefined behaviour sanitizer"
        )
        
        @Flag(help: "Enabled")
        var enabled: Bool = false
        
        @Option(name: .shortAndLong, help: "The path to the JSON file to parse.")
        var filePath: String
        
        func run() throws {
            var testPlan = try TestPlanHelper.readTestPlan(filePath: filePath)
            
            TestPlanHelper.setUndefinedBehaviorSanitizerEnabled(testPlan: &testPlan, enabled: enabled)
            
            try TestPlanHelper.writeTestPlan(testPlan, filePath: filePath)
        }
    }
}
