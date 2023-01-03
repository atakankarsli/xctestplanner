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
            Command.Arg.self,
        ]
      )
    }
  }
}

Command.Main.main()
