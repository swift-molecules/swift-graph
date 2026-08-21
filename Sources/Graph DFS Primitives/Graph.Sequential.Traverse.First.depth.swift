public import Buffer_Linear_Primitive
public import Graph_Sequential_Primitives
import Ownership_Shared_Primitive

extension Graph.Sequential.Traverse.First {

    @inlinable
    public func depth(
        from roots: some Swift.Sequence<Graph.Node<Tag>>
    ) -> Graph.Traversal.First.Depth<Tag, Payload, Adjacent> {
        Graph.Traversal.First.Depth(storage: graph.storage, roots: roots, extract: extract)
    }

    @inlinable
    public func depth(
        from root: Graph.Node<Tag>
    ) -> Graph.Traversal.First.Depth<Tag, Payload, Adjacent> {
        depth(from: Swift.CollectionOfOne(root))
    }
}
