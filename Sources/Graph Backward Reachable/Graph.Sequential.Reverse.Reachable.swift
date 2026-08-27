public import Bit_Vector
public import Buffer_Linear_Primitive
public import Buffer_Linear
public import Column
public import Hash_Indexed_Primitive
public import Ownership_Shared_Primitive
public import Set_Ordered_Primitive
public import Set_Ordered
internal import Set
public import Stack
public import Tagged_Collection
public import Tagged
import Vector

extension Graph.Sequential.Reverse {

    @inlinable
    public func reachable(
        to target: Graph.Node<Tag>
    ) -> __SetOrdered<Hash.Indexed<Column.Heap<Graph.Node<Tag>>>> {
        let count = graph.count
        var result = __SetOrdered<Hash.Indexed<Column.Heap<Graph.Node<Tag>>>>()

        guard count > .zero else { return result }

        guard target < count else { return result }

        let reversedGraph = self.reversed()

        let visited = Bit.Vector(capacity: count.retag(Bit.self))
        var stack = Stack<Graph.Node<Tag>>()

        stack.push(target)

        while let node = stack.pop() {
            let idx = node.retag(Bit.self)
            guard !visited[idx] else { continue }
            visited[idx] = true
            result.insert(node)

            let payload = reversedGraph.storage[node]
            for adjacent in payload.adjacent {
                let adjIdx = adjacent.retag(Bit.self)
                if !visited[adjIdx] {
                    stack.push(adjacent)
                }
            }
        }

        return result
    }
}
