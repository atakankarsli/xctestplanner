//
//  Main.swift
//
//
//  Created by Atakan Karslı on 22/12/2022.
//

import ArgumentParser

enum Command {}

extension Command {
  struct Main: ParsableCommand {
    static var configuration: CommandConfiguration {
      .init(
        commandName: "xctestplanner",
        abstract: "Manage your Xcode Test Plans from the command line",
        version: "0.0.1",
        subcommands: [
            Command.Select.self,
            Command.Skip.self,
            Command.Rerun.self,
            Command.Language.self,
            Command.Region.self,
            Command.EnvironmentVariable.self,
            Command.EnvironmentVariables.self,
            Command.Arg.self,
            Command.Remove.self,
            Command.DefaultTestPlan.self,
            Command.TargetForVariableExpansion.self,
            Command.SimulatedLocation.self,
            Command.UITestingScreenshotsLifetime.self,
            Command.AreLocalizationScreenshotsEnabled.self,
            Command.UserAttachmentLifetime.self,
            Command.DiagnosticCollectionPolicy.self,
            Command.TestRepetitionMode.self,
            Command.TestExecutionOrdering.self,
            Command.TestTimeoutsEnabled.self,
            Command.DefaultTestExecutionTimeAllowance.self,
            Command.MaximumTestExecutionTimeAllowance.self,
            Command.RepeatInNewRunnerProcess.self,
            Command.CodeCoverage.self,
            Command.TestAddressSanitizer.self,
            Command.ThreadSanitizerEnabled.self,
            Command.UndefinedBehaviorSanitizerEnabled.self,
            Command.MainThreadCheckerEnabled.self,
            Command.MallocScribbleEnabled.self,
            Command.MallocGuardEdgesEnabled.self,
            Command.GuardMallocEnabled.self,
            Command.NsZombieEnabled.self,
            Command.MallocStackLoggingOptions.self
        ]
      )
    }
  }
}

Command.Main.main()
