// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWDonutChartView",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "WWDonutChartView", targets: ["WWDonutChartView"]),
    ],
    targets: [
        .target(name: "WWDonutChartView", resources: [.copy("Privacy")]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
