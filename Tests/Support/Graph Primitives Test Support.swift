public import Buffer_Linear_Primitive
public import Column_Primitives
internal import Graph_Primitives
public import Hash_Indexed_Primitive

public import Set_Ordered_Primitive
import Set_Ordered_Primitives
public import Set_Primitive
internal import Set_Primitives

extension __Set where S: ~Copyable {
    public static func ordered<E: Hash.Key>(_ elements: E...) -> __Set<S>.Ordered
    where S == Hash.Indexed<Column.Heap<E>> {
        var set = __Set<S>.Ordered()
        for element in elements {
            _ = set.insert(element)
        }
        return set
    }
}
