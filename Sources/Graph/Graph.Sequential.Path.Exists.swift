public import Bit_Vector
public import Buffer_Linear_Primitive
public import Buffer_Linear
public import Buffer_Ring_Primitive
public import Column
public import Ownership_Shared_Primitive
public import Queue_Primitive
public import Queue
public import Tagged_Collection
public import Tagged
import Vector

extension Graph.Sequential.Path {

    @inlinable
    public func exists(from source: Graph.Node<Tag>, to target: Graph.Node<Tag>) -> Bool {
        let count = graph.count
        guard count > .zero else { return false }

        guard source < count else { return false }
        guard target < count else { return false }

        if source == target { return true }

        let visited = Bit.Vector(capacity: count.retag(Bit.self))
        var queue = __Queue<Column.Ring<Graph.Node<Tag>>>()

        visited[source.retag(Bit.self)] = true
        queue.enqueue(source)

        while let node = queue.dequeue() {
            let payload = graph.storage[node]
            for adjacent in extract.adjacent(payload) {
                if adjacent == target {
                    return true
                }
                let adjIdx = adjacent.retag(Bit.self)
                if !visited[adjIdx] {
                    visited[adjIdx] = true
                    queue.enqueue(adjacent)
                }
            }
        }

        return false
    }
}
