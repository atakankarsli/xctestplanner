//
//  SimulatedLocation.swift
//  
//
//  Created by Eugene Nearbe on 02.04.2023.
//

import ArgumentParser
import Foundation

extension Command {
    struct SimulatedLocation: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "location",
            abstract: "Sets the specified identifier for simulate location"
        )
        
        @Argument(help: "Simulated location identifier")
        var identifier: String
        
        @Option(name: .shortAndLong, help: "The path to the JSON file to parse.")
        var filePath: String
        
        func run() throws {
            var testPlan = try TestPlanHelper.readTestPlan(filePath: filePath)
            
            TestPlanHelper.setLocationScenario(testPlan: &testPlan, identifier: identifier)
            
            try TestPlanHelper.writeTestPlan(testPlan, filePath: filePath)
        }
    }
}
