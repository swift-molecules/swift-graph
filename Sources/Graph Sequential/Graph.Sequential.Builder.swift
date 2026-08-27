public import Array_Primitive
public import Array
public import Buffer_Linear_Primitive
internal import Column
import Index
public import Ownership_Shared_Primitive
import Tagged_Collection
public import Tagged

extension Graph.Sequential {

    @frozen
    public struct Builder: ~Copyable {
        @usableFromInline
        var storage: Array<Payload>.Shared

        @inlinable
        public init() {

            self.storage = Array<Payload>.Shared()
        }

        @inlinable
        public init(capacity: Graph.Node<Tag>.Count) {

            self.storage = Array<Payload>.Shared(initialCapacity: capacity.retag(Payload.self))
        }

        @inlinable
        public var count: Graph.Node<Tag>.Count {
            storage.count.retag(Tag.self)
        }

        @inlinable
        public mutating func allocate(_ payload: Payload) -> Graph.Node<Tag> {
            let id = count.map(Ordinal.init)
            storage.append(payload)
            return id
        }

        @inlinable
        public subscript(node: Graph.Node<Tag>) -> Payload {
            get { storage[node.retag(Payload.self)] }
            set { storage[node.retag(Payload.self)] = newValue }
        }

        @inlinable
        public consuming func build() -> Graph.Sequential<Tag, Payload> {
            Graph.Sequential(storage: Tagged<Tag, Array<Payload>.Shared>(storage))
        }
    }
}

extension Graph.Sequential.Builder {

    @inlinable
    public mutating func allocateHole(
        using default: Graph.Default.Value<Payload>
    ) -> Graph.Node<Tag> {
        allocate(`default`.value)
    }

    @inlinable
    public mutating func fill(_ node: Graph.Node<Tag>, with payload: Payload) {
        storage[node.retag(Payload.self)] = payload
    }
}

extension Graph.Sequential.Builder where Payload == Graph.Adjacency.List<Tag> {

    @inlinable
    public mutating func allocateHole() -> Graph.Node<Tag> {
        allocateHole(using: Graph.Default.list())
    }
}
