public import Bit_Vector
public import Buffer_Linear_Bounded_Primitive
public import Buffer_Linear_Primitive
public import Buffer_Linear
public import Column
public import Fixed_Primitive
public import Fixed
public import Ownership_Shared_Primitive
public import Stack
public import Tagged_Collection
public import Tagged
public import Vector

extension Graph.Sequential.Analyze {

    @inlinable
    public func transitiveClosure() -> Graph.Sequential<Tag, Graph.Adjacency.List<Tag>> {
        let count = graph.count
        guard count > .zero else {
            let builder = Graph.Sequential<Tag, Graph.Adjacency.List<Tag>>.Builder()
            return builder.build()
        }

        var closureAdjacent = __Fixed<Column.Bounded<[Graph.Node<Tag>]>>(
            repeating: [],
            count: count.retag([Graph.Node<Tag>].self)
        )

        for source in graph.nodes {
            let visited = Bit.Vector(capacity: count.retag(Bit.self))
            var stack = Stack<Graph.Node<Tag>>()

            let sourcePayload = graph.storage[source]
            for adjacent in extract.adjacent(sourcePayload) {
                stack.push(adjacent)
            }

            while let node = stack.pop() {
                let idx = node.retag(Bit.self)
                guard !visited[idx] else { continue }
                visited[idx] = true

                closureAdjacent[source.retag([Graph.Node<Tag>].self)].append(node)

                let payload = graph.storage[node]
                for adjacent in extract.adjacent(payload) {
                    let adjIdx = adjacent.retag(Bit.self)
                    if !visited[adjIdx] {
                        stack.push(adjacent)
                    }
                }
            }
        }

        var builder = Graph.Sequential<Tag, Graph.Adjacency.List<Tag>>.Builder(capacity: count)
        for source in graph.nodes {
            _ = builder.allocate(
                Graph.Adjacency.List(
                    adjacent: closureAdjacent[source.retag([Graph.Node<Tag>].self)]
                )
            )
        }

        return builder.build()
    }
}
