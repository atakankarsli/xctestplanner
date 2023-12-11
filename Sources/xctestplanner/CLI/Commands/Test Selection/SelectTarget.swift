//
//  File.swift
//  
//
//  Created by Atakan Karslı on 08/12/2023.
//

import ArgumentParser
import Foundation

// Assuming TestPlanModel, TestTarget, and other required types are already defined

extension Command {
    struct SelectTarget: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "select-target",
            abstract: "Enables the specified test targets in the test plan."
        )
        
        @Argument(help: "A list of test targets to enable.")
        var targets: [String]

        @Option(name: .shortAndLong, help: "The path to the JSON file to parse.")
        var filePath: String
        
        func run() throws {
            var testPlan = try TestPlanHelper.readTestPlan(filePath: filePath)

            // Convert target names to a Set
            let affectedTargets = Set(targets)

            // Update the test plan with the affected targets
            TestPlanHelper.updateTestPlanTargets(testPlan: &testPlan, affectedTargets: affectedTargets)

            // Write the updated test plan back to the file
            try TestPlanHelper.writeTestPlan(testPlan, filePath: filePath)
        }
    }
}
