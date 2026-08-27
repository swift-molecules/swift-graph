public import Buffer_Linear_Primitive
public import Vector

extension Graph.Sequential.Traverse {

    @inlinable
    public func topological<Adjacent: Swift.Sequence<Graph.Node<Tag>>>(
        from roots: some Swift.Sequence<Graph.Node<Tag>>,
        using extract: Graph.Adjacency.Extract<Payload, Tag, Adjacent>
    ) -> Graph.Traversal.Topological<Tag, Payload, Adjacent> {
        Graph.Traversal.Topological(storage: graph.storage, roots: roots, extract: extract)
    }

    @inlinable
    public func topological<Adjacent: Swift.Sequence<Graph.Node<Tag>>>(
        from root: Graph.Node<Tag>,
        using extract: Graph.Adjacency.Extract<Payload, Tag, Adjacent>
    ) -> Graph.Traversal.Topological<Tag, Payload, Adjacent> {
        topological(from: Swift.CollectionOfOne(root), using: extract)
    }

    @inlinable
    public func topological<Adjacent: Swift.Sequence<Graph.Node<Tag>>>(
        using extract: Graph.Adjacency.Extract<Payload, Tag, Adjacent>
    ) -> Graph.Traversal.Topological<Tag, Payload, Adjacent> {
        topological(from: graph.nodes, using: extract)
    }
}

extension Graph.Sequential.Traverse where Payload == Graph.Adjacency.List<Tag> {

    @inlinable
    public func topological(
        from roots: some Swift.Sequence<Graph.Node<Tag>>
    ) -> Graph.Traversal.Topological<Tag, Payload, [Graph.Node<Tag>]> {
        topological(from: roots, using: .list)
    }

    @inlinable
    public func topological(
        from root: Graph.Node<Tag>
    ) -> Graph.Traversal.Topological<Tag, Payload, [Graph.Node<Tag>]> {
        topological(from: Swift.CollectionOfOne(root), using: .list)
    }

    @inlinable
    public func topological() -> Graph.Traversal.Topological<Tag, Payload, [Graph.Node<Tag>]> {
        topological(from: graph.nodes, using: .list)
    }
}
