public import Tagged

extension Graph.Sequential.Analyze {

    @inlinable
    public func hasCycles(from roots: some Swift.Sequence<Graph.Node<Tag>>) -> Bool {
        graph.traverse.topological(from: roots, using: extract).hasCycles
    }

    @inlinable
    public func hasCycles(from root: Graph.Node<Tag>) -> Bool {
        hasCycles(from: Swift.CollectionOfOne(root))
    }

    @inlinable
    public func hasCycles() -> Bool {
        graph.traverse.topological(using: extract).hasCycles
    }
}
