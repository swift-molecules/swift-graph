public import Array_Primitive
public import Array
public import Bit_Vector
public import Buffer_Linear_Primitive
public import Buffer_Linear
public import Buffer_Ring_Primitive
public import Column
internal import Iterator
public import Ownership_Shared_Primitive
public import Queue_Primitive
public import Queue
public import Tagged_Collection
public import Tagged
import Vector

extension Graph.Traversal.First {

    @safe
    @frozen
    public struct Breadth<
        Tag: ~Copyable & ~Escapable,
        Payload,
        Adjacent: Swift.Sequence<Graph.Node<Tag>>
    >: ~Copyable, Iterator.Chunk.`Protocol` {

        public typealias Element = (node: Graph.Node<Tag>, payload: Payload)

        public typealias Failure = Never

        @safe
        @usableFromInline
        final class _ElementBox {
            @usableFromInline
            let pointer: UnsafeMutablePointer<Element>

            @usableFromInline
            var isInitialized: Bool = false

            @usableFromInline
            init() {
                unsafe pointer = .allocate(capacity: 1)
            }

            deinit {
                if isInitialized {
                    unsafe pointer.deinitialize(count: 1)
                }
                unsafe pointer.deallocate()
            }
        }

        @usableFromInline
        let storage: Tagged<Tag, Array<Payload>.Shared>

        @usableFromInline
        let extract: Graph.Adjacency.Extract<Payload, Tag, Adjacent>

        @usableFromInline
        var queue: __Queue<Column.Ring<Graph.Node<Tag>>>

        @usableFromInline
        var visited: Bit.Vector

        @usableFromInline
        let _elementBox: _ElementBox

        @usableFromInline
        init(
            storage: Tagged<Tag, Array<Payload>.Shared>,
            roots: some Swift.Sequence<Graph.Node<Tag>>,
            extract: Graph.Adjacency.Extract<Payload, Tag, Adjacent>
        ) {
            self.storage = storage
            self.extract = extract
            self.queue = Queue()
            self.visited = Bit.Vector(capacity: storage.count.retag(Bit.self))
            self._elementBox = _ElementBox()

            for root in roots {
                let idx = root.retag(Bit.self)
                if !visited[idx] {
                    visited[idx] = true
                    queue.enqueue(root)
                }
            }
        }

        @_lifetime(&self)
        @inlinable
        public mutating func next(
            maximumCount: some Carrier.`Protocol`<Cardinal>
        ) -> Swift.Span<Element> {

            let box = _elementBox
            let pointer = unsafe box.pointer
            guard maximumCount.underlying > .zero else {
                let span = unsafe Span(_unsafeStart: pointer, count: 0)
                return unsafe _overrideLifetime(span, mutating: &self)
            }
            guard let value = next() else {
                let span = unsafe Span(_unsafeStart: pointer, count: 0)
                return unsafe _overrideLifetime(span, mutating: &self)
            }
            if box.isInitialized {
                unsafe pointer.pointee = value
            } else {
                unsafe pointer.initialize(to: value)
                box.isInitialized = true
            }
            let span = unsafe Span(_unsafeStart: pointer, count: 1)
            return unsafe _overrideLifetime(span, mutating: &self)
        }

        @inlinable
        public mutating func next() -> Element? {
            guard let node = queue.dequeue() else { return nil }

            let payload = storage[node]

            for adjacent in extract.adjacent(payload) {
                let idx = adjacent.retag(Bit.self)
                if !visited[idx] {
                    visited[idx] = true
                    queue.enqueue(adjacent)
                }
            }

            return (node, payload)
        }
    }
}
