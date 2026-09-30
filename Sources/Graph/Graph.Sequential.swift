public import Memory_Allocator_Protocol
public import Ordinal
public import Array_Primitive
public import Array
public import Buffer_Linear_Primitive
public import Buffer_Linear
internal import Buffer
internal import Buffer_Linear_Primitive
internal import Buffer_Linear_Bounded_Primitive
internal import Buffer_Ring_Primitive
internal import Memory_Allocator_Pool
internal import Memory_Pool
internal import Memory_Allocator
internal import Memory
internal import Ownership_Shared_Primitive
internal import Storage
internal import Store
import Index
public import Ownership_Shared_Primitive
public import Collection
public import Tagged
public import Vector

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
        public var nodes: some Swift.Collection<Node<Tag>> {
            (0..<UInt(Int(bitPattern: count))).lazy.map { Node<Tag>(_unchecked: Ordinal($0)) }
        }
    }
}

extension Graph.Sequential: Sendable where Tag: ~Copyable & ~Escapable, Payload: Sendable {}
