extension Graph.Sequential {

    @inlinable
    public var transform: Transform { Transform(graph: self) }

    @frozen
    public struct Transform {

        public let graph: Graph.Sequential<Tag, Payload>

        @usableFromInline
        init(graph: Graph.Sequential<Tag, Payload>) {
            self.graph = graph
        }
    }
}
