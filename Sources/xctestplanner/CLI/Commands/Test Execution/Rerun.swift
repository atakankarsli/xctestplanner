//
//  Rerun.swift
//  
//
//  Created by Atakan Karslı on 23/12/2022.
//

import ArgumentParser
import Foundation

extension Command {
    struct Rerun: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "rerun",
            abstract: "Updates the maximum number of test repetitions."
        )
        
        @Option(name: .shortAndLong, help: "The path to the JSON file to parse.")
        var filePath: String
        
        @Option(name: .long, help: "The maximum number of test repetitions.")
        var rerun: Int
        
        func run() throws {
            var testPlan = try TestPlanHelper.readTestPlan(filePath: filePath)
            
            TestPlanHelper.updateRerunCount(testPlan: &testPlan, to: rerun)
            
            try TestPlanHelper.writeTestPlan(testPlan, filePath: filePath)
        }
    }
}
