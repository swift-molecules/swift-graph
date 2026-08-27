import Graph_Test_Support
import Testing

private enum TestTag {}

@Suite
struct `Graph Sequential Analyze Dead Tests` {
    @Test
    func `Dead nodes in disconnected graph`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let d = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let c = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let b = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let a = builder.allocate(Graph.Adjacency.List(adjacent: [b]))

        let graph = builder.build()

        let dead = graph.analyze.dead(from: [a])

        let hasC = dead.contains(c)
        let hasD = dead.contains(d)
        let hasA = dead.contains(a)
        let hasB = dead.contains(b)
        let count = dead.count
        #expect(hasC)
        #expect(hasD)
        #expect(!hasA)
        #expect(!hasB)
        #expect(count == 2)
    }

    @Test
    func `Dead nodes from all roots is empty`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let c = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let b = builder.allocate(Graph.Adjacency.List(adjacent: [c]))
        let a = builder.allocate(Graph.Adjacency.List(adjacent: [b]))

        let graph = builder.build()

        let dead = graph.analyze.dead(from: [a])

        let isEmpty = dead.isEmpty
        #expect(isEmpty)
    }

    @Test
    func `Dead nodes from empty roots`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let c = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let b = builder.allocate(Graph.Adjacency.List(adjacent: [c]))
        let a = builder.allocate(Graph.Adjacency.List(adjacent: [b]))

        let graph = builder.build()

        let dead = graph.analyze.dead(from: [] as [Graph.Node<TestTag>])

        let count = dead.count
        let hasA = dead.contains(a)
        let hasB = dead.contains(b)
        let hasC = dead.contains(c)
        #expect(count == 3)
        #expect(hasA)
        #expect(hasB)
        #expect(hasC)
    }

    @Test
    func `Dead nodes in empty graph`() {
        let graph = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder().build()

        let dead = graph.analyze.dead(from: [] as [Graph.Node<TestTag>])

        let isEmpty = dead.isEmpty
        #expect(isEmpty)
    }

    @Test
    func `Dead nodes from multiple roots`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let e = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let d = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let c = builder.allocate(Graph.Adjacency.List(adjacent: [d]))
        let b = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let a = builder.allocate(Graph.Adjacency.List(adjacent: [b]))

        let graph = builder.build()

        let dead = graph.analyze.dead(from: [a, c])

        let hasE = dead.contains(e)
        let hasA = dead.contains(a)
        let hasB = dead.contains(b)
        let hasC = dead.contains(c)
        let hasD = dead.contains(d)
        let count = dead.count
        #expect(hasE)
        #expect(!hasA)
        #expect(!hasB)
        #expect(!hasC)
        #expect(!hasD)
        #expect(count == 1)
    }
}

@Suite
struct `Graph Sequential Analyze TransitiveClosure Tests` {
    @Test
    func `Transitive closure on diamond DAG has correct edge count`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let d = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let b = builder.allocate(Graph.Adjacency.List(adjacent: [d]))
        let c = builder.allocate(Graph.Adjacency.List(adjacent: [d]))
        let a = builder.allocate(Graph.Adjacency.List(adjacent: [b, c]))

        let graph = builder.build()
        let closure = graph.analyze.transitiveClosure()

        var totalEdges = 0
        for node in closure.nodes {
            totalEdges += closure[node].adjacent.count
        }

        #expect(totalEdges == 5)

        #expect(closure[a].adjacent.contains(b))
        #expect(closure[a].adjacent.contains(c))
        #expect(closure[a].adjacent.contains(d))

        #expect(closure[b].adjacent.contains(d))
        #expect(closure[c].adjacent.contains(d))

        #expect(closure[d].adjacent.isEmpty)
    }

    @Test
    func `Transitive closure on linear graph`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let d = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let c = builder.allocate(Graph.Adjacency.List(adjacent: [d]))
        let b = builder.allocate(Graph.Adjacency.List(adjacent: [c]))
        let a = builder.allocate(Graph.Adjacency.List(adjacent: [b]))

        let graph = builder.build()
        let closure = graph.analyze.transitiveClosure()

        var totalEdges = 0
        for node in closure.nodes {
            totalEdges += closure[node].adjacent.count
        }

        #expect(totalEdges == 6)

        #expect(closure[a].adjacent.count == 3)

        #expect(closure[b].adjacent.count == 2)

        #expect(closure[c].adjacent.count == 1)
    }

    @Test
    func `Transitive closure on cycle includes self-loops`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let a = builder.allocateHole()
        let c = builder.allocate(Graph.Adjacency.List(adjacent: [a]))
        let b = builder.allocate(Graph.Adjacency.List(adjacent: [c]))
        builder[a] = Graph.Adjacency.List(adjacent: [b])

        let graph = builder.build()
        let closure = graph.analyze.transitiveClosure()

        var totalEdges = 0
        for node in closure.nodes {
            totalEdges += closure[node].adjacent.count
        }

        #expect(totalEdges == 9)

        #expect(closure[a].adjacent.count == 3)
        #expect(closure[b].adjacent.count == 3)
        #expect(closure[c].adjacent.count == 3)
    }

    @Test
    func `Transitive closure on empty graph`() {
        let graph = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder().build()
        let closure = graph.analyze.transitiveClosure()

        #expect(closure.isEmpty)
    }

    @Test
    func `Transitive closure preserves node count`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let c = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let b = builder.allocate(Graph.Adjacency.List(adjacent: [c]))
        _ = builder.allocate(Graph.Adjacency.List(adjacent: [b]))

        let graph = builder.build()
        let closure = graph.analyze.transitiveClosure()

        #expect(closure.count == graph.count)
    }

    @Test
    func `Transitive closure on disconnected graph`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let c = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let b = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let a = builder.allocate(Graph.Adjacency.List(adjacent: [b]))

        let graph = builder.build()
        let closure = graph.analyze.transitiveClosure()

        #expect(closure[a].adjacent.count == 1)
        #expect(closure[a].adjacent.contains(b))
        #expect(closure[b].adjacent.isEmpty)
        #expect(closure[c].adjacent.isEmpty)
    }
}
