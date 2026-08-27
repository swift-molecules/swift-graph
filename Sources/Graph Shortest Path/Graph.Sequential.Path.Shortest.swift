public import Bit_Vector
public import Buffer_Linear_Bounded_Primitive
public import Buffer_Linear_Primitive
public import Buffer_Linear
public import Buffer_Ring_Primitive
public import Column
public import Fixed_Primitive
public import Fixed
public import Ownership_Shared_Primitive
public import Queue_Primitive
public import Queue
public import Tagged_Collection
public import Tagged
import Vector

extension Graph.Sequential.Path {

    @inlinable
    public func shortest(
        from source: Graph.Node<Tag>,
        to target: Graph.Node<Tag>
    ) -> [Graph.Node<Tag>]? {
        let count = graph.count
        guard count > .zero else { return nil }

        guard source < count else { return nil }
        guard target < count else { return nil }

        if source == target { return [source] }

        let visited = Bit.Vector(capacity: count.retag(Bit.self))
        var predecessors = __Fixed<Column.Bounded<Graph.Node<Tag>?>>(
            repeating: nil,
            count: count.retag((Graph.Node<Tag>?).self)
        )
        var queue = __Queue<Column.Ring<Graph.Node<Tag>>>()

        visited[source.retag(Bit.self)] = true
        queue.enqueue(source)

        while let node = queue.dequeue() {
            let payload = graph.storage[node]
            for adjacent in extract.adjacent(payload) {
                let adjIdx = adjacent.retag(Bit.self)
                if !visited[adjIdx] {
                    visited[adjIdx] = true
                    predecessors[adjacent.retag((Graph.Node<Tag>?).self)] = node
                    queue.enqueue(adjacent)

                    if adjacent == target {

                        return reconstructPath(
                            to: target,
                            predecessors: predecessors,
                            source: source
                        )
                    }
                }
            }
        }

        return nil
    }

    @usableFromInline
    func reconstructPath(
        to target: Graph.Node<Tag>,
        predecessors: borrowing __Fixed<Column.Bounded<Graph.Node<Tag>?>>,
        source: Graph.Node<Tag>
    ) -> [Graph.Node<Tag>] {
        var path = [Graph.Node<Tag>]()
        var current: Graph.Node<Tag>? = target

        while let node = current {
            path.append(node)
            if node == source { break }
            current = predecessors[node.retag((Graph.Node<Tag>?).self)]
        }

        path.reverse()
        return path
    }
}
