public import Vector_Primitives

extension Graph.Sequential.Transform {

    @inlinable
    public func payloads<NewPayload>(
        _ transform: (Payload) -> NewPayload
    ) -> Graph.Sequential<Tag, NewPayload> {
        var builder = Graph.Sequential<Tag, NewPayload>.Builder(capacity: graph.count)
        for node in graph.nodes {
            _ = builder.allocate(transform(graph[node]))
        }
        return builder.build()
    }
}
