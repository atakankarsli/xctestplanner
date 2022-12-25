//
//  Skip.swift
//  
//
//  Created by Atakan Karslı on 22/12/2022.
//

import ArgumentParser
import Foundation

extension Command {
    struct Skip: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "skip",
            abstract: "Adds the specified tests to the list of skipped tests in the test plan. Use '-o' to override."
        )
        
        @Option(name: .shortAndLong, help: "The path to the JSON file to parse.")
        var filePath: String
        
        @Option(name: .shortAndLong, help: "A list of tests to add to the skipped tests.")
        var tests: [String]
        
        @Flag(name: .shortAndLong, help: "If provided, the skipped tests will be replaced with the specified tests.")
        var override = false
        
        @Option(name: .long, help: "The language to set in the test plan. (examples: 'en', 'tr')")
        var language: String?
        
        @Option(name: .long, help: "The region to set in the test plan. (examples: 'EN', 'TR')")
        var region: String?
        
        @Option(name: .long, help: "The maximum number of test repetitions.")
        var rerun: Int?
        
        func run() throws {
            var testPlan = try TestPlanHelper.readTestPlan(filePath: filePath)
            
            TestPlanHelper.updateSkippedTests(testPlan: &testPlan, tests: tests, override: override)
            
            if let rerun = rerun {
                TestPlanHelper.updateRerunCount(testPlan: &testPlan, to: rerun)
            }
            
            if let language = language {
                TestPlanHelper.updateLanguage(testPlan: &testPlan, to: language)
            }
            
            if let region = region {
                TestPlanHelper.updateRegion(testPlan: &testPlan, to: region)
            }
            
            try TestPlanHelper.writeTestPlan(testPlan, filePath: filePath)
        }
    }
}
