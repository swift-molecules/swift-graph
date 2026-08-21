import Graph_Primitives_Test_Support
import Testing

private enum TestTag {}

private struct TestPayload: Sendable {
    let name: String
    let successors: [Graph.Node<TestTag>]
}

extension TestPayload {

    static var extract: Graph.Adjacency.Extract<TestPayload, TestTag, [Graph.Node<TestTag>]> {
        Graph.Adjacency.Extract { $0.successors }
    }
}

private func buildDiamondGraph() -> (
    graph: Graph.Sequential<TestTag, TestPayload>,
    a: Graph.Node<TestTag>,
    b: Graph.Node<TestTag>,
    c: Graph.Node<TestTag>,
    d: Graph.Node<TestTag>
) {
    var builder = Graph.Sequential<TestTag, TestPayload>.Builder()

    let d = builder.allocate(TestPayload(name: "D", successors: []))
    let b = builder.allocate(TestPayload(name: "B", successors: [d]))
    let c = builder.allocate(TestPayload(name: "C", successors: [d]))
    let a = builder.allocate(TestPayload(name: "A", successors: [b, c]))

    return (builder.build(), a, b, c, d)
}

private func buildLinearGraph() -> (
    graph: Graph.Sequential<TestTag, TestPayload>,
    a: Graph.Node<TestTag>,
    b: Graph.Node<TestTag>,
    c: Graph.Node<TestTag>
) {
    var builder = Graph.Sequential<TestTag, TestPayload>.Builder()

    let c = builder.allocate(TestPayload(name: "C", successors: []))
    let b = builder.allocate(TestPayload(name: "B", successors: [c]))
    let a = builder.allocate(TestPayload(name: "A", successors: [b]))

    return (builder.build(), a, b, c)
}

private struct ChunkProbePayload: Sendable {
    var a: UInt64
    var b: UInt64
    var id: Int
}

private func buildChunkProbeGraph() -> (
    graph: Graph.Sequential<TestTag, ChunkProbePayload>,
    extract: Graph.Adjacency.Extract<ChunkProbePayload, TestTag, [Graph.Node<TestTag>]>,
    a: Graph.Node<TestTag>,
    b: Graph.Node<TestTag>,
    c: Graph.Node<TestTag>
) {
    var builder = Graph.Sequential<TestTag, ChunkProbePayload>.Builder()

    let c = builder.allocate(
        ChunkProbePayload(a: 0xCCCC_CCCC_CCCC_CCCC, b: 0x3333_3333_3333_3333, id: 2)
    )
    let b = builder.allocate(
        ChunkProbePayload(a: 0xBBBB_BBBB_BBBB_BBBB, b: 0x2222_2222_2222_2222, id: 1)
    )
    let a = builder.allocate(
        ChunkProbePayload(a: 0xAAAA_AAAA_AAAA_AAAA, b: 0x1111_1111_1111_1111, id: 0)
    )

    let graph = builder.build()
    let adjacency: [Int: [Graph.Node<TestTag>]] = [0: [b, c], 1: [c], 2: []]
    let extract = Graph.Adjacency.Extract<ChunkProbePayload, TestTag, [Graph.Node<TestTag>]> {
        adjacency[$0.id] ?? []
    }
    return (graph, extract, a, b, c)
}

@Suite
struct `Graph Traversal First Depth Tests` {
    @Test
    func `DFS on linear graph`() {
        let (graph, a, _, _) = buildLinearGraph()

        var iter = graph.traverse.first(using: TestPayload.extract).depth(from: a)
        var visited: [String] = []
        while let element = iter.next() {
            visited.append(element.payload.name)
        }
        #expect(visited == ["A", "B", "C"])
    }

    @Test
    func `DFS on diamond graph visits each node once`() {
        let (graph, a, _, _, _) = buildDiamondGraph()

        var iter = graph.traverse.first(using: TestPayload.extract).depth(from: a)
        var visited: [String] = []
        while let element = iter.next() {
            visited.append(element.payload.name)
        }

        #expect(visited.count == 4)
        #expect(visited.first == "A")
        #expect(visited.contains("B"))
        #expect(visited.contains("C"))
        #expect(visited.contains("D"))
    }

    @Test
    func `DFS from multiple roots`() {
        let (graph, _, b, c, _) = buildDiamondGraph()

        var iter = graph.traverse.first(using: TestPayload.extract).depth(from: [b, c])
        var visited: [String] = []
        while let element = iter.next() {
            visited.append(element.payload.name)
        }

        #expect(visited.count == 3)
        #expect(visited.contains("B"))
        #expect(visited.contains("C"))
        #expect(visited.contains("D"))
    }

    @Test
    func `DFS on empty roots`() {
        let (graph, _, _, _) = buildLinearGraph()

        var iter = graph.traverse.first(using: TestPayload.extract).depth(
            from: [] as [Graph.Node<TestTag>]
        )
        var hasElements = false
        while iter.next() != nil { hasElements = true }
        #expect(!hasElements)
    }

    @Test
    func `Chunked next(maximumCount:) matches scalar next() across full traversal`() {
        let (graph, extract, a, _, _) = buildChunkProbeGraph()

        var reference: [(node: Graph.Node<TestTag>, a: UInt64, b: UInt64, id: Int)] = []
        var refIter = graph.traverse.first(using: extract).depth(from: a)
        while let element = refIter.next() {
            reference.append(
                (element.node, element.payload.a, element.payload.b, element.payload.id)
            )
        }

        var chunked: [(node: Graph.Node<TestTag>, a: UInt64, b: UInt64, id: Int)] = []
        var chunkIter = graph.traverse.first(using: extract).depth(from: a)
        while true {
            let span = chunkIter.next(maximumCount: Cardinal(UInt(1)))
            if span.isEmpty { break }
            let element = span[0]
            chunked.append((element.node, element.payload.a, element.payload.b, element.payload.id))
        }

        #expect(chunked.count == 3)
        #expect(chunked.count == reference.count)
        for (lhs, rhs) in zip(chunked, reference) {
            #expect(lhs.node == rhs.node)
            #expect(lhs.a == rhs.a)
            #expect(lhs.b == rhs.b)
            #expect(lhs.id == rhs.id)
        }
    }

    @Test
    func `Chunked next(maximumCount: 0) yields an empty span without consuming`() {
        let (graph, extract, a, _, _) = buildChunkProbeGraph()

        var iter = graph.traverse.first(using: extract).depth(from: a)

        let zeroSpanIsEmpty = iter.next(maximumCount: Cardinal(UInt(0))).isEmpty
        #expect(zeroSpanIsEmpty)

        let span = iter.next(maximumCount: Cardinal(UInt(1)))
        let count = span.count
        let firstNode = span[0].node
        #expect(count == 1)
        #expect(firstNode == a)
    }
}

@Suite
struct `Graph Traversal First Breadth Tests` {
    @Test
    func `BFS on linear graph`() {
        let (graph, a, _, _) = buildLinearGraph()

        var iter = graph.traverse.first(using: TestPayload.extract).breadth(from: a)
        var visited: [String] = []
        while let element = iter.next() {
            visited.append(element.payload.name)
        }
        #expect(visited == ["A", "B", "C"])
    }

    @Test
    func `BFS on diamond graph visits each node once`() {
        let (graph, a, _, _, _) = buildDiamondGraph()

        var iter = graph.traverse.first(using: TestPayload.extract).breadth(from: a)
        var visited: [String] = []
        while let element = iter.next() {
            visited.append(element.payload.name)
        }

        #expect(visited.count == 4)
        #expect(visited.first == "A")
        #expect(visited.last == "D")
    }

    @Test
    func `BFS visits in level order`() {
        let (graph, a, _, _, _) = buildDiamondGraph()

        var iter = graph.traverse.first(using: TestPayload.extract).breadth(from: a)
        var visited: [String] = []
        while let element = iter.next() {
            visited.append(element.payload.name)
        }

        let aIndex = visited.firstIndex(of: "A")!
        let bIndex = visited.firstIndex(of: "B")!
        let cIndex = visited.firstIndex(of: "C")!
        let dIndex = visited.firstIndex(of: "D")!

        #expect(aIndex < bIndex)
        #expect(aIndex < cIndex)
        #expect(bIndex < dIndex)
        #expect(cIndex < dIndex)
    }

    @Test
    func `Chunked next(maximumCount:) matches scalar next() across full traversal`() {
        let (graph, extract, a, _, _) = buildChunkProbeGraph()

        var reference: [(node: Graph.Node<TestTag>, a: UInt64, b: UInt64, id: Int)] = []
        var refIter = graph.traverse.first(using: extract).breadth(from: a)
        while let element = refIter.next() {
            reference.append(
                (element.node, element.payload.a, element.payload.b, element.payload.id)
            )
        }

        var chunked: [(node: Graph.Node<TestTag>, a: UInt64, b: UInt64, id: Int)] = []
        var chunkIter = graph.traverse.first(using: extract).breadth(from: a)
        while true {
            let span = chunkIter.next(maximumCount: Cardinal(UInt(1)))
            if span.isEmpty { break }
            let element = span[0]
            chunked.append((element.node, element.payload.a, element.payload.b, element.payload.id))
        }

        #expect(chunked.count == 3)
        #expect(chunked.count == reference.count)
        for (lhs, rhs) in zip(chunked, reference) {
            #expect(lhs.node == rhs.node)
            #expect(lhs.a == rhs.a)
            #expect(lhs.b == rhs.b)
            #expect(lhs.id == rhs.id)
        }
    }

    @Test
    func `Chunked next(maximumCount: 0) yields an empty span without consuming`() {
        let (graph, extract, a, _, _) = buildChunkProbeGraph()

        var iter = graph.traverse.first(using: extract).breadth(from: a)

        let zeroSpanIsEmpty = iter.next(maximumCount: Cardinal(UInt(0))).isEmpty
        #expect(zeroSpanIsEmpty)

        let span = iter.next(maximumCount: Cardinal(UInt(1)))
        let count = span.count
        let firstNode = span[0].node
        #expect(count == 1)
        #expect(firstNode == a)
    }
}

@Suite
struct `Graph Traversal Topological Tests` {
    @Test
    func `Topological order on DAG`() {
        let (graph, a, b, c, d) = buildDiamondGraph()

        let order = graph.traverse.topological(from: a, using: TestPayload.extract)
        #expect(!order.hasCycles)

        let nodes = order.map { $0.node }

        let aIndex = nodes.firstIndex(of: a)!
        let bIndex = nodes.firstIndex(of: b)!
        let cIndex = nodes.firstIndex(of: c)!
        let dIndex = nodes.firstIndex(of: d)!

        #expect(aIndex < bIndex)
        #expect(aIndex < cIndex)
        #expect(bIndex < dIndex)
        #expect(cIndex < dIndex)
    }

    @Test
    func `Topological order detects cycles`() {
        var builder = Graph.Sequential<TestTag, TestPayload>.Builder()

        let a = builder.allocate(TestPayload(name: "A", successors: []))
        let b = builder.allocate(TestPayload(name: "B", successors: []))
        let c = builder.allocate(TestPayload(name: "C", successors: [a]))
        builder[a] = TestPayload(name: "A", successors: [b])
        builder[b] = TestPayload(name: "B", successors: [c])

        let cyclicGraph = builder.build()

        let order = cyclicGraph.traverse.topological(from: a, using: TestPayload.extract)
        #expect(order.hasCycles)
    }

    @Test
    func `Topological order on linear graph`() {
        let (graph, a, _, _) = buildLinearGraph()

        let order = graph.traverse.topological(from: a, using: TestPayload.extract)
        #expect(!order.hasCycles)

        let names = order.map { $0.payload.name }
        #expect(names == ["A", "B", "C"])
    }
}
