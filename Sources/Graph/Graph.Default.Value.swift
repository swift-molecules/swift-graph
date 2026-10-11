internal import Array
extension Graph.Default {

    @frozen
    public struct Value<Payload> {
        @usableFromInline
        let _default: Payload

        @inlinable
        public init(_ value: Payload) {
            self._default = value
        }
    }
}

extension Graph.Default.Value {
    @inlinable
    public var value: Payload { _default }
}
