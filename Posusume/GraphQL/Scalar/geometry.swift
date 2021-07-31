import Apollo

extension Scalar {
    public struct Geometry {
        public let latitude: Double
        public let longitude: Double
    }
}

extension Scalar.Geometry: Apollo.JSONDecodable, Apollo.JSONEncodable {
    public init(jsonValue value: Apollo.JSONValue) throws {
        guard let object = value as? JSONObject else {
            throw JSONDecodingError.couldNotConvert(value: value, to: JSONObject.self)
        }
        guard let coordinates = object["coordinates"] as? [Double] else {
            throw JSONDecodingError.couldNotConvert(value: String(describing: object["coordinates"]), to: [Double].self)
        }
        guard coordinates.count == 2 else {
            throw JSONDecodingError.missingValue
        }
        self = Scalar.Geometry(latitude: coordinates[0], longitude: coordinates[1])
    }
    public var jsonValue: JSONValue {
        return ["type": "Point", "coordinates": [latitude, longitude]]
    }
}


public typealias geometry = Scalar.Geometry
