import Combine

#if DEBUG
struct MockAuth: Auth {
    func auth() -> AnyPublisher<Me, Error> {
        Future(value: Me(id: Me.ID(rawValue: "1")))
            .eraseToAnyPublisher()
    }
}
#endif
