import Foundation

internal final class ReferenceBox<T> {
    var value: T

    internal init(value: T) {
        self.value = value
    }
}

@propertyWrapper public struct Ref<T> {
    let box: ReferenceBox<T>
    public var wrappedValue: T {
        get { box.value }
        nonmutating set { box.value = newValue }
    }

    public init(wrappedValue: T) {
        self.box = .init(value: wrappedValue)
    }
}
