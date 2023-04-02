//
//  GuardMallocEnabled.swift
//  
//
//  Created by Eugene Nearbe on 02.04.2023.
//

import ArgumentParser
import Foundation

extension Command {
    struct GuardMallocEnabled: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "guard-malloc-enabled",
            abstract: "Enable guard malloc"
        )
        
        @Flag(help: "Enabled")
        var enabled: Bool = false
        
        @Option(name: .shortAndLong, help: "The path to the JSON file to parse.")
        var filePath: String
        
        func run() throws {
            var testPlan = try TestPlanHelper.readTestPlan(filePath: filePath)
            
            TestPlanHelper.setGuardMallocEnabled(testPlan: &testPlan, enabled: enabled)
            
            try TestPlanHelper.writeTestPlan(testPlan, filePath: filePath)
        }
    }
}
