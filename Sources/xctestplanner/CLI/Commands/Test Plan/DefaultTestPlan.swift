//
//  DefaultTestPlan.swift
//  
//
//  Created by Atakan Karslı on 27/03/2023.
//

import Foundation
import ArgumentParser

extension Command {
    struct DefaultTestPlan: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "default-testplan",
            abstract: "Updates the default selected test plan in the specified Xcode scheme."
        )
        
        @Option(name: .shortAndLong, help: "The path to the Xcode scheme file to edit.")
        var schemePath: String
        
        @Argument(help: "The path to the Test plan JSON file to parse.")
        var testPlanPath: String
    
        func run() throws {

            let schemeUrl = URL(fileURLWithPath: schemePath)
            var schemeContent = try String(contentsOf: schemeUrl)
            
            let defaultReference = """
                default = "YES"
            """

            // Remove default parameter from existing reference
            schemeContent = schemeContent.replacingOccurrences(of: defaultReference, with: "")
            
            
            let testPlanReference = """
                reference = "container:\(testPlanPath)"
            """
            
            let newTestPlanReference = """
                reference = "container:\(testPlanPath)"
                default = "YES"
            """
            
            // Add default parameter to given testPlan reference
            schemeContent = schemeContent.replacingOccurrences(of: testPlanReference, with: newTestPlanReference)

            // Write the updated scheme file
            try schemeContent.write(to: schemeUrl, atomically: true, encoding: .utf8)
        }
    }
}
