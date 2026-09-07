public import Bit_Vector
public import Buffer_Linear_Bounded_Primitive
public import Buffer_Linear_Primitive
public import Buffer_Linear
public import Column
public import Fixed
public import Heap_Primitive
public import Ownership_Shared_Primitive
public import Tagged_Collection
public import Tagged
import Vector

extension Graph.Sequential.Path {

    @usableFromInline
    struct Entry: Comparison.`Protocol`, Sendable {
        @usableFromInline let node: Graph.Node<Tag>
        @usableFromInline let distance: Int

        @usableFromInline
        init(node: Graph.Node<Tag>, distance: Int) {
            self.node = node
            self.distance = distance
        }

        @usableFromInline
        static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.distance < rhs.distance
        }

        @usableFromInline
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.distance == rhs.distance && lhs.node == rhs.node
        }
    }
}

extension Graph.Sequential.Path {

    @inlinable
    public func weighted(
        from source: Graph.Node<Tag>,
        to target: Graph.Node<Tag>,
        weight: (Payload, Graph.Node<Tag>) -> Int
    ) -> (path: [Graph.Node<Tag>], distance: Int)? {
        let count = graph.count
        guard count > .zero else { return nil }

        guard source < count else { return nil }
        guard target < count else { return nil }

        if source == target { return ([source], 0) }

        var heap = Heap<Entry>()
        let visited = Bit.Vector(capacity: count.retag(Bit.self))
        var distances = __Fixed<Column.Bounded<Int>>(
            repeating: Int.max,
            count: count.retag(Int.self)
        )
        var predecessors = __Fixed<Column.Bounded<Graph.Node<Tag>?>>(
            repeating: nil,
            count: count.retag((Graph.Node<Tag>?).self)
        )

        distances[source.retag(Int.self)] = 0
        heap.push(Entry(node: source, distance: 0))

        while let entry = heap.pop() {

            let entryIdx = entry.node.retag(Bit.self)
            guard !visited[entryIdx] else { continue }
            visited[entryIdx] = true

            if entry.node == target {
                return (
                    reconstructWeightedPath(to: target, predecessors: predecessors, source: source),
                    entry.distance
                )
            }

            let payload = graph.storage[entry.node]
            for adjacent in extract.adjacent(payload) {
                let adjIdx = adjacent.retag(Bit.self)
                guard !visited[adjIdx] else { continue }

                let edgeWeight = weight(payload, adjacent)
                let newDist = entry.distance + edgeWeight

                if newDist < distances[adjacent.retag(Int.self)] {
                    distances[adjacent.retag(Int.self)] = newDist
                    predecessors[adjacent.retag((Graph.Node<Tag>?).self)] = entry.node
                    heap.push(Entry(node: adjacent, distance: newDist))
                }
            }
        }

        return nil
    }

    @usableFromInline
    func reconstructWeightedPath(
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
