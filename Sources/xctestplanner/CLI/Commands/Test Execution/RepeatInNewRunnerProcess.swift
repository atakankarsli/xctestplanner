//
//  RepeatInNewRunnerProcess.swift
//  
//
//  Created by Eugene Nearbe on 02.04.2023.
//

import ArgumentParser
import Foundation

extension Command {
    struct RepeatInNewRunnerProcess: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "new-runner-process",
            abstract: "Enable repeating tests in new runner process"
        )
        
        @Flag(name: .shortAndLong, help: "Is Repeat Test In New Runner Process?")
        var isRepeatInNewRunnerProcess: Bool = false
        
        @Option(name: .shortAndLong, help: "The path to the JSON file to parse.")
        var filePath: String
        
        func run() throws {
            var testPlan = try TestPlanHelper.readTestPlan(filePath: filePath)
            
            TestPlanHelper.setRepeatInNewRunnerProcess(testPlan: &testPlan,
                                                       isRepeatInNewRunnerProcess: isRepeatInNewRunnerProcess)
            
            try TestPlanHelper.writeTestPlan(testPlan, filePath: filePath)
        }
    }
}
