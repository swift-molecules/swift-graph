// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-graph-primitives",
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
            name: "Graph Index Primitives",
            targets: ["Graph Index Primitives"]
        ),
        .library(
            name: "Graph Adjacency Primitives",
            targets: ["Graph Adjacency Primitives"]
        ),
        .library(
            name: "Graph Traversal Primitives",
            targets: ["Graph Traversal Primitives"]
        ),
        .library(
            name: "Graph Sequential Primitives",
            targets: ["Graph Sequential Primitives"]
        ),
        .library(
            name: "Graph Remappable Primitives",
            targets: ["Graph Remappable Primitives"]
        ),

        .library(
            name: "Graph DFS Primitives",
            targets: ["Graph DFS Primitives"]
        ),
        .library(
            name: "Graph BFS Primitives",
            targets: ["Graph BFS Primitives"]
        ),
        .library(
            name: "Graph Topological Primitives",
            targets: ["Graph Topological Primitives"]
        ),
        .library(
            name: "Graph Reachable Primitives",
            targets: ["Graph Reachable Primitives"]
        ),
        .library(
            name: "Graph Dead Primitives",
            targets: ["Graph Dead Primitives"]
        ),
        .library(
            name: "Graph SCC Primitives",
            targets: ["Graph SCC Primitives"]
        ),
        .library(
            name: "Graph Cycles Primitives",
            targets: ["Graph Cycles Primitives"]
        ),
        .library(
            name: "Graph Transitive Closure Primitives",
            targets: ["Graph Transitive Closure Primitives"]
        ),
        .library(
            name: "Graph Path Exists Primitives",
            targets: ["Graph Path Exists Primitives"]
        ),
        .library(
            name: "Graph Shortest Path Primitives",
            targets: ["Graph Shortest Path Primitives"]
        ),
        .library(
            name: "Graph Weighted Path Primitives",
            targets: ["Graph Weighted Path Primitives"]
        ),
        .library(
            name: "Graph Payload Map Primitives",
            targets: ["Graph Payload Map Primitives"]
        ),
        .library(
            name: "Graph Subgraph Primitives",
            targets: ["Graph Subgraph Primitives"]
        ),
        .library(
            name: "Graph Reverse Primitives",
            targets: ["Graph Reverse Primitives"]
        ),
        .library(
            name: "Graph Backward Reachable Primitives",
            targets: ["Graph Backward Reachable Primitives"]
        ),

        .library(
            name: "Graph Primitives",
            targets: ["Graph Primitives"]
        ),

        .library(
            name: "Graph Primitives Test Support",
            targets: ["Graph Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-primitives/swift-tagged-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-tagged-collection-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-stack-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-set-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-set-ordered-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-heap-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-index-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-array-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-fixed-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-column-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-hash-table-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-ownership-shared-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-buffer-linear-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-buffer-ring-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-queue-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-bit-vector-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-iterator-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-vector-primitives.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Graph Primitive",
            dependencies: []
        ),
        .target(
            name: "Graph Index Primitives",
            dependencies: [
                "Graph Primitive",
                .product(name: "Index Primitives", package: "swift-index-primitives"),
            ]
        ),
        .target(
            name: "Graph Adjacency Primitives",
            dependencies: [
                "Graph Primitive",
                "Graph Index Primitives",
            ]
        ),
        .target(
            name: "Graph Traversal Primitives",
            dependencies: [
                "Graph Primitive"
            ]
        ),
        .target(
            name: "Graph Sequential Primitives",
            dependencies: [
                "Graph Primitive",
                "Graph Index Primitives",
                "Graph Adjacency Primitives",
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
                .product(
                    name: "Tagged Collection Primitives",
                    package: "swift-tagged-collection-primitives"
                ),
                .product(name: "Index Primitives", package: "swift-index-primitives"),
                .product(name: "Array Primitives", package: "swift-array-primitives"),
                .product(name: "Array Primitive", package: "swift-array-primitives"),
                .product(name: "Column Primitives", package: "swift-column-primitives"),
                .product(
                    name: "Ownership Shared Primitive",
                    package: "swift-ownership-shared-primitives"
                ),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear-primitives"
                ),
                .product(
                    name: "Buffer Linear Primitives",
                    package: "swift-buffer-linear-primitives"
                ),
                .product(name: "Vector Primitives", package: "swift-vector-primitives"),
            ]
        ),
        .target(
            name: "Graph Remappable Primitives",
            dependencies: [
                "Graph Primitive",
                "Graph Adjacency Primitives",
            ]
        ),

        .target(
            name: "Graph DFS Primitives",
            dependencies: [
                "Graph Sequential Primitives",
                "Graph Traversal Primitives",
                .product(name: "Stack Primitives", package: "swift-stack-primitives"),
                .product(name: "Bit Vector Primitives", package: "swift-bit-vector-primitives"),
                .product(name: "Iterator Chunk Primitives", package: "swift-iterator-primitives"),
                .product(
                    name: "Tagged Collection Primitives",
                    package: "swift-tagged-collection-primitives"
                ),
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
                .product(name: "Array Primitives", package: "swift-array-primitives"),
                .product(name: "Array Primitive", package: "swift-array-primitives"),
                .product(name: "Column Primitives", package: "swift-column-primitives"),
                .product(
                    name: "Ownership Shared Primitive",
                    package: "swift-ownership-shared-primitives"
                ),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear-primitives"
                ),
                .product(name: "Vector Primitives", package: "swift-vector-primitives"),
            ]
        ),
        .target(
            name: "Graph BFS Primitives",
            dependencies: [
                "Graph Sequential Primitives",
                "Graph Traversal Primitives",
                .product(name: "Queue Primitives", package: "swift-queue-primitives"),
                .product(name: "Queue Primitive", package: "swift-queue-primitives"),
                .product(name: "Bit Vector Primitives", package: "swift-bit-vector-primitives"),
                .product(name: "Iterator Chunk Primitives", package: "swift-iterator-primitives"),
                .product(
                    name: "Tagged Collection Primitives",
                    package: "swift-tagged-collection-primitives"
                ),
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
                .product(name: "Array Primitives", package: "swift-array-primitives"),
                .product(name: "Array Primitive", package: "swift-array-primitives"),
                .product(name: "Column Primitives", package: "swift-column-primitives"),
                .product(
                    name: "Ownership Shared Primitive",
                    package: "swift-ownership-shared-primitives"
                ),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear-primitives"
                ),
                .product(
                    name: "Buffer Linear Primitives",
                    package: "swift-buffer-linear-primitives"
                ),
                .product(name: "Buffer Ring Primitive", package: "swift-buffer-ring-primitives"),
                .product(name: "Vector Primitives", package: "swift-vector-primitives"),
            ]
        ),
        .target(
            name: "Graph Topological Primitives",
            dependencies: [
                "Graph Sequential Primitives",
                "Graph Traversal Primitives",
                .product(name: "Stack Primitives", package: "swift-stack-primitives"),
                .product(name: "Bit Vector Primitives", package: "swift-bit-vector-primitives"),
                .product(
                    name: "Tagged Collection Primitives",
                    package: "swift-tagged-collection-primitives"
                ),
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
                .product(name: "Array Primitives", package: "swift-array-primitives"),
                .product(name: "Array Primitive", package: "swift-array-primitives"),
                .product(name: "Column Primitives", package: "swift-column-primitives"),
                .product(
                    name: "Ownership Shared Primitive",
                    package: "swift-ownership-shared-primitives"
                ),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear-primitives"
                ),
                .product(name: "Vector Primitives", package: "swift-vector-primitives"),
            ]
        ),

        .target(
            name: "Graph Reachable Primitives",
            dependencies: [
                "Graph Sequential Primitives",
                .product(name: "Stack Primitives", package: "swift-stack-primitives"),
                .product(name: "Bit Vector Primitives", package: "swift-bit-vector-primitives"),
                .product(name: "Set Ordered Primitives", package: "swift-set-ordered-primitives"),
                .product(name: "Set Ordered Primitive", package: "swift-set-ordered-primitives"),
                .product(name: "Set Primitives", package: "swift-set-primitives"),
                .product(name: "Hash Indexed Primitive", package: "swift-hash-table-primitives"),
                .product(name: "Column Primitives", package: "swift-column-primitives"),
                .product(
                    name: "Ownership Shared Primitive",
                    package: "swift-ownership-shared-primitives"
                ),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear-primitives"
                ),
                .product(
                    name: "Tagged Collection Primitives",
                    package: "swift-tagged-collection-primitives"
                ),
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
                .product(name: "Vector Primitives", package: "swift-vector-primitives"),
            ]
        ),
        .target(
            name: "Graph Dead Primitives",
            dependencies: [
                "Graph Sequential Primitives",
                "Graph Reachable Primitives",
                .product(name: "Stack Primitives", package: "swift-stack-primitives"),
                .product(name: "Bit Vector Primitives", package: "swift-bit-vector-primitives"),
                .product(name: "Set Ordered Primitives", package: "swift-set-ordered-primitives"),
                .product(name: "Set Ordered Primitive", package: "swift-set-ordered-primitives"),
                .product(name: "Set Primitives", package: "swift-set-primitives"),
                .product(name: "Hash Indexed Primitive", package: "swift-hash-table-primitives"),
                .product(name: "Column Primitives", package: "swift-column-primitives"),
                .product(
                    name: "Ownership Shared Primitive",
                    package: "swift-ownership-shared-primitives"
                ),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear-primitives"
                ),
                .product(
                    name: "Tagged Collection Primitives",
                    package: "swift-tagged-collection-primitives"
                ),
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
                .product(name: "Vector Primitives", package: "swift-vector-primitives"),
            ]
        ),
        .target(
            name: "Graph SCC Primitives",
            dependencies: [
                "Graph Sequential Primitives",
                .product(name: "Stack Primitives", package: "swift-stack-primitives"),
                .product(name: "Bit Vector Primitives", package: "swift-bit-vector-primitives"),
                .product(
                    name: "Tagged Collection Primitives",
                    package: "swift-tagged-collection-primitives"
                ),
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
                .product(name: "Fixed Primitives", package: "swift-fixed-primitives"),
                .product(name: "Fixed Primitive", package: "swift-fixed-primitives"),
                .product(name: "Column Primitives", package: "swift-column-primitives"),
                .product(
                    name: "Ownership Shared Primitive",
                    package: "swift-ownership-shared-primitives"
                ),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear-primitives"
                ),
                .product(
                    name: "Buffer Linear Bounded Primitive",
                    package: "swift-buffer-linear-primitives"
                ),
                .product(name: "Vector Primitives", package: "swift-vector-primitives"),
            ]
        ),
        .target(
            name: "Graph Cycles Primitives",
            dependencies: [
                "Graph Sequential Primitives",
                "Graph Topological Primitives",
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
            ]
        ),
        .target(
            name: "Graph Transitive Closure Primitives",
            dependencies: [
                "Graph Sequential Primitives",
                .product(name: "Stack Primitives", package: "swift-stack-primitives"),
                .product(name: "Bit Vector Primitives", package: "swift-bit-vector-primitives"),
                .product(
                    name: "Tagged Collection Primitives",
                    package: "swift-tagged-collection-primitives"
                ),
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
                .product(name: "Fixed Primitives", package: "swift-fixed-primitives"),
                .product(name: "Fixed Primitive", package: "swift-fixed-primitives"),
                .product(name: "Column Primitives", package: "swift-column-primitives"),
                .product(
                    name: "Ownership Shared Primitive",
                    package: "swift-ownership-shared-primitives"
                ),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear-primitives"
                ),
                .product(
                    name: "Buffer Linear Bounded Primitive",
                    package: "swift-buffer-linear-primitives"
                ),
                .product(name: "Vector Primitives", package: "swift-vector-primitives"),
            ]
        ),

        .target(
            name: "Graph Path Exists Primitives",
            dependencies: [
                "Graph Sequential Primitives",
                .product(name: "Queue Primitives", package: "swift-queue-primitives"),
                .product(name: "Queue Primitive", package: "swift-queue-primitives"),
                .product(name: "Bit Vector Primitives", package: "swift-bit-vector-primitives"),
                .product(
                    name: "Tagged Collection Primitives",
                    package: "swift-tagged-collection-primitives"
                ),
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
                .product(name: "Column Primitives", package: "swift-column-primitives"),
                .product(
                    name: "Ownership Shared Primitive",
                    package: "swift-ownership-shared-primitives"
                ),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear-primitives"
                ),
                .product(
                    name: "Buffer Linear Primitives",
                    package: "swift-buffer-linear-primitives"
                ),
                .product(name: "Buffer Ring Primitive", package: "swift-buffer-ring-primitives"),
                .product(name: "Vector Primitives", package: "swift-vector-primitives"),
            ]
        ),
        .target(
            name: "Graph Shortest Path Primitives",
            dependencies: [
                "Graph Sequential Primitives",
                .product(name: "Queue Primitives", package: "swift-queue-primitives"),
                .product(name: "Queue Primitive", package: "swift-queue-primitives"),
                .product(name: "Bit Vector Primitives", package: "swift-bit-vector-primitives"),
                .product(
                    name: "Tagged Collection Primitives",
                    package: "swift-tagged-collection-primitives"
                ),
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
                .product(name: "Fixed Primitives", package: "swift-fixed-primitives"),
                .product(name: "Fixed Primitive", package: "swift-fixed-primitives"),
                .product(name: "Column Primitives", package: "swift-column-primitives"),
                .product(
                    name: "Ownership Shared Primitive",
                    package: "swift-ownership-shared-primitives"
                ),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear-primitives"
                ),
                .product(
                    name: "Buffer Linear Primitives",
                    package: "swift-buffer-linear-primitives"
                ),
                .product(
                    name: "Buffer Linear Bounded Primitive",
                    package: "swift-buffer-linear-primitives"
                ),
                .product(name: "Buffer Ring Primitive", package: "swift-buffer-ring-primitives"),
                .product(name: "Vector Primitives", package: "swift-vector-primitives"),
            ]
        ),
        .target(
            name: "Graph Weighted Path Primitives",
            dependencies: [
                "Graph Sequential Primitives",

                .product(name: "Heap Primitive", package: "swift-heap-primitives"),
                .product(name: "Bit Vector Primitives", package: "swift-bit-vector-primitives"),
                .product(
                    name: "Tagged Collection Primitives",
                    package: "swift-tagged-collection-primitives"
                ),
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
                .product(name: "Fixed Primitives", package: "swift-fixed-primitives"),
                .product(name: "Fixed Primitive", package: "swift-fixed-primitives"),
                .product(name: "Column Primitives", package: "swift-column-primitives"),
                .product(
                    name: "Ownership Shared Primitive",
                    package: "swift-ownership-shared-primitives"
                ),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear-primitives"
                ),
                .product(
                    name: "Buffer Linear Bounded Primitive",
                    package: "swift-buffer-linear-primitives"
                ),
                .product(name: "Vector Primitives", package: "swift-vector-primitives"),
            ]
        ),

        .target(
            name: "Graph Payload Map Primitives",
            dependencies: [
                "Graph Sequential Primitives",
                .product(name: "Vector Primitives", package: "swift-vector-primitives"),
            ]
        ),
        .target(
            name: "Graph Subgraph Primitives",
            dependencies: [
                "Graph Sequential Primitives",
                "Graph Remappable Primitives",
                .product(name: "Set Ordered Primitives", package: "swift-set-ordered-primitives"),
                .product(name: "Set Ordered Primitive", package: "swift-set-ordered-primitives"),
                .product(name: "Set Primitives", package: "swift-set-primitives"),
                .product(name: "Hash Indexed Primitive", package: "swift-hash-table-primitives"),
                .product(
                    name: "Tagged Collection Primitives",
                    package: "swift-tagged-collection-primitives"
                ),
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
                .product(name: "Fixed Primitives", package: "swift-fixed-primitives"),
                .product(name: "Fixed Primitive", package: "swift-fixed-primitives"),
                .product(name: "Column Primitives", package: "swift-column-primitives"),
                .product(
                    name: "Ownership Shared Primitive",
                    package: "swift-ownership-shared-primitives"
                ),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear-primitives"
                ),
                .product(
                    name: "Buffer Linear Primitives",
                    package: "swift-buffer-linear-primitives"
                ),
                .product(
                    name: "Buffer Linear Bounded Primitive",
                    package: "swift-buffer-linear-primitives"
                ),
            ]
        ),

        .target(
            name: "Graph Reverse Primitives",
            dependencies: [
                "Graph Sequential Primitives",
                .product(
                    name: "Tagged Collection Primitives",
                    package: "swift-tagged-collection-primitives"
                ),
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
                .product(name: "Fixed Primitives", package: "swift-fixed-primitives"),
                .product(name: "Fixed Primitive", package: "swift-fixed-primitives"),
                .product(name: "Column Primitives", package: "swift-column-primitives"),
                .product(
                    name: "Ownership Shared Primitive",
                    package: "swift-ownership-shared-primitives"
                ),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear-primitives"
                ),
                .product(
                    name: "Buffer Linear Primitives",
                    package: "swift-buffer-linear-primitives"
                ),
                .product(
                    name: "Buffer Linear Bounded Primitive",
                    package: "swift-buffer-linear-primitives"
                ),
                .product(name: "Vector Primitives", package: "swift-vector-primitives"),
            ]
        ),
        .target(
            name: "Graph Backward Reachable Primitives",
            dependencies: [
                "Graph Sequential Primitives",
                "Graph Reverse Primitives",
                .product(name: "Stack Primitives", package: "swift-stack-primitives"),
                .product(name: "Bit Vector Primitives", package: "swift-bit-vector-primitives"),
                .product(name: "Set Ordered Primitives", package: "swift-set-ordered-primitives"),
                .product(name: "Set Ordered Primitive", package: "swift-set-ordered-primitives"),
                .product(name: "Set Primitives", package: "swift-set-primitives"),
                .product(name: "Hash Indexed Primitive", package: "swift-hash-table-primitives"),
                .product(name: "Column Primitives", package: "swift-column-primitives"),
                .product(
                    name: "Ownership Shared Primitive",
                    package: "swift-ownership-shared-primitives"
                ),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear-primitives"
                ),
                .product(
                    name: "Tagged Collection Primitives",
                    package: "swift-tagged-collection-primitives"
                ),
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
                .product(name: "Vector Primitives", package: "swift-vector-primitives"),
            ]
        ),

        .target(
            name: "Graph Primitives",
            dependencies: [
                "Graph Primitive",
                "Graph Index Primitives",
                "Graph Adjacency Primitives",
                "Graph Traversal Primitives",
                "Graph Sequential Primitives",
                "Graph Remappable Primitives",
                "Graph DFS Primitives",
                "Graph BFS Primitives",
                "Graph Topological Primitives",
                "Graph Reachable Primitives",
                "Graph Dead Primitives",
                "Graph SCC Primitives",
                "Graph Cycles Primitives",
                "Graph Transitive Closure Primitives",
                "Graph Path Exists Primitives",
                "Graph Shortest Path Primitives",
                "Graph Weighted Path Primitives",
                "Graph Payload Map Primitives",
                "Graph Subgraph Primitives",
                "Graph Reverse Primitives",
                "Graph Backward Reachable Primitives",
            ]
        ),

        .target(
            name: "Graph Primitives Test Support",
            dependencies: [
                "Graph Primitives",
                .product(name: "Set Primitives Test Support", package: "swift-set-primitives"),
                .product(name: "Set Primitive", package: "swift-set-primitives"),
                .product(name: "Set Ordered Primitive", package: "swift-set-ordered-primitives"),
                .product(name: "Array Primitives Test Support", package: "swift-array-primitives"),
                .product(
                    name: "Bit Vector Primitives Test Support",
                    package: "swift-bit-vector-primitives"
                ),
                .product(name: "Hash Indexed Primitive", package: "swift-hash-table-primitives"),
                .product(name: "Column Primitives", package: "swift-column-primitives"),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear-primitives"
                ),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Graph Primitives Tests",
            dependencies: [
                "Graph Primitives",
                "Graph Primitives Test Support",
                .product(name: "Hash Indexed Primitive", package: "swift-hash-table-primitives"),
                .product(name: "Column Primitives", package: "swift-column-primitives"),
                .product(name: "Set Ordered Primitive", package: "swift-set-ordered-primitives"),
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
