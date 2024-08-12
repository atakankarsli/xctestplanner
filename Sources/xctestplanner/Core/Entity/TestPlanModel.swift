import Foundation

// MARK: - TestPlanModel
struct TestPlanModel: Codable {
    var configurations: [Configuration]
    var defaultOptions: DefaultOptions
    var testTargets: [TestTarget]
    var version: Int
}

// MARK: - Configuration
struct Configuration: Codable {
    var id, name: String
    var options: Options
}

// MARK: - Options
struct Options: Codable {
    let language: String?
    let targetForVariableExpansion: Target?
    let environmentVariableEntries: [EnvironmentVariableEntry]?
}

// MARK: - Target
struct Target: Codable {
    var containerPath, identifier, name: String
}

// MARK: - DefaultOptions
struct DefaultOptions: Codable {
    var areLocalizationScreenshotsEnabled: Bool?
    var codeCoverage: Bool?
    var diagnosticCollectionPolicy: String?
    var environmentVariableEntries: [EnvironmentVariableEntry]?
    var language: String?
    var locationScenario: LocationScenario?
    var preferredScreenCaptureFormat: String?
    var region: String?
    var testTimeoutsEnabled: Bool?
    var uiTestingScreenshotsLifetime: String?
    var commandLineArgumentEntries: [CommandLineArgumentEntry]?
    var testRepetitionMode: String?
    var maximumTestRepetitions: Int?
    var defaultTestExecutionTimeAllowance: Int?
    var maximumTestExecutionTimeAllowance: Int?
}

// MARK: - CommandLineArgumentEntry
struct CommandLineArgumentEntry: Codable {
    let argument: String
    let enabled: Bool?
}

// MARK: - EnvironmentVariableEntry
struct EnvironmentVariableEntry: Codable {
    var key, value: String
    let enabled: Bool?
}

// MARK: - LocationScenario
struct LocationScenario: Codable {
    var identifier: String
}

// MARK: - TestTarget
struct TestTarget: Codable {
    var parallelizable: Bool?
    var skippedTests: [String]?
    var selectedTests: [String]?
    var target: Target
    var enabled: Bool?
}
