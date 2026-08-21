extension Graph.Adjacency {

    @frozen
    public struct List<Tag: ~Copyable & ~Escapable>: Sendable {

        public var adjacent: [Graph.Node<Tag>]

        @inlinable
        public init(adjacent: [Graph.Node<Tag>] = []) {
            self.adjacent = adjacent
        }
    }
}

extension Graph.Adjacency.Extract
where Payload == Graph.Adjacency.List<Tag>, Adjacent == [Graph.Node<Tag>] {

    @inlinable
    public static var list: Self {
        Self { $0.adjacent }
    }
}
