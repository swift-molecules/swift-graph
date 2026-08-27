public import Buffer_Linear_Primitive
public import Graph_Sequential

extension Graph.Sequential.Traverse.First {

    @inlinable
    public func breadth(
        from roots: some Swift.Sequence<Graph.Node<Tag>>
    ) -> Graph.Traversal.First.Breadth<Tag, Payload, Adjacent> {
        Graph.Traversal.First.Breadth(storage: graph.storage, roots: roots, extract: extract)
    }

    @inlinable
    public func breadth(
        from root: Graph.Node<Tag>
    ) -> Graph.Traversal.First.Breadth<Tag, Payload, Adjacent> {
        breadth(from: Swift.CollectionOfOne(root))
    }
}
