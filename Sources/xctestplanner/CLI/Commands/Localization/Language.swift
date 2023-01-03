//
//  Language.swift
//  
//
//  Created by Atakan Karslı on 23/12/2022.
//

import ArgumentParser
import Foundation

extension Command {
    struct Language: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "language",
            abstract: "Updates the language."
        )
        
        @Argument(help: "The language to update. (examples: 'en', 'tr')")
        var language: String
        
        @Option(name: .shortAndLong, help: "The path to the JSON file to parse.")
        var filePath: String
        
        func run() throws {
            var testPlan = try TestPlanHelper.readTestPlan(filePath: filePath)
            
            TestPlanHelper.updateLanguage(testPlan: &testPlan, to: language)
            
            try TestPlanHelper.writeTestPlan(testPlan, filePath: filePath)
        }
    }
}
