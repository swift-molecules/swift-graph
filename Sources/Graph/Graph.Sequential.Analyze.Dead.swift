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
public import Vector

extension Graph.Sequential.Analyze {

    @inlinable
    public func dead(
        from roots: some Swift.Sequence<Graph.Node<Tag>>
    ) -> __SetOrdered<Hash.Indexed<Column.Heap<Graph.Node<Tag>>>> {
        let count = graph.count
        var result = __SetOrdered<Hash.Indexed<Column.Heap<Graph.Node<Tag>>>>()

        guard count > .zero else { return result }

        let visited = Bit.Vector(capacity: count.retag(Bit.self))
        var stack = Stack<Graph.Node<Tag>>()

        for root in roots {
            let idx = root.retag(Bit.self)
            if root < count && !visited[idx] {
                stack.push(root)
            }
        }

        while let node = stack.pop() {
            let idx = node.retag(Bit.self)
            guard !visited[idx] else { continue }
            visited[idx] = true

            let payload = graph.storage[node]
            for adjacent in extract.adjacent(payload) {
                let adjIdx = adjacent.retag(Bit.self)
                if !visited[adjIdx] {
                    stack.push(adjacent)
                }
            }
        }

        for node in graph.nodes {
            let idx = node.retag(Bit.self)
            if !visited[idx] {
                result.insert(node)
            }
        }

        return result
    }
}
