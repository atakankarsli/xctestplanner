//
//  AreLocalizationScreenshotsEnabled.swift
//  
//
//  Created by Eugene Nearbe on 02.04.2023.
//

import ArgumentParser
import Foundation

extension Command {
    struct AreLocalizationScreenshotsEnabled: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "localization-screenshots",
            abstract: "Sets the specified option for manage localization screenshots"
        )
        
        @Flag(name: .shortAndLong, help: "Localization screenshots")
        var enabled: Bool = false
        
        @Option(name: .shortAndLong, help: "The path to the JSON file to parse.")
        var filePath: String
        
        func run() throws {
            var testPlan = try TestPlanHelper.readTestPlan(filePath: filePath)
            
            TestPlanHelper.setLocalizationScreenshots(testPlan: &testPlan, enabled: enabled)
            
            try TestPlanHelper.writeTestPlan(testPlan, filePath: filePath)
        }
    }
}
