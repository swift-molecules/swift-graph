public import Array_Primitive
internal import Array
import Bit_Vector
public import Buffer_Linear_Primitive
import Buffer_Linear
internal import Column
internal import Ownership_Shared_Primitive
import Stack
import Tagged_Collection
public import Tagged
import Vector

extension Graph.Traversal {

    @frozen
    public struct Topological<
        Tag: ~Copyable & ~Escapable,
        Payload,
        Adjacent: Swift.Sequence<Graph.Node<Tag>>
    >: Swift.Sequence {

        public typealias Element = (node: Graph.Node<Tag>, payload: Payload)

        @usableFromInline
        let elements: [(node: Graph.Node<Tag>, payload: Payload)]?

        @usableFromInline
        init(
            storage: Tagged<Tag, Array<Payload>.Shared>,
            roots: some Swift.Sequence<Graph.Node<Tag>>,
            extract: Graph.Adjacency.Extract<Payload, Tag, Adjacent>
        ) {
            self.elements = Self.computeOrder(storage: storage, roots: roots, extract: extract)
        }

        @usableFromInline
        static func computeOrder(
            storage: Tagged<Tag, Array<Payload>.Shared>,
            roots: some Swift.Sequence<Graph.Node<Tag>>,
            extract: Graph.Adjacency.Extract<Payload, Tag, Adjacent>
        ) -> [Element]? {
            let count = storage.count
            guard count > .zero else { return [] }

            let visited = Bit.Vector(capacity: count.retag(Bit.self))
            let visiting = Bit.Vector(capacity: count.retag(Bit.self))
            var result: [Element] = []
            result.reserveCapacity(count)

            var stack = Stack<(node: Graph.Node<Tag>, entering: Bool)>()

            for root in roots {
                let rootIdx = root.retag(Bit.self)
                if visited[rootIdx] { continue }

                stack.push((root, true))

                while let (node, entering) = stack.pop() {
                    let nodeIdx = node.retag(Bit.self)

                    if entering {

                        if visited[nodeIdx] { continue }
                        if visiting[nodeIdx] {

                            return nil
                        }

                        visiting[nodeIdx] = true

                        stack.push((node, false))

                        let payload = storage[node]
                        for adjacent in extract.adjacent(payload) {
                            let adjIdx = adjacent.retag(Bit.self)
                            if !visited[adjIdx] && !visiting[adjIdx] {
                                stack.push((adjacent, true))
                            } else if visiting[adjIdx] {

                                return nil
                            }
                        }
                    } else {

                        visiting[nodeIdx] = false
                        visited[nodeIdx] = true
                        result.append((node, storage[node]))
                    }
                }
            }

            result.reverse()
            return result
        }

        @inlinable
        public var hasCycles: Bool { elements == nil }

        @inlinable
        public func makeIterator() -> IndexingIterator<[Element]> {
            (elements ?? []).makeIterator()
        }
    }
}
