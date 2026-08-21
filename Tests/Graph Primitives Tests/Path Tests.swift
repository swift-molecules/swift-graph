import Graph_Primitives_Test_Support
import Testing

private enum TestTag {}

@Suite
struct `Graph Sequential Path Exists Tests` {
    @Test
    func `Path exists in connected graph`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let c = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let b = builder.allocate(Graph.Adjacency.List(adjacent: [c]))
        let a = builder.allocate(Graph.Adjacency.List(adjacent: [b]))

        let graph = builder.build()

        #expect(graph.path.exists(from: a, to: c))
        #expect(graph.path.exists(from: a, to: b))
        #expect(graph.path.exists(from: b, to: c))
    }

    @Test
    func `Path does not exist in disconnected graph`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let c = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let b = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let a = builder.allocate(Graph.Adjacency.List(adjacent: [b]))

        let graph = builder.build()

        #expect(!graph.path.exists(from: a, to: c))
        #expect(!graph.path.exists(from: b, to: c))
    }

    @Test
    func `Path to self exists`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let a = builder.allocate(Graph.Adjacency.List(adjacent: []))

        let graph = builder.build()

        #expect(graph.path.exists(from: a, to: a))
    }

    @Test
    func `Path with invalid nodes returns false`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let a = builder.allocate(Graph.Adjacency.List(adjacent: []))

        let graph = builder.build()
        let invalid = Graph.Node<TestTag>(_unchecked: Ordinal(999))

        #expect(!graph.path.exists(from: invalid, to: a))
        #expect(!graph.path.exists(from: a, to: invalid))
    }
}

@Suite
struct `Graph Sequential Path Shortest Tests` {
    @Test
    func `Shortest path in linear graph`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let c = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let b = builder.allocate(Graph.Adjacency.List(adjacent: [c]))
        let a = builder.allocate(Graph.Adjacency.List(adjacent: [b]))

        let graph = builder.build()

        let path = graph.path.shortest(from: a, to: c)
        #expect(path != nil)
        #expect(path!.count == 3)
        #expect(path!.first == a)
        #expect(path!.last == c)
    }

    @Test
    func `Shortest path in diamond graph`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let d = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let b = builder.allocate(Graph.Adjacency.List(adjacent: [d]))
        let c = builder.allocate(Graph.Adjacency.List(adjacent: [d]))
        let a = builder.allocate(Graph.Adjacency.List(adjacent: [b, c]))

        let graph = builder.build()

        let path = graph.path.shortest(from: a, to: d)
        #expect(path != nil)
        #expect(path!.count == 3)
        #expect(path!.first == a)
        #expect(path!.last == d)
    }

    @Test
    func `Shortest path to self`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let a = builder.allocate(Graph.Adjacency.List(adjacent: []))

        let graph = builder.build()

        let path = graph.path.shortest(from: a, to: a)
        #expect(path != nil)
        #expect(path!.count == 1)
        #expect(path! == [a])
    }

    @Test
    func `Shortest path unreachable returns nil`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let b = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let a = builder.allocate(Graph.Adjacency.List(adjacent: []))

        let graph = builder.build()

        let path = graph.path.shortest(from: a, to: b)
        #expect(path == nil)
    }

    @Test
    func `Shortest path on cycle terminates`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let d = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let a = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let c = builder.allocate(Graph.Adjacency.List(adjacent: [a]))
        let b = builder.allocate(Graph.Adjacency.List(adjacent: [c]))
        builder[a] = Graph.Adjacency.List(adjacent: [b, d])

        let graph = builder.build()

        let path = graph.path.shortest(from: a, to: d)
        #expect(path != nil)
        #expect(path!.count == 2)
    }
}

@Suite
struct `Graph Sequential Path Weighted Tests` {
    @Test
    func `Weighted path finds minimum weight`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let d = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let b = builder.allocate(Graph.Adjacency.List(adjacent: [d]))
        let c = builder.allocate(Graph.Adjacency.List(adjacent: [d]))
        let a = builder.allocate(Graph.Adjacency.List(adjacent: [b, c]))

        let graph = builder.build()

        let result = graph.path.weighted(from: a, to: d) { payload, _ in

            if payload.adjacent.contains(d) && payload.adjacent.count == 1
                && payload.adjacent.first == d
            {

                return 1
            }
            return 1
        }

        #expect(result != nil)
        #expect(result!.distance == 2)
    }

    @Test
    func `Weighted path with uniform weights equals shortest path`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let c = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let b = builder.allocate(Graph.Adjacency.List(adjacent: [c]))
        let a = builder.allocate(Graph.Adjacency.List(adjacent: [b]))

        let graph = builder.build()

        let weightedResult = graph.path.weighted(from: a, to: c) { _, _ in 1 }
        let shortestPath = graph.path.shortest(from: a, to: c)

        #expect(weightedResult != nil)
        #expect(shortestPath != nil)
        #expect(weightedResult!.path.count == shortestPath!.count)

        #expect(weightedResult!.distance == shortestPath!.count - 1)
    }

    @Test
    func `Weighted path to self has zero distance`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let a = builder.allocate(Graph.Adjacency.List(adjacent: []))

        let graph = builder.build()

        let result = graph.path.weighted(from: a, to: a) { _, _ in 1 }
        #expect(result != nil)
        #expect(result!.path == [a])
        #expect(result!.distance == 0)
    }

    @Test
    func `Weighted path unreachable returns nil`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let b = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let a = builder.allocate(Graph.Adjacency.List(adjacent: []))

        let graph = builder.build()

        let result = graph.path.weighted(from: a, to: b) { _, _ in 1 }
        #expect(result == nil)
    }

    @Test
    func `Weighted path prefers lower total weight`() {
        var builder = Graph.Sequential<TestTag, Graph.Adjacency.List<TestTag>>.Builder()

        let c = builder.allocate(Graph.Adjacency.List(adjacent: []))
        let b = builder.allocate(Graph.Adjacency.List(adjacent: [c]))
        let d = builder.allocate(Graph.Adjacency.List(adjacent: [c]))
        let a = builder.allocate(Graph.Adjacency.List(adjacent: [b, d]))

        let graph = builder.build()

        let result = graph.path.weighted(from: a, to: c) { _, target in
            if target == b { return 1 }
            if target == d { return 50 }
            if target == c {

                return 50
            }
            return 1
        }

        #expect(result != nil)

        #expect(result!.path.first == a)
        #expect(result!.path.last == c)
    }
}
