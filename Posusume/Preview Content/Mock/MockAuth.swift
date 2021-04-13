import Combine

#if DEBUG
struct MockAuth: Auth {
    func auth() -> AnyPublisher<UserID, Error> {
        Future(value: UserID(rawValue: "1"))
            .eraseToAnyPublisher()
    }
}
#endif
