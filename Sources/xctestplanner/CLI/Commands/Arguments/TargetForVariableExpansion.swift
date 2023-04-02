//
//  TargetForVariableExpansion.swift
//  
//
//  Created by Eugene Nearbe on 02.04.2023.
//

import ArgumentParser
import Foundation

extension Command {
    struct TargetForVariableExpansion: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "expansion",
            abstract: "Sets the specified target for variable expansion"
        )
        
        @Option(name: .shortAndLong, help: "Name of .xcodeproj file")
        var xcodeProj: String
        
        @Option(name: .shortAndLong, help: "Target identifier")
        var identifier: String
        
        @Option(name: .shortAndLong, help: "Target name")
        var name: String
        
        @Option(name: .shortAndLong, help: "The path to the JSON file to parse.")
        var filePath: String
        
        func run() throws {
            var testPlan = try TestPlanHelper.readTestPlan(filePath: filePath)
            
            let target = Target(containerPath: "container:\(xcodeProj)", identifier: identifier, name: name)
            TestPlanHelper.setTargetForVariableExpansion(testPlan: &testPlan, target: target)
            
            try TestPlanHelper.writeTestPlan(testPlan, filePath: filePath)
        }
    }
}
