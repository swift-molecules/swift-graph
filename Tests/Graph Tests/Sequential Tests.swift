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

    static var defaultValue: Graph.Default.Value<TestPayload> {
        Graph.Default.Value(TestPayload(name: "hole", successors: []))
    }
}

@Suite
struct `Graph Sequential Tests` {
    @Test
    func `Empty graph has zero count`() {
        let builder = Graph.Sequential<TestTag, TestPayload>.Builder()
        let graph = builder.build()

        #expect(graph.count == 0)
        #expect(graph.isEmpty)
    }

    @Test
    func `Single node graph`() {
        var builder = Graph.Sequential<TestTag, TestPayload>.Builder()
        let node = builder.allocate(TestPayload(name: "A", successors: []))
        let graph = builder.build()

        #expect(graph.count == 1)
        #expect(!graph.isEmpty)
        #expect(graph[node].name == "A")
    }

    @Test
    func `Multiple nodes preserve order`() {
        var builder = Graph.Sequential<TestTag, TestPayload>.Builder()
        let a = builder.allocate(TestPayload(name: "A", successors: []))
        let b = builder.allocate(TestPayload(name: "B", successors: []))
        let c = builder.allocate(TestPayload(name: "C", successors: []))
        let graph = builder.build()

        #expect(graph.count == 3)
        #expect(graph[a].name == "A")
        #expect(graph[b].name == "B")
        #expect(graph[c].name == "C")
    }

    @Test
    func `Nodes iteration`() {
        var builder = Graph.Sequential<TestTag, TestPayload>.Builder()
        _ = builder.allocate(TestPayload(name: "A", successors: []))
        _ = builder.allocate(TestPayload(name: "B", successors: []))
        _ = builder.allocate(TestPayload(name: "C", successors: []))
        let graph = builder.build()

        var names: [String] = []
        for node in graph.nodes {
            names.append(graph[node].name)
        }
        #expect(names == ["A", "B", "C"])
    }
}

@Suite
struct `Graph Sequential Builder Tests` {
    @Test
    func `Builder with capacity`() {
        var builder = Graph.Sequential<TestTag, TestPayload>.Builder(capacity: 10)
        _ = builder.allocate(TestPayload(name: "A", successors: []))
        #expect(builder.count == 1)
    }

    @Test
    func `Builder subscript access`() {
        var builder = Graph.Sequential<TestTag, TestPayload>.Builder()
        let node = builder.allocate(TestPayload(name: "A", successors: []))
        #expect(builder[node].name == "A")

        builder[node] = TestPayload(name: "Updated", successors: [])
        #expect(builder[node].name == "Updated")
    }

    @Test
    func `Hole allocation and fill`() {
        var builder = Graph.Sequential<TestTag, TestPayload>.Builder()
        let hole = builder.allocateHole(using: TestPayload.defaultValue)
        #expect(builder[hole].name == "hole")

        builder.fill(hole, with: TestPayload(name: "Filled", successors: []))
        #expect(builder[hole].name == "Filled")
    }

    @Test
    func `Forward reference via holes`() {
        var builder = Graph.Sequential<TestTag, TestPayload>.Builder()

        let a = builder.allocateHole(using: TestPayload.defaultValue)
        let b = builder.allocate(TestPayload(name: "B", successors: [a]))

        builder.fill(a, with: TestPayload(name: "A", successors: [b]))

        let graph = builder.build()

        #expect(graph[a].name == "A")
        #expect(graph[b].name == "B")
        #expect(graph[a].successors == [b])
        #expect(graph[b].successors == [a])
    }
}
