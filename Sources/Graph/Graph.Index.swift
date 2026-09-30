public import Array
public import Index

extension Graph {

    public typealias Index<Tag: ~Copyable & ~Escapable> = Index::Index<Tag>
}
