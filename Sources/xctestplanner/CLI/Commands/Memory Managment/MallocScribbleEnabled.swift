//
//  MallocScribbleEnabled.swift
//  
//
//  Created by Eugene Nearbe on 02.04.2023.
//

import ArgumentParser
import Foundation

extension Command {
    struct MallocScribbleEnabled: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "malloc-scribble-enabled",
            abstract: "Enable malloc scribble"
        )
        
        @Flag(help: "Enabled")
        var enabled: Bool = false
        
        @Option(name: .shortAndLong, help: "The path to the JSON file to parse.")
        var filePath: String
        
        func run() throws {
            var testPlan = try TestPlanHelper.readTestPlan(filePath: filePath)
            
            TestPlanHelper.setMallocScribbleEnabled(testPlan: &testPlan, enabled: enabled)
            
            try TestPlanHelper.writeTestPlan(testPlan, filePath: filePath)
        }
    }
}
