import Combine

#if DEBUG
struct MockAuth: Auth {
    var me: Me? {
        .init(id: .init(rawValue: "1"))
    }
    func signInAnonymously() -> AnyPublisher<Me, Error> {
        Future(value: Me(id: Me.ID(rawValue: "1")))
            .eraseToAnyPublisher()
    }
}
#endif
