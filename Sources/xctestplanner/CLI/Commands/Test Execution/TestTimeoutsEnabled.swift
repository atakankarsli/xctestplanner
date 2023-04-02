//
//  TestTimeoutsEnabled.swift
//  
//
//  Created by Eugene Nearbe on 02.04.2023.
//

import ArgumentParser
import Foundation

extension Command {
    struct TestTimeoutsEnabled: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "test-timeout-enabled",
            abstract: "Enable test timeouts"
        )
        
        @Flag(name: .shortAndLong, help: "Is Timeout Enabled?")
        var isTimeoutEnabled: Bool = false
        
        @Option(name: .shortAndLong, help: "The path to the JSON file to parse.")
        var filePath: String
        
        func run() throws {
            var testPlan = try TestPlanHelper.readTestPlan(filePath: filePath)
            
            TestPlanHelper.setTestTimeoutsEnabled(testPlan: &testPlan, isTimeoutEnabled: isTimeoutEnabled)
            
            try TestPlanHelper.writeTestPlan(testPlan, filePath: filePath)
        }
    }
}
