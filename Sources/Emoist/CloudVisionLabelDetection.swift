import Foundation
import Firebase
import UIKit
import SwiftUI

public struct CloudVision {
    let functions = Functions.functions()

    // See https://cloud.google.com/vision/docs/labels
    public struct Label {
        public let mid: String
        public let description: String
        public let score: Double
        public let topicality: Double
    }

    public enum LabelDetectionError: Error {
        case imageCannotConvertToJPEG
        case emotionaliseError(domain: String, errorCode: Int, localizedDescription: String, firebaseFunctionErrorDetails: String?)
        case labelDecodedError(rawData: Any?)
    }

    public func emotionalise(uiImage image: UIImage) async throws ->  [Label] {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            throw LabelDetectionError.imageCannotConvertToJPEG
        }
        let base64EncodedImage = imageData.base64EncodedString()
        let requestData: [String: Any] = [
            "image": ["content": base64EncodedImage],
            "features": [["maxResults": 5, "type": "LABEL_DETECTION"]]
        ]

        return try await withCheckedThrowingContinuation { continuation in
            functions.httpsCallable("emotionalise").call(requestData) { (result, error) in
                if let error = error {
                    continuation.resume(
                        throwing: LabelDetectionError.emotionaliseError(
                            domain: error._domain,
                            errorCode: error._code,
                            localizedDescription: error.localizedDescription,
                            firebaseFunctionErrorDetails: (error as NSError).userInfo[FunctionsErrorDetailsKey] as? String
                        )
                    )
                } else {
                    // data/responses is a key of "responses". https://cloud.google.com/vision/docs/labels
                    if let responses = result?.data as? [[String: Any]], let labelAnnotations = responses.first?["labelAnnotations"] as? [[String: Any]] {
                        let labels: [Label] = labelAnnotations.compactMap {
                            guard let mid = $0["mid"] as? String,
                                  let description = $0["description"] as? String,
                                  let score = $0["score"] as? Double,
                                  let topicality = $0["topicality"] as? Double
                            else {
                                return nil
                            }
                            return Label(mid: mid, description: description, score: score, topicality: topicality)
                        }
                        continuation.resume(returning: labels)
                    } else {
                        continuation.resume(throwing: LabelDetectionError.labelDecodedError(rawData: result?.data))
                    }
                }
            }
        }
    }
}

public struct CloudVisionEnvironmentKey: EnvironmentKey {
    public static var defaultValue: CloudVision = .init()
}

public extension EnvironmentValues {
    var cloudVision: CloudVision {
        get {
            self[CloudVisionEnvironmentKey.self]
        }
        set {
            self[CloudVisionEnvironmentKey.self] = newValue
        }
    }
}

