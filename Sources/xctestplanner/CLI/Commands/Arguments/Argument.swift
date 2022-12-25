//
//  Argument.swift
//  
//
//  Created by Atakan Karslı on 24/12/2022.
//

import ArgumentParser
import Foundation

extension Command {
    struct Argument: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "argument",
            abstract: "Sets the specified command line argument. Use '-d' to disable"
        )
        
        @Option(name: .shortAndLong, help: "The path to the JSON file to parse.")
        var filePath: String
        
        @Option(name: .shortAndLong, help: "The key of the command line argument to set.")
        var key: String
        
        @Flag(name: .short, help: "Disables the specified command line argument.")
        var disabled = false
        
        func run() throws {
            var testPlan = try TestPlanHelper.readTestPlan(filePath: filePath)
            
            TestPlanHelper.setArgument(testPlan: &testPlan, key: key, disabled: disabled)
            
            try TestPlanHelper.writeTestPlan(testPlan, filePath: filePath)
        }
    }
}
