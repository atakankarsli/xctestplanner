//
//  Region.swift
//  
//
//  Created by Atakan Karslı on 23/12/2022.
//

import ArgumentParser
import Foundation

extension Command {
    struct Region: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "region",
            abstract: "Updates the region."
        )
        
        @Option(name: .shortAndLong, help: "The path to the JSON file to parse.")
        var filePath: String
        
        @Option(name: .shortAndLong, help: "The region to update. (examples: 'EN', 'TR')")
        var region: String
        
        func run() throws {
            var testPlan = try TestPlanHelper.readTestPlan(filePath: filePath)
            
            TestPlanHelper.updateRegion(testPlan: &testPlan, to: region)
            
            try TestPlanHelper.writeTestPlan(testPlan, filePath: filePath)
        }
    }
}
