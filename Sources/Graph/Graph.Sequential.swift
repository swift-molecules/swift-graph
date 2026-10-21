public import Array
public import Array_Primitive
internal import Buffer
public import Buffer_Linear
internal import Buffer_Linear_Bounded_Primitive
public import Buffer_Linear_Primitive
internal import Buffer_Ring_Primitive
public import Collection
import Index
internal import Memory
internal import Memory_Allocator
internal import Memory_Allocator_Pool
public import Memory_Allocator_Protocol
internal import Memory_Pool
public import Ordinal
public import Ownership_Shared_Primitive
internal import Storage
internal import Store
public import Tagged
internal import Vector

extension Graph {

    @frozen
    public struct Sequential<Tag: ~Copyable & ~Escapable, Payload> {

        public let storage: Tagged<Tag, Array<Payload>.Shared>

        @usableFromInline
        init(storage: Tagged<Tag, Array<Payload>.Shared>) {
            self.storage = storage
        }

        @inlinable
        public var count: Node<Tag>.Count {
            storage.count
        }

        @inlinable
        public var isEmpty: Bool { storage.isEmpty }

        @inlinable
        public subscript(node: Node<Tag>) -> Payload {
            storage[node]
        }

        @inlinable
        public var nodes: some Swift::Collection<Node<Tag>> {
            (0..<UInt(Int(bitPattern: count))).lazy.map { Node<Tag>(_unchecked: Ordinal($0)) }
        }
    }
}

extension Graph.Sequential: Sendable where Tag: ~Copyable & ~Escapable, Payload: Sendable {}
