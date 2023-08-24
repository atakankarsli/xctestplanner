//
//  UITestingScreenshotsLifetime.swift
//  
//
//  Created by Eugene Nearbe on 02.04.2023.
//

import ArgumentParser
import Foundation

extension Command {
    struct UITestingScreenshotsLifetime: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "screenshots-lifetime",
            abstract: "Setting the specified lifetime for screenshots"
        )
        
        @Argument(help: "Screenshots lifetime. Possible values: 'keepAlways', 'keepNever')")
        var lifetime: String
        
        @Option(name: .shortAndLong, help: "The path to the JSON file to parse.")
        var filePath: String
        
        func run() throws {
            var testPlan = try TestPlanHelper.readTestPlan(filePath: filePath)
            
            TestPlanHelper.setUITestingScreenshotsLifetime(testPlan: &testPlan, lifetime: lifetime)
            
            try TestPlanHelper.writeTestPlan(testPlan, filePath: filePath)
        }
    }
}
