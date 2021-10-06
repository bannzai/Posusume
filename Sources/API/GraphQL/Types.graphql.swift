// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public struct SpotAddInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - id
  ///   - title
  ///   - imageUrl
  ///   - latitude
  ///   - longitude
  public init(id: Swift.Optional<GraphQLID?> = nil, title: String, imageUrl: URL, latitude: Latitude, longitude: Longitude) {
    graphQLMap = ["id": id, "title": title, "imageURL": imageUrl, "latitude": latitude, "longitude": longitude]
  }

  public var id: Swift.Optional<GraphQLID?> {
    get {
      return graphQLMap["id"] as? Swift.Optional<GraphQLID?> ?? Swift.Optional<GraphQLID?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var title: String {
    get {
      return graphQLMap["title"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "title")
    }
  }

  public var imageUrl: URL {
    get {
      return graphQLMap["imageURL"] as! URL
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "imageURL")
    }
  }

  public var latitude: Latitude {
    get {
      return graphQLMap["latitude"] as! Latitude
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "latitude")
    }
  }

  public var longitude: Longitude {
    get {
      return graphQLMap["longitude"] as! Longitude
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "longitude")
    }
  }
}
