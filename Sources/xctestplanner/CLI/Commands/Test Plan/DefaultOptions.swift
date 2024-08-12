//
//  DefaultOptions.swift
//
//
//  Created by Atakan Karslı on 12/08/2024.
//

import ArgumentParser
import Foundation

extension Command {
    struct DefaultOptions: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "defaultOptions",
            abstract: "Configures various default options in the test plan."
        )
        
        @Option(name: .shortAndLong, help: "The path to the JSON file to parse.")
        var filePath: String
        
        @Option(name: .long, help: "Enable or disable localization screenshots.")
        var enableLocalizationScreenshots: Bool = false
        
        @Option(name: .long, help: "Enable or disable code coverage.")
        var enableCodeCoverage: Bool?
        
        @Option(name: .long, help: "Set the diagnostic collection policy. (options: 'Never', 'Always', etc.)")
        var diagnosticPolicy: String?
        
        @Option(name: .long, help: "Enable or disable test timeouts.")
        var enableTimeouts: Bool = false
        
        @Option(name: .long, help: "Set the screenshot lifetime for UI testing. (options: 'keepAlways', 'deleteAfterSuccess', etc.)")
        var screenshotLifetime: String?
        
        @Option(name: .long, help: "Set the preferred screen capture format. (example: 'screenshot')")
        var screenCaptureFormat: String?
        
        func run() throws {
            var testPlan = try TestPlanHelper.readTestPlan(filePath: filePath)
            
            TestPlanHelper.configureDefaultOptions(
                testPlan: &testPlan,
                enableLocalizationScreenshots: enableLocalizationScreenshots,
                enableCodeCoverage: enableCodeCoverage,
                diagnosticPolicy: diagnosticPolicy,
                enableTimeouts: enableTimeouts,
                screenshotLifetime: screenshotLifetime,
                screenCaptureFormat: screenCaptureFormat
            )
            
            try TestPlanHelper.writeTestPlan(testPlan, filePath: filePath)
        }
    }
}
