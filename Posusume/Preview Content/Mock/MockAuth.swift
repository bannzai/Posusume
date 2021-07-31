import Combine

#if DEBUG
struct MockAuth: Auth {
    func fetch() -> Me? {
        .init(id: .init(rawValue: "1"))
    }
    func signInAnonymously() -> AnyPublisher<Me, Error> {
        Future(value: Me(id: Me.ID(rawValue: "1")))
            .eraseToAnyPublisher()
    }
}
#endif
