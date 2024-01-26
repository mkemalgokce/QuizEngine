// Package.swift

// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "QuizEngine",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "QuizEngine",
            targets: ["QuizEngine"]
        ),
    ],
    targets: [
        .target(
            name: "QuizEngine",
            dependencies: [],
            path: "QuizEngine"
        ),
        .testTarget(
            name: "QuizEngineTests",
            dependencies: ["QuizEngine"],
            path: "QuizEngineTests"
        ),
    ]
)

