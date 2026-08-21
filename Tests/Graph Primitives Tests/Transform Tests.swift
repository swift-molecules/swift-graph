import Column_Primitives
import Graph_Primitives_Test_Support
import Hash_Indexed_Primitive
import Set_Ordered_Primitive
import Testing

private enum TestTag {}

private func orderedSet(
    _ nodes: Graph.Node<TestTag>...
) -> __SetOrdered<Hash.Indexed<Column.Heap<Graph.Node<TestTag>>>> {
    var set = __SetOrdered<Hash.Indexed<Column.Heap<Graph.Node<TestTag>>>>()
    for node in nodes {
        _ = set.insert(node)
    }
    return set
}

@Suite
struct `Graph Sequential Transform Payloads Tests` {
    @Test
    func `Payload mapping preserves node count`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let c = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let b = builder.allocate(Graph.Adjacency.List(adjacent: [c]))
        let a = builder.allocate(Graph.Adjacency.List(adjacent: [b, c]))

        let graph = builder.build()

        let mapped = graph.transform.payloads { $0.adjacent.count }

        #expect(mapped.count == graph.count)
        #expect(mapped.count == 3)
        #expect(mapped[a] == 2)
        #expect(mapped[b] == 1)
        #expect(mapped[c] == 0)
    }

    @Test
    func `Payload mapping on empty graph`() {
        let builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()
        let graph = builder.build()

        let mapped = graph.transform.payloads { $0.adjacent.count }

        #expect(mapped.count == 0)
        #expect(mapped.isEmpty)
    }

    @Test
    func `Payload mapping changes payload type`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let a = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let b = builder.allocate(Graph.Adjacency.List(adjacent: [a]))

        let graph = builder.build()

        let mapped: Graph.Sequential<TestTag, String> = graph.transform.payloads { payload in
            "edges: \(payload.adjacent.count)"
        }

        #expect(mapped[a] == "edges: 0")
        #expect(mapped[b] == "edges: 1")
    }
}

@Suite
struct `Graph Sequential Transform Subgraph Tests` {
    @Test
    func `Induced subgraph drops edges to excluded nodes`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let d = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let b = builder.allocate(Graph.Adjacency.List(adjacent: [d]))
        let c = builder.allocate(Graph.Adjacency.List(adjacent: [d]))
        let a = builder.allocate(Graph.Adjacency.List(adjacent: [b, c]))

        let graph = builder.build()

        let subgraph = graph.transform.subgraph(inducedBy: orderedSet(a, b))

        #expect(subgraph != nil)
        #expect(subgraph!.count == 2)

        for node in subgraph!.nodes {
            let payload = subgraph![node]
            for adjacent in payload.adjacent {
                #expect(adjacent < subgraph!.count)
            }
        }
    }

    @Test
    func `Induced subgraph remaps to sequential IDs`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let d = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let c = builder.allocate(Graph.Adjacency.List(adjacent: [d]))
        let b = builder.allocate(Graph.Adjacency.List(adjacent: [c, d]))
        _ = builder.allocate(Graph.Adjacency.List(adjacent: [b]))

        let graph = builder.build()

        let subgraph = graph.transform.subgraph(inducedBy: orderedSet(b, c, d))

        #expect(subgraph != nil)
        #expect(subgraph!.count == 3)

        for node in subgraph!.nodes {
            let payload = subgraph![node]
            for adjacent in payload.adjacent {
                #expect(adjacent < 3)
            }
        }
    }

    @Test
    func `Induced subgraph returns nil for invalid nodes`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let a = builder.allocate(Graph.Adjacency.List(adjacent: []))
        _ = builder.allocate(Graph.Adjacency.List(adjacent: [a]))

        let graph = builder.build()

        let invalidNode = Graph.Node<TestTag>(_unchecked: Ordinal(999))

        let subgraph = graph.transform.subgraph(inducedBy: orderedSet(a, invalidNode))

        #expect(subgraph == nil)
    }

    @Test
    func `Induced subgraph on all nodes returns equivalent graph`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let b = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let a = builder.allocate(Graph.Adjacency.List(adjacent: [b]))

        let graph = builder.build()

        let subgraph = graph.transform.subgraph(inducedBy: orderedSet(a, b))

        #expect(subgraph != nil)
        #expect(subgraph!.count == graph.count)

        var originalEdges = 0
        var subgraphEdges = 0

        for node in graph.nodes {
            originalEdges += graph[node].adjacent.count
        }
        for node in subgraph!.nodes {
            subgraphEdges += subgraph![node].adjacent.count
        }

        #expect(subgraphEdges == originalEdges)
    }

    @Test
    func `Induced subgraph on empty set returns empty graph`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        _ = builder.allocate(Graph.Adjacency.List(adjacent: []))

        let graph = builder.build()

        let subgraph = graph.transform.subgraph(inducedBy: orderedSet())

        #expect(subgraph != nil)
        #expect(subgraph!.count == 0)
        #expect(subgraph!.isEmpty)
    }

    @Test
    func `Induced subgraph preserves edges within subgraph`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let c = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let b = builder.allocate(Graph.Adjacency.List(adjacent: [c]))
        let a = builder.allocate(Graph.Adjacency.List(adjacent: [b]))

        let graph = builder.build()

        let subgraph = graph.transform.subgraph(inducedBy: orderedSet(a, b))

        #expect(subgraph != nil)
        #expect(subgraph!.count == 2)

        var totalEdges = 0
        for node in subgraph!.nodes {
            totalEdges += subgraph![node].adjacent.count
        }

        #expect(totalEdges == 1)
    }
}
