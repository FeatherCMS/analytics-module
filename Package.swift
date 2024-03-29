// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "analytics-module",
    platforms: [
       .macOS(.v12)
    ],
    products: [
        .library(name: "AnalyticsModule", targets: ["AnalyticsModule"]),
        .library(name: "AnalyticsApi", targets: ["AnalyticsApi"]),
    ],
    dependencies: [
        .package(url: "https://github.com/feathercms/feather-core", .branch("dev")),
        .package(url: "https://github.com/malcommac/UAParserSwift", from: "1.2.1"),
        .package(name: "ALanguageParser", url: "https://github.com/matsoftware/accept-language-parser", from: "1.0.0"),
        .package(url: "https://github.com/vapor/sql-kit.git", from: "3.0.0"),
    ],
    targets: [
        .target(name: "AnalyticsApi", dependencies: [
            .product(name: "FeatherCoreApi", package: "feather-core"),
        ]),
        .target(name: "AnalyticsModule", dependencies: [
            .product(name: "FeatherCore", package: "feather-core"),
            .product(name: "UAParserSwift", package: "UAParserSwift"),
            .product(name: "ALanguageParser", package: "ALanguageParser"),
            .product(name: "SQLKit", package: "sql-kit"),
            .target(name: "AnalyticsApi")
        ],
        resources: [
//            .copy("Bundle"),
        ]),
    ]
)
