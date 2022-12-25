// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let argumentParserDependency: Target.Dependency = .product(name: "ArgumentParser", package: "swift-argument-parser")

let package = Package(
    name: "xctestplanner",
    products: [
     .executable(name: "xctestplanner", targets: ["xctestplanner"]),
    ],
    dependencies: [
        .package(
          name: "swift-argument-parser",
          url: "https://github.com/apple/swift-argument-parser",
          .upToNextMinor(from: "0.4.3")
        )
    ],
    targets: [
        .executableTarget(
            name: "xctestplanner",
            dependencies: [argumentParserDependency]),
    ]
)
