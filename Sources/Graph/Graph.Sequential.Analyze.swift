public import Tagged

extension Graph.Sequential {

    @inlinable
    public func analyze<Adjacent: Swift.Sequence<Graph.Node<Tag>>>(
        using extract: Graph.Adjacency.Extract<Payload, Tag, Adjacent>
    ) -> Analyze<Adjacent> {
        Analyze(graph: self, extract: extract)
    }

    @frozen
    public struct Analyze<Adjacent: Swift.Sequence<Graph.Node<Tag>>> {

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

extension Graph.Sequential where Payload == Graph.Adjacency.List<Tag> {

    @inlinable
    public var analyze: Analyze<[Graph.Node<Tag>]> {
        analyze(using: .list)
    }
}
