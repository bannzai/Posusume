import Foundation
import Combine

extension Future {
    convenience init(value: Output) {
        self.init { $0(.success(value)) }
    }
}
