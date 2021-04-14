import Combine

#if DEBUG
struct MockAuth: Auth {
    func auth() -> AnyPublisher<Me.ID, Error> {
        Future(value: Me.ID(rawValue: "1"))
            .eraseToAnyPublisher()
    }
}
#endif
