extension Graph.Default {

    @inlinable
    public static func list<Tag: ~Copyable & ~Escapable>() -> Value<Graph.Adjacency.List<Tag>> {
        Value(Graph.Adjacency.List(adjacent: []))
    }
}
