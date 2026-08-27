public import Buffer_Linear_Primitive
public import Column
internal import Graph
public import Hash_Indexed_Primitive

public import Set_Ordered_Primitive
import Set_Ordered
public import Set_Primitive
internal import Set

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
