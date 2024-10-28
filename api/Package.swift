// swift-tools-version:5.7
import PackageDescription

let package = Package(
  name: "myvape",
  platforms: [
    .macOS(.v13),
  ],
  dependencies: [
    // I am deeply confused. Do I have to publish my package to be able to access it?
    // 💧 A server-side Swift web framework.
    .package(url: "https://github.com/vapor/vapor.git", from: "4.89.0"),
    .package(path: "../Models"),
  ],
  targets: [
    .executableTarget(
      name: "App",
      dependencies: [
        .product(name: "Vapor", package: "vapor"),
        .product(name: "Models", package: "Models"),
      ]
    ),
    .testTarget(name: "AppTests", dependencies: [
      .target(name: "App"),
      .product(name: "XCTVapor", package: "vapor"),

      // Workaround for https://github.com/apple/swift-package-manager/issues/6940
      .product(name: "Vapor", package: "vapor"),
    ]),
  ]
)
