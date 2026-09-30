// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-graph",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Graph",
            targets: ["Graph"]
        ),
        .library(
            name: "Graph Standard Library Integration",
            targets: ["Graph Standard Library Integration"]
        ),
        .library(
            name: "Graph Apple Foundation Integration",
            targets: ["Graph Apple Foundation Integration"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-ordinal.git", branch: "main"),
        .package(
            url: "https://github.com/swift-atoms/swift-tagged.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-stack.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-set.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-set-ordered.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-heap.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-index.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-array.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-fixed.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-hash-table.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-ownership-shared.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-buffer-linear.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-buffer-ring.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-queue.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-bit-vector.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-iterator.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-vector.git",
            branch: "main"
        ),
        .package(url: "https://github.com/swift-atoms/swift-collection.git", branch: "main", traits: ["TaggedCollection"]),
        .package(url: "https://github.com/swift-atoms/swift-buffer.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-memory.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-memory-allocation.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-storage.git", branch: "main", traits: ["Generational", "Memory"]),
        .package(url: "https://github.com/swift-atoms/swift-store.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Graph",
            dependencies: [
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Stack", package: "swift-stack"),
                .product(name: "Set", package: "swift-set"),
                .product(name: "Set Ordered", package: "swift-set-ordered"),
                .product(name: "Set Ordered Primitive", package: "swift-set-ordered"),
                .product(name: "Set Ordered", package: "swift-set-ordered"),
                .product(name: "Heap Primitive", package: "swift-heap"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Array", package: "swift-array"),
                .product(name: "Hash Table Primitive", package: "swift-hash-table"),
                .product(name: "Memory Allocator Protocol", package: "swift-memory-allocation"),
                .product(name: "Array Primitive", package: "swift-array"),
                .product(name: "Fixed", package: "swift-fixed"),
                .product(name: "Hash Indexed Primitive", package: "swift-hash-table"),
                .product(
                    name: "Ownership Shared Primitive",
                    package: "swift-ownership-shared"
                ),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear"
                ),
                .product(
                    name: "Buffer Linear",
                    package: "swift-buffer-linear"
                ),
                .product(
                    name: "Buffer Linear Bounded Primitive",
                    package: "swift-buffer-linear"
                ),
                .product(name: "Buffer Ring Primitive", package: "swift-buffer-ring"),
                .product(name: "Queue", package: "swift-queue"),
                .product(name: "Queue Primitive", package: "swift-queue"),
                .product(name: "Bit Vector", package: "swift-bit-vector"),
                .product(name: "Iterator", package: "swift-iterator"),
                .product(name: "Vector", package: "swift-vector"),
                .product(name: "Collection", package: "swift-collection"),
                .product(name: "Buffer", package: "swift-buffer"),
                .product(name: "Memory Allocator Pool", package: "swift-memory-allocation"),
                .product(name: "Memory Pool", package: "swift-memory-allocation"),
                .product(name: "Memory Allocator", package: "swift-memory-allocation"),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Storage", package: "swift-storage"),
                .product(name: "Store", package: "swift-store"),
            ]
        ),
        .target(
            name: "Graph Standard Library Integration",
            dependencies: [
                "Graph"
            ]
        ),
        .target(
            name: "Graph Apple Foundation Integration",
            dependencies: [
                "Graph",
                "Graph Standard Library Integration",
            ]
        ),
        .testTarget(
            name: "Graph Tests",
            dependencies: [
                "Graph",
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Hash Table Primitive", package: "swift-hash-table"),
                .product(name: "Hash Indexed Primitive", package: "swift-hash-table"),
                .product(name: "Set Ordered Primitive", package: "swift-set-ordered"),
                .product(name: "Set Ordered", package: "swift-set-ordered"),
                .product(name: "Buffer", package: "swift-buffer"),
                .product(name: "Buffer Linear Primitive", package: "swift-buffer-linear"),
                .product(name: "Buffer Linear Bounded Primitive", package: "swift-buffer-linear"),
                .product(name: "Buffer Ring Primitive", package: "swift-buffer-ring"),
                .product(name: "Memory Allocator Pool", package: "swift-memory-allocation"),
                .product(name: "Memory Pool", package: "swift-memory-allocation"),
                .product(name: "Memory Allocator", package: "swift-memory-allocation"),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Ownership Shared Primitive", package: "swift-ownership-shared"),
                .product(name: "Storage", package: "swift-storage"),
                .product(name: "Store", package: "swift-store"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
