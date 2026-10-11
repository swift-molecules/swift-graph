public import Array
internal import Index

extension Graph {

    public typealias Node<Tag: ~Copyable & ~Escapable> = Index<Tag>
}
