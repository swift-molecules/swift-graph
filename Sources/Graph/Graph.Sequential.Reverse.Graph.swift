public import Buffer_Linear_Bounded_Primitive
public import Buffer_Linear_Primitive
public import Buffer_Linear
public import Column
public import Fixed_Primitive
public import Fixed
public import Ownership_Shared_Primitive
public import Tagged_Collection
public import Tagged
public import Vector

extension Graph.Sequential.Reverse {

    @inlinable
    public func reversed() -> Graph.Sequential<Tag, Graph.Adjacency.List<Tag>> {
        let count = graph.count
        guard count > .zero else {
            let builder = Graph.Sequential<Tag, Graph.Adjacency.List<Tag>>.Builder()
            return builder.build()
        }

        var reversedAdjacent = __Fixed<Column.Bounded<[Graph.Node<Tag>]>>(
            repeating: [],
            count: count.retag([Graph.Node<Tag>].self)
        )

        for source in graph.nodes {
            let payload = graph.storage[source]

            for target in extract.adjacent(payload) {

                reversedAdjacent[target.retag([Graph.Node<Tag>].self)].append(source)
            }
        }

        var builder = Graph.Sequential<Tag, Graph.Adjacency.List<Tag>>.Builder(capacity: count)
        for source in graph.nodes {
            _ = builder.allocate(
                Graph.Adjacency.List(
                    adjacent: reversedAdjacent[source.retag([Graph.Node<Tag>].self)]
                )
            )
        }

        return builder.build()
    }
}
