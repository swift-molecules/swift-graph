public import Buffer_Linear_Bounded_Primitive
public import Buffer_Linear_Primitive
public import Buffer_Linear
public import Column
public import Fixed
public import Hash_Indexed_Primitive
public import Ownership_Shared_Primitive
public import Set_Ordered_Primitive
public import Set_Ordered
internal import Set
public import Tagged_Collection
public import Tagged

extension Graph.Sequential.Transform {

    @inlinable
    public func subgraph<Adjacent: Swift.Sequence<Graph.Node<Tag>>>(
        inducedBy nodes: consuming __SetOrdered<Hash.Indexed<Column.Heap<Graph.Node<Tag>>>>,
        using remap: Graph.Remappable.Remap<Payload, Tag, Adjacent>
    ) -> Graph.Sequential<Tag, Payload>? {
        let count = graph.count

        var sortedNodes = [Graph.Node<Tag>]()
        nodes.forEach { sortedNodes.append($0) }

        sortedNodes.sort(by: <)

        for node in sortedNodes {
            guard node < count else { return nil }
        }

        var oldToNew = __Fixed<Column.Bounded<Int>>(repeating: -1, count: count.retag(Int.self))
        for (newIndex, node) in sortedNodes.enumerated() {
            oldToNew[node.retag(Int.self)] = newIndex
        }

        for node in sortedNodes {
            let payload = graph.storage[node]
            for adjacent in remap.adjacent(payload) {
                guard oldToNew[adjacent.retag(Int.self)] >= 0 else { return nil }
            }
        }

        var builder = Graph.Sequential<Tag, Payload>.Builder(capacity: count)

        for node in sortedNodes {
            let oldPayload = graph.storage[node]

            let remappedPayload = remap.mapNodes(oldPayload) { oldNode in
                Graph.Node<Tag>(_unchecked: Ordinal(UInt(oldToNew[oldNode.retag(Int.self)])))
            }

            _ = builder.allocate(remappedPayload)
        }

        return builder.build()
    }
}

extension Graph.Sequential.Transform where Payload == Graph.Adjacency.List<Tag> {

    @inlinable
    public func subgraph(
        inducedBy nodes: consuming __SetOrdered<Hash.Indexed<Column.Heap<Graph.Node<Tag>>>>
    ) -> Graph.Sequential<Tag, Payload>? {
        let count = graph.count

        var sortedNodes = [Graph.Node<Tag>]()
        nodes.forEach { sortedNodes.append($0) }

        sortedNodes.sort(by: <)

        for node in sortedNodes {
            guard node < count else { return nil }
        }

        var oldToNew = __Fixed<Column.Bounded<Int>>(repeating: -1, count: count.retag(Int.self))
        for (newIndex, node) in sortedNodes.enumerated() {
            oldToNew[node.retag(Int.self)] = newIndex
        }

        var builder = Graph.Sequential<Tag, Graph.Adjacency.List<Tag>>.Builder(capacity: count)

        for node in sortedNodes {
            let oldPayload = graph.storage[node]

            var newAdjacent = [Graph.Node<Tag>]()
            for adjacent in oldPayload.adjacent {
                let newIdx = oldToNew[adjacent.retag(Int.self)]
                if newIdx >= 0 {
                    newAdjacent.append(Graph.Node<Tag>(_unchecked: Ordinal(UInt(newIdx))))
                }
            }

            _ = builder.allocate(Graph.Adjacency.List(adjacent: newAdjacent))
        }

        return builder.build()
    }
}
