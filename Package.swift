// swift-tools-version: 6.0

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Project",
    platforms: [
        .iOS("16.0")
    ],
    products: [
        .iOSApplication(
            name: "Project",
            targets: ["AppModule"],
            bundleIdentifier: "com.ashvaramesh.Project",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .asset("AppIcon"),
            accentColor: .presetColor(.indigo),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: ".",
            resources: [
                .process("Assets.xcassets")
            ]
        )
    ],
    swiftLanguageVersions: [.version("6")]
)
