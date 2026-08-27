public import Tagged

extension Graph.Sequential.Traverse {

    @inlinable
    public func first<Adjacent: Swift.Sequence<Graph.Node<Tag>>>(
        using extract: Graph.Adjacency.Extract<Payload, Tag, Adjacent>
    ) -> First<Adjacent> {
        First(graph: graph, extract: extract)
    }

    @frozen
    public struct First<Adjacent: Swift.Sequence<Graph.Node<Tag>>> {

        public let graph: Graph.Sequential<Tag, Payload>

        public let extract: Graph.Adjacency.Extract<Payload, Tag, Adjacent>

        @usableFromInline
        init(
            graph: Graph.Sequential<Tag, Payload>,
            extract: Graph.Adjacency.Extract<Payload, Tag, Adjacent>
        ) {
            self.graph = graph
            self.extract = extract
        }
    }
}

extension Graph.Sequential.Traverse where Payload == Graph.Adjacency.List<Tag> {

    @inlinable
    public var first: First<[Graph.Node<Tag>]> {
        first(using: .list)
    }
}
