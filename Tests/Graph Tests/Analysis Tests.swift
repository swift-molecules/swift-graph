import Graph_Test_Support
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

@Suite
struct `Graph Sequential Analyze Reachable Tests` {
    @Test
    func `Reachable from single root in DAG`() {
        var builder = Graph.Sequential<TestTag, TestPayload>.Builder()

        let d = builder.allocate(TestPayload(name: "D", successors: []))
        let b = builder.allocate(TestPayload(name: "B", successors: [d]))
        let c = builder.allocate(TestPayload(name: "C", successors: [d]))
        let a = builder.allocate(TestPayload(name: "A", successors: [b, c]))

        let graph = builder.build()

        let reachable = graph.analyze(using: TestPayload.extract).reachable(from: a)
        let count = reachable.count
        let hasA = reachable.contains(a)
        let hasB = reachable.contains(b)
        let hasC = reachable.contains(c)
        let hasD = reachable.contains(d)
        #expect(count == 4)
        #expect(hasA)
        #expect(hasB)
        #expect(hasC)
        #expect(hasD)
    }

    @Test
    func `Reachable from middle node`() {
        var builder = Graph.Sequential<TestTag, TestPayload>.Builder()

        let d = builder.allocate(TestPayload(name: "D", successors: []))
        let b = builder.allocate(TestPayload(name: "B", successors: [d]))
        let c = builder.allocate(TestPayload(name: "C", successors: [d]))
        let a = builder.allocate(TestPayload(name: "A", successors: [b, c]))

        let graph = builder.build()

        let reachable = graph.analyze(using: TestPayload.extract).reachable(from: b)
        let count = reachable.count
        let hasB = reachable.contains(b)
        let hasD = reachable.contains(d)
        let hasA = reachable.contains(a)
        let hasC = reachable.contains(c)
        #expect(count == 2)
        #expect(hasB)
        #expect(hasD)
        #expect(!hasA)
        #expect(!hasC)
    }

    @Test
    func `Reachable from multiple roots`() {
        var builder = Graph.Sequential<TestTag, TestPayload>.Builder()

        let b = builder.allocate(TestPayload(name: "B", successors: []))
        let a = builder.allocate(TestPayload(name: "A", successors: [b]))
        let d = builder.allocate(TestPayload(name: "D", successors: []))
        let c = builder.allocate(TestPayload(name: "C", successors: [d]))

        let graph = builder.build()

        let reachable = graph.analyze(using: TestPayload.extract).reachable(from: [a, c])
        let count = reachable.count
        #expect(count == 4)
    }

    @Test
    func `Reachable from leaf node`() {
        var builder = Graph.Sequential<TestTag, TestPayload>.Builder()

        let c = builder.allocate(TestPayload(name: "C", successors: []))
        let b = builder.allocate(TestPayload(name: "B", successors: [c]))
        _ = builder.allocate(TestPayload(name: "A", successors: [b]))

        let graph = builder.build()

        let reachable = graph.analyze(using: TestPayload.extract).reachable(from: c)
        let count = reachable.count
        let hasC = reachable.contains(c)
        #expect(count == 1)
        #expect(hasC)
    }
}

@Suite
struct `Graph Sequential Analyze Cycles Tests` {
    @Test
    func `No cycles in DAG`() {
        var builder = Graph.Sequential<TestTag, TestPayload>.Builder()

        let c = builder.allocate(TestPayload(name: "C", successors: []))
        let b = builder.allocate(TestPayload(name: "B", successors: [c]))
        let a = builder.allocate(TestPayload(name: "A", successors: [b]))

        let graph = builder.build()

        #expect(!graph.analyze(using: TestPayload.extract).hasCycles(from: a))
        #expect(!graph.analyze(using: TestPayload.extract).hasCycles())
    }

    @Test
    func `Self-loop detected`() {
        var builder = Graph.Sequential<TestTag, TestPayload>.Builder()

        let a = builder.allocate(TestPayload(name: "A", successors: []))
        builder[a] = TestPayload(name: "A", successors: [a])

        let graph = builder.build()

        #expect(graph.analyze(using: TestPayload.extract).hasCycles(from: a))
    }

    @Test
    func `Cycle in graph detected`() {
        var builder = Graph.Sequential<TestTag, TestPayload>.Builder()

        let a = builder.allocate(TestPayload(name: "A", successors: []))
        let b = builder.allocate(TestPayload(name: "B", successors: []))
        let c = builder.allocate(TestPayload(name: "C", successors: [a]))
        builder[a] = TestPayload(name: "A", successors: [b])
        builder[b] = TestPayload(name: "B", successors: [c])

        let graph = builder.build()

        #expect(graph.analyze(using: TestPayload.extract).hasCycles(from: a))
    }
}

@Suite("Graph.StronglyConnectedComponents")
struct SCCTests {
    @Test
    func `SCC in DAG (each node is its own SCC)`() {
        var builder = Graph.Sequential<TestTag, TestPayload>.Builder()

        let c = builder.allocate(TestPayload(name: "C", successors: []))
        let b = builder.allocate(TestPayload(name: "B", successors: [c]))
        let a = builder.allocate(TestPayload(name: "A", successors: [b]))

        let graph = builder.build()

        let sccs = graph.analyze(using: TestPayload.extract).scc(from: a)

        #expect(sccs.count == 3)
        #expect(sccs.allSatisfy { $0.count == 1 })
    }

    @Test
    func `SCC with cycle`() {
        var builder = Graph.Sequential<TestTag, TestPayload>.Builder()

        let a = builder.allocate(TestPayload(name: "A", successors: []))
        let b = builder.allocate(TestPayload(name: "B", successors: []))
        let c = builder.allocate(TestPayload(name: "C", successors: [a]))
        builder[a] = TestPayload(name: "A", successors: [b])
        builder[b] = TestPayload(name: "B", successors: [c])

        let graph = builder.build()

        let sccs = graph.analyze(using: TestPayload.extract).scc(from: a)

        #expect(sccs.count == 1)
        #expect(sccs[0].count == 3)
    }

    @Test
    func `Multiple SCCs`() {
        var builder = Graph.Sequential<TestTag, TestPayload>.Builder()

        let a = builder.allocate(TestPayload(name: "A", successors: []))
        let b = builder.allocate(TestPayload(name: "B", successors: [a]))
        let c = builder.allocate(TestPayload(name: "C", successors: []))
        let d = builder.allocate(TestPayload(name: "D", successors: [c]))

        builder[a] = TestPayload(name: "A", successors: [b, c])
        builder[c] = TestPayload(name: "C", successors: [d])

        let graph = builder.build()

        let sccs = graph.analyze(using: TestPayload.extract).scc(from: a)

        #expect(sccs.count == 2)
        #expect(sccs.allSatisfy { $0.count == 2 })
    }

    @Test
    func `Self-loop is SCC`() {
        var builder = Graph.Sequential<TestTag, TestPayload>.Builder()

        let a = builder.allocate(TestPayload(name: "A", successors: []))
        builder[a] = TestPayload(name: "A", successors: [a])

        let graph = builder.build()

        let sccs = graph.analyze(using: TestPayload.extract).scc(from: a)

        #expect(sccs.count == 1)
        #expect(sccs[0] == [a])
    }
}
