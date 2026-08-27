import Graph
import Testing

private enum StormTag {}

private struct StormPayload: Sendable {
    let id: Int
    let successors: [Graph.Node<StormTag>]
}

extension StormPayload {
    static var extract: Graph.Adjacency.Extract<StormPayload, StormTag, [Graph.Node<StormTag>]> {
        Graph.Adjacency.Extract { $0.successors }
    }
}

private func buildLayeredGraph(
    layers: Int,
    width: Int
) -> (graph: Graph.Sequential<StormTag, StormPayload>, root: Graph.Node<StormTag>) {
    var builder = Graph.Sequential<StormTag, StormPayload>.Builder()
    var previous: [Graph.Node<StormTag>] = []
    var id = 0
    for _ in 0..<layers {
        var current: [Graph.Node<StormTag>] = []
        for _ in 0..<width {
            current.append(builder.allocate(StormPayload(id: id, successors: previous)))
            id += 1
        }
        previous = current
    }
    let root = builder.allocate(StormPayload(id: id, successors: previous))
    return (builder.build(), root)
}

private func depthOrder(
    _ graph: Graph.Sequential<StormTag, StormPayload>,
    from root: Graph.Node<StormTag>
) -> [Int] {
    var iter = graph.traverse.first(using: StormPayload.extract).depth(from: root)
    var visited: [Int] = []
    while let element = iter.next() { visited.append(element.payload.id) }
    return visited
}

private func breadthOrder(
    _ graph: Graph.Sequential<StormTag, StormPayload>,
    from root: Graph.Node<StormTag>
) -> [Int] {
    var iter = graph.traverse.first(using: StormPayload.extract).breadth(from: root)
    var visited: [Int] = []
    while let element = iter.next() { visited.append(element.payload.id) }
    return visited
}

@Suite
struct `Graph Sequential Concurrency (W3 rider) Tests` {

    @Test(arguments: [4, 16])
    func `concurrent traversals are bit-exact against the sequential references`(width: Int) async {
        let (graph, root) = buildLayeredGraph(layers: 6, width: 5)
        let depthReference = depthOrder(graph, from: root)
        let breadthReference = breadthOrder(graph, from: root)
        #expect(depthReference.count == 31)
        #expect(breadthReference.count == 31)
        let outcomes = await withTaskGroup(of: Bool.self, returning: [Bool].self) { group in
            for t in 0..<width {
                group.addTask {
                    var good = true
                    for _ in 0..<25 {
                        if t % 2 == 0 {
                            good = good && (depthOrder(graph, from: root) == depthReference)
                        } else {
                            good = good && (breadthOrder(graph, from: root) == breadthReference)
                        }
                    }
                    return good
                }
            }
            var out: [Bool] = []
            for await ok in group { out.append(ok) }
            return out
        }
        #expect(outcomes.count == width)
        #expect(outcomes.allSatisfy { $0 })
    }

    @Test
    func `traversals stay exact while sibling copies churn the boxes' refcounts`() async {
        let (graph, root) = buildLayeredGraph(layers: 5, width: 4)
        let depthReference = depthOrder(graph, from: root)
        let breadthReference = breadthOrder(graph, from: root)
        let outcomes = await withTaskGroup(of: Bool.self, returning: [Bool].self) { group in
            for _ in 0..<6 {
                group.addTask {
                    var good = true
                    for _ in 0..<30 {
                        good =
                            good && (depthOrder(graph, from: root) == depthReference)
                            && (breadthOrder(graph, from: root) == breadthReference)
                    }
                    return good
                }
            }
            for _ in 0..<6 {
                group.addTask {
                    var good = true
                    for _ in 0..<150 {
                        let copy = graph
                        var iter = copy.traverse.first(using: StormPayload.extract).depth(
                            from: root
                        )
                        good = good && (iter.next()?.payload.id == depthReference[0])
                    }
                    return good
                }
            }
            var out: [Bool] = []
            for await ok in group { out.append(ok) }
            return out
        }
        #expect(outcomes.count == 12)
        #expect(outcomes.allSatisfy { $0 })

        let depthAfter = depthOrder(graph, from: root)
        #expect(depthAfter == depthReference)
    }
}
