//
//  AddressSanitizer.swift
//  
//
//  Created by Eugene Nearbe on 02.04.2023.
//

import ArgumentParser
import Foundation

extension Command {
    struct TestAddressSanitizer: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "adress-sanitizer",
            abstract: "Setup Adress Sanitizer."
        )
        
        @Flag(help: "Set Enabled.")
        var enabled: Bool = false
        
        @Flag(help: "Set detect stack use after return.")
        var detectStackUseAfterReturn: Bool = false
        
        @Option(name: .shortAndLong, help: "The path to the JSON file to parse.")
        var filePath: String
        
        func run() throws {
            var testPlan = try TestPlanHelper.readTestPlan(filePath: filePath)
            
            let addressSanitizer = AddressSanitizer(enabled: enabled, detectStackUseAfterReturn: detectStackUseAfterReturn)
            TestPlanHelper.setAddressSanitizer(testPlan: &testPlan, addressSanitizer: addressSanitizer)
            
            try TestPlanHelper.writeTestPlan(testPlan, filePath: filePath)
        }
    }
}
