//
//  DiagnosticCollectionPolicy.swift
//  
//
//  Created by Eugene Nearbe on 02.04.2023.
//

import ArgumentParser
import Foundation

extension Command {
    struct DiagnosticCollectionPolicy: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "diagnostics-collection-policy",
            abstract: "Setting the specified policy for diagnostics collection"
        )
        
        @Argument(help: "User attachment lifetime. Possible values: 'Always', 'Never')")
        var policy: String
        
        @Option(name: .shortAndLong, help: "The path to the JSON file to parse.")
        var filePath: String
        
        func run() throws {
            var testPlan = try TestPlanHelper.readTestPlan(filePath: filePath)
            
            TestPlanHelper.setDiagnosticCollectionPolicy(testPlan: &testPlan, policy: policy)
            
            try TestPlanHelper.writeTestPlan(testPlan, filePath: filePath)
        }
    }
}
