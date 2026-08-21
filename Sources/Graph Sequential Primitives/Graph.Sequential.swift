public import Array_Primitive
public import Array_Primitives
public import Buffer_Linear_Primitive
public import Buffer_Linear_Primitives
internal import Column_Primitives
import Index_Primitives
public import Ownership_Shared_Primitive
public import Tagged_Collection_Primitives
public import Tagged_Primitives
public import Vector_Primitives

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
        public var nodes: Vector<Node<Tag>> {
            Vector(count: count.retag(Vector<Node<Tag>>.self)) { vIndex in
                Node<Tag>(_unchecked: vIndex.position)
            }
        }
    }
}

extension Graph.Sequential: Sendable where Tag: ~Copyable & ~Escapable, Payload: Sendable {}
