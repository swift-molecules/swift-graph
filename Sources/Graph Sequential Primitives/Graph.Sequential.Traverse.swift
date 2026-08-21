extension Graph.Sequential {

    @inlinable
    public var traverse: Traverse { Traverse(graph: self) }

    @frozen
    public struct Traverse {

        public let graph: Graph.Sequential<Tag, Payload>

        @usableFromInline
        init(graph: Graph.Sequential<Tag, Payload>) {
            self.graph = graph
        }
    }
}

extension Graph.Sequential.Traverse: Sendable where Payload: Sendable {}
