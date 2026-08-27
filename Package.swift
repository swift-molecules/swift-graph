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
            name: "Graph Primitive",
            targets: ["Graph Primitive"]
        ),
        .library(
            name: "Graph Index",
            targets: ["Graph Index"]
        ),
        .library(
            name: "Graph Adjacency",
            targets: ["Graph Adjacency"]
        ),
        .library(
            name: "Graph Traversal",
            targets: ["Graph Traversal"]
        ),
        .library(
            name: "Graph Sequential",
            targets: ["Graph Sequential"]
        ),
        .library(
            name: "Graph Remappable",
            targets: ["Graph Remappable"]
        ),

        .library(
            name: "Graph DFS",
            targets: ["Graph DFS"]
        ),
        .library(
            name: "Graph BFS",
            targets: ["Graph BFS"]
        ),
        .library(
            name: "Graph Topological",
            targets: ["Graph Topological"]
        ),
        .library(
            name: "Graph Reachable",
            targets: ["Graph Reachable"]
        ),
        .library(
            name: "Graph Dead",
            targets: ["Graph Dead"]
        ),
        .library(
            name: "Graph SCC",
            targets: ["Graph SCC"]
        ),
        .library(
            name: "Graph Cycles",
            targets: ["Graph Cycles"]
        ),
        .library(
            name: "Graph Transitive Closure",
            targets: ["Graph Transitive Closure"]
        ),
        .library(
            name: "Graph Path Exists",
            targets: ["Graph Path Exists"]
        ),
        .library(
            name: "Graph Shortest Path",
            targets: ["Graph Shortest Path"]
        ),
        .library(
            name: "Graph Weighted Path",
            targets: ["Graph Weighted Path"]
        ),
        .library(
            name: "Graph Payload Map",
            targets: ["Graph Payload Map"]
        ),
        .library(
            name: "Graph Subgraph",
            targets: ["Graph Subgraph"]
        ),
        .library(
            name: "Graph Reverse",
            targets: ["Graph Reverse"]
        ),
        .library(
            name: "Graph Backward Reachable",
            targets: ["Graph Backward Reachable"]
        ),

        .library(
            name: "Graph",
            targets: ["Graph"]
        ),

        .library(
            name: "Graph Test Support",
            targets: ["Graph Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-tagged.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-tagged-collection.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-stack.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-set.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-set-ordered.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-heap.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-index.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-array.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-fixed.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-column.git",
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
            url: "https://github.com/swift-molecules/swift-queue.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-bit-vector.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-iterator.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-vector.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Graph Primitive",
            dependencies: []
        ),
        .target(
            name: "Graph Index",
            dependencies: [
                "Graph Primitive",
                .product(name: "Index", package: "swift-index"),
            ]
        ),
        .target(
            name: "Graph Adjacency",
            dependencies: [
                "Graph Primitive",
                "Graph Index",
            ]
        ),
        .target(
            name: "Graph Traversal",
            dependencies: [
                "Graph Primitive"
            ]
        ),
        .target(
            name: "Graph Sequential",
            dependencies: [
                "Graph Primitive",
                "Graph Index",
                "Graph Adjacency",
                .product(name: "Tagged", package: "swift-tagged"),
                .product(
                    name: "Tagged Collection",
                    package: "swift-tagged-collection"
                ),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Array", package: "swift-array"),
                .product(name: "Array Primitive", package: "swift-array"),
                .product(name: "Column", package: "swift-column"),
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
                .product(name: "Vector", package: "swift-vector"),
            ]
        ),
        .target(
            name: "Graph Remappable",
            dependencies: [
                "Graph Primitive",
                "Graph Adjacency",
            ]
        ),

        .target(
            name: "Graph DFS",
            dependencies: [
                "Graph Sequential",
                "Graph Traversal",
                .product(name: "Stack", package: "swift-stack"),
                .product(name: "Bit Vector", package: "swift-bit-vector"),
                .product(name: "Iterator Chunk", package: "swift-iterator"),
                .product(
                    name: "Tagged Collection",
                    package: "swift-tagged-collection"
                ),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Array", package: "swift-array"),
                .product(name: "Array Primitive", package: "swift-array"),
                .product(name: "Column", package: "swift-column"),
                .product(
                    name: "Ownership Shared Primitive",
                    package: "swift-ownership-shared"
                ),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear"
                ),
                .product(name: "Vector", package: "swift-vector"),
            ]
        ),
        .target(
            name: "Graph BFS",
            dependencies: [
                "Graph Sequential",
                "Graph Traversal",
                .product(name: "Queue", package: "swift-queue"),
                .product(name: "Queue Primitive", package: "swift-queue"),
                .product(name: "Bit Vector", package: "swift-bit-vector"),
                .product(name: "Iterator Chunk", package: "swift-iterator"),
                .product(
                    name: "Tagged Collection",
                    package: "swift-tagged-collection"
                ),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Array", package: "swift-array"),
                .product(name: "Array Primitive", package: "swift-array"),
                .product(name: "Column", package: "swift-column"),
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
                .product(name: "Buffer Ring Primitive", package: "swift-buffer-ring"),
                .product(name: "Vector", package: "swift-vector"),
            ]
        ),
        .target(
            name: "Graph Topological",
            dependencies: [
                "Graph Sequential",
                "Graph Traversal",
                .product(name: "Stack", package: "swift-stack"),
                .product(name: "Bit Vector", package: "swift-bit-vector"),
                .product(
                    name: "Tagged Collection",
                    package: "swift-tagged-collection"
                ),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Array", package: "swift-array"),
                .product(name: "Array Primitive", package: "swift-array"),
                .product(name: "Column", package: "swift-column"),
                .product(
                    name: "Ownership Shared Primitive",
                    package: "swift-ownership-shared"
                ),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear"
                ),
                .product(name: "Vector", package: "swift-vector"),
            ]
        ),

        .target(
            name: "Graph Reachable",
            dependencies: [
                "Graph Sequential",
                .product(name: "Stack", package: "swift-stack"),
                .product(name: "Bit Vector", package: "swift-bit-vector"),
                .product(name: "Set Ordered", package: "swift-set-ordered"),
                .product(name: "Set Ordered Primitive", package: "swift-set-ordered"),
                .product(name: "Set", package: "swift-set"),
                .product(name: "Hash Indexed Primitive", package: "swift-hash-table"),
                .product(name: "Column", package: "swift-column"),
                .product(
                    name: "Ownership Shared Primitive",
                    package: "swift-ownership-shared"
                ),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear"
                ),
                .product(
                    name: "Tagged Collection",
                    package: "swift-tagged-collection"
                ),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Vector", package: "swift-vector"),
            ]
        ),
        .target(
            name: "Graph Dead",
            dependencies: [
                "Graph Sequential",
                "Graph Reachable",
                .product(name: "Stack", package: "swift-stack"),
                .product(name: "Bit Vector", package: "swift-bit-vector"),
                .product(name: "Set Ordered", package: "swift-set-ordered"),
                .product(name: "Set Ordered Primitive", package: "swift-set-ordered"),
                .product(name: "Set", package: "swift-set"),
                .product(name: "Hash Indexed Primitive", package: "swift-hash-table"),
                .product(name: "Column", package: "swift-column"),
                .product(
                    name: "Ownership Shared Primitive",
                    package: "swift-ownership-shared"
                ),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear"
                ),
                .product(
                    name: "Tagged Collection",
                    package: "swift-tagged-collection"
                ),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Vector", package: "swift-vector"),
            ]
        ),
        .target(
            name: "Graph SCC",
            dependencies: [
                "Graph Sequential",
                .product(name: "Stack", package: "swift-stack"),
                .product(name: "Bit Vector", package: "swift-bit-vector"),
                .product(
                    name: "Tagged Collection",
                    package: "swift-tagged-collection"
                ),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Fixed", package: "swift-fixed"),
                .product(name: "Fixed Primitive", package: "swift-fixed"),
                .product(name: "Column", package: "swift-column"),
                .product(
                    name: "Ownership Shared Primitive",
                    package: "swift-ownership-shared"
                ),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear"
                ),
                .product(
                    name: "Buffer Linear Bounded Primitive",
                    package: "swift-buffer-linear"
                ),
                .product(name: "Vector", package: "swift-vector"),
            ]
        ),
        .target(
            name: "Graph Cycles",
            dependencies: [
                "Graph Sequential",
                "Graph Topological",
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),
        .target(
            name: "Graph Transitive Closure",
            dependencies: [
                "Graph Sequential",
                .product(name: "Stack", package: "swift-stack"),
                .product(name: "Bit Vector", package: "swift-bit-vector"),
                .product(
                    name: "Tagged Collection",
                    package: "swift-tagged-collection"
                ),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Fixed", package: "swift-fixed"),
                .product(name: "Fixed Primitive", package: "swift-fixed"),
                .product(name: "Column", package: "swift-column"),
                .product(
                    name: "Ownership Shared Primitive",
                    package: "swift-ownership-shared"
                ),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear"
                ),
                .product(
                    name: "Buffer Linear Bounded Primitive",
                    package: "swift-buffer-linear"
                ),
                .product(name: "Vector", package: "swift-vector"),
            ]
        ),

        .target(
            name: "Graph Path Exists",
            dependencies: [
                "Graph Sequential",
                .product(name: "Queue", package: "swift-queue"),
                .product(name: "Queue Primitive", package: "swift-queue"),
                .product(name: "Bit Vector", package: "swift-bit-vector"),
                .product(
                    name: "Tagged Collection",
                    package: "swift-tagged-collection"
                ),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Column", package: "swift-column"),
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
                .product(name: "Buffer Ring Primitive", package: "swift-buffer-ring"),
                .product(name: "Vector", package: "swift-vector"),
            ]
        ),
        .target(
            name: "Graph Shortest Path",
            dependencies: [
                "Graph Sequential",
                .product(name: "Queue", package: "swift-queue"),
                .product(name: "Queue Primitive", package: "swift-queue"),
                .product(name: "Bit Vector", package: "swift-bit-vector"),
                .product(
                    name: "Tagged Collection",
                    package: "swift-tagged-collection"
                ),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Fixed", package: "swift-fixed"),
                .product(name: "Fixed Primitive", package: "swift-fixed"),
                .product(name: "Column", package: "swift-column"),
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
                .product(name: "Vector", package: "swift-vector"),
            ]
        ),
        .target(
            name: "Graph Weighted Path",
            dependencies: [
                "Graph Sequential",

                .product(name: "Heap Primitive", package: "swift-heap"),
                .product(name: "Bit Vector", package: "swift-bit-vector"),
                .product(
                    name: "Tagged Collection",
                    package: "swift-tagged-collection"
                ),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Fixed", package: "swift-fixed"),
                .product(name: "Fixed Primitive", package: "swift-fixed"),
                .product(name: "Column", package: "swift-column"),
                .product(
                    name: "Ownership Shared Primitive",
                    package: "swift-ownership-shared"
                ),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear"
                ),
                .product(
                    name: "Buffer Linear Bounded Primitive",
                    package: "swift-buffer-linear"
                ),
                .product(name: "Vector", package: "swift-vector"),
            ]
        ),

        .target(
            name: "Graph Payload Map",
            dependencies: [
                "Graph Sequential",
                .product(name: "Vector", package: "swift-vector"),
            ]
        ),
        .target(
            name: "Graph Subgraph",
            dependencies: [
                "Graph Sequential",
                "Graph Remappable",
                .product(name: "Set Ordered", package: "swift-set-ordered"),
                .product(name: "Set Ordered Primitive", package: "swift-set-ordered"),
                .product(name: "Set", package: "swift-set"),
                .product(name: "Hash Indexed Primitive", package: "swift-hash-table"),
                .product(
                    name: "Tagged Collection",
                    package: "swift-tagged-collection"
                ),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Fixed", package: "swift-fixed"),
                .product(name: "Fixed Primitive", package: "swift-fixed"),
                .product(name: "Column", package: "swift-column"),
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
            ]
        ),

        .target(
            name: "Graph Reverse",
            dependencies: [
                "Graph Sequential",
                .product(
                    name: "Tagged Collection",
                    package: "swift-tagged-collection"
                ),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Fixed", package: "swift-fixed"),
                .product(name: "Fixed Primitive", package: "swift-fixed"),
                .product(name: "Column", package: "swift-column"),
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
                .product(name: "Vector", package: "swift-vector"),
            ]
        ),
        .target(
            name: "Graph Backward Reachable",
            dependencies: [
                "Graph Sequential",
                "Graph Reverse",
                .product(name: "Stack", package: "swift-stack"),
                .product(name: "Bit Vector", package: "swift-bit-vector"),
                .product(name: "Set Ordered", package: "swift-set-ordered"),
                .product(name: "Set Ordered Primitive", package: "swift-set-ordered"),
                .product(name: "Set", package: "swift-set"),
                .product(name: "Hash Indexed Primitive", package: "swift-hash-table"),
                .product(name: "Column", package: "swift-column"),
                .product(
                    name: "Ownership Shared Primitive",
                    package: "swift-ownership-shared"
                ),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear"
                ),
                .product(
                    name: "Tagged Collection",
                    package: "swift-tagged-collection"
                ),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Vector", package: "swift-vector"),
            ]
        ),

        .target(
            name: "Graph",
            dependencies: [
                "Graph Primitive",
                "Graph Index",
                "Graph Adjacency",
                "Graph Traversal",
                "Graph Sequential",
                "Graph Remappable",
                "Graph DFS",
                "Graph BFS",
                "Graph Topological",
                "Graph Reachable",
                "Graph Dead",
                "Graph SCC",
                "Graph Cycles",
                "Graph Transitive Closure",
                "Graph Path Exists",
                "Graph Shortest Path",
                "Graph Weighted Path",
                "Graph Payload Map",
                "Graph Subgraph",
                "Graph Reverse",
                "Graph Backward Reachable",
            ]
        ),

        .target(
            name: "Graph Test Support",
            dependencies: [
                "Graph",
                .product(name: "Set Test Support", package: "swift-set"),
                .product(name: "Set Primitive", package: "swift-set"),
                .product(name: "Set Ordered Primitive", package: "swift-set-ordered"),
                .product(name: "Array Test Support", package: "swift-array"),
                .product(
                    name: "Bit Vector Test Support",
                    package: "swift-bit-vector"
                ),
                .product(name: "Hash Indexed Primitive", package: "swift-hash-table"),
                .product(name: "Column", package: "swift-column"),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear"
                ),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Graph Tests",
            dependencies: [
                "Graph",
                "Graph Test Support",
                .product(name: "Hash Indexed Primitive", package: "swift-hash-table"),
                .product(name: "Column", package: "swift-column"),
                .product(name: "Set Ordered Primitive", package: "swift-set-ordered"),
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
