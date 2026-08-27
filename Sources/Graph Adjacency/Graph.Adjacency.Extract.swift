extension Graph.Adjacency {

    @frozen
    public struct Extract<
        Payload,
        Tag: ~Copyable & ~Escapable,
        Adjacent: Swift.Sequence<Graph.Node<Tag>>
    > {
        @usableFromInline
        let _adjacent: (Payload) -> Adjacent

        @inlinable
        public init(adjacent: @escaping (Payload) -> Adjacent) {
            self._adjacent = adjacent
        }

        @inlinable
        public func adjacent(_ payload: Payload) -> Adjacent {
            _adjacent(payload)
        }
    }
}
