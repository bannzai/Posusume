import Combine

#if DEBUG
struct MockAuth: Auth {
    func signInAnonymously() -> AnyPublisher<Me, Error> {
        Future(value: Me(id: Me.ID(rawValue: "1")))
            .eraseToAnyPublisher()
    }
}
#endif
