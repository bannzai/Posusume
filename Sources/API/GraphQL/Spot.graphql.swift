// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class SpotQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Spot($spotId: ID!) {
      spot(id: $spotId) {
        __typename
        id
        title
        imageURL
        geoPoint {
          __typename
          latitude
          longitude
        }
        author {
          __typename
          id
        }
        ...SpotDetailImageFragment
        ...SpotDetailMapFragment
      }
    }
    """

  public let operationName: String = "Spot"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + SpotDetailImageFragment.fragmentDefinition)
    document.append("\n" + SpotDetailMapFragment.fragmentDefinition)
    return document
  }

  public var spotId: GraphQLID

  public init(spotId: GraphQLID) {
    self.spotId = spotId
  }

  public var variables: GraphQLMap? {
    return ["spotId": spotId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("spot", arguments: ["id": GraphQLVariable("spotId")], type: .nonNull(.object(Spot.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(spot: Spot) {
      self.init(unsafeResultMap: ["__typename": "Query", "spot": spot.resultMap])
    }

    public var spot: Spot {
      get {
        return Spot(unsafeResultMap: resultMap["spot"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "spot")
      }
    }

    public struct Spot: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Spot"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("imageURL", type: .nonNull(.scalar(URL.self))),
          GraphQLField("geoPoint", type: .nonNull(.object(GeoPoint.selections))),
          GraphQLField("author", type: .nonNull(.object(Author.selections))),
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("imageURL", type: .nonNull(.scalar(URL.self))),
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("geoPoint", type: .nonNull(.object(GeoPoint.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, title: String, imageUrl: URL, geoPoint: GeoPoint, author: Author) {
        self.init(unsafeResultMap: ["__typename": "Spot", "id": id, "title": title, "imageURL": imageUrl, "geoPoint": geoPoint.resultMap, "author": author.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var title: String {
        get {
          return resultMap["title"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "title")
        }
      }

      public var imageUrl: URL {
        get {
          return resultMap["imageURL"]! as! URL
        }
        set {
          resultMap.updateValue(newValue, forKey: "imageURL")
        }
      }

      public var geoPoint: GeoPoint {
        get {
          return GeoPoint(unsafeResultMap: resultMap["geoPoint"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "geoPoint")
        }
      }

      public var author: Author {
        get {
          return Author(unsafeResultMap: resultMap["author"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "author")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var spotDetailImageFragment: SpotDetailImageFragment {
          get {
            return SpotDetailImageFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public var spotDetailMapFragment: SpotDetailMapFragment {
          get {
            return SpotDetailMapFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }

      public struct GeoPoint: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["GeoPoint"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("latitude", type: .nonNull(.scalar(Latitude.self))),
            GraphQLField("longitude", type: .nonNull(.scalar(Longitude.self))),
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("latitude", type: .nonNull(.scalar(Latitude.self))),
            GraphQLField("longitude", type: .nonNull(.scalar(Longitude.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(latitude: Latitude, longitude: Longitude) {
          self.init(unsafeResultMap: ["__typename": "GeoPoint", "latitude": latitude, "longitude": longitude])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var latitude: Latitude {
          get {
            return resultMap["latitude"]! as! Latitude
          }
          set {
            resultMap.updateValue(newValue, forKey: "latitude")
          }
        }

        public var longitude: Longitude {
          get {
            return resultMap["longitude"]! as! Longitude
          }
          set {
            resultMap.updateValue(newValue, forKey: "longitude")
          }
        }
      }

      public struct Author: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["User"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID) {
          self.init(unsafeResultMap: ["__typename": "User", "id": id])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }
      }
    }
  }
}

public struct SpotDetailImageFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment SpotDetailImageFragment on Spot {
      __typename
      id
      imageURL
    }
    """

  public static let possibleTypes: [String] = ["Spot"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("imageURL", type: .nonNull(.scalar(URL.self))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, imageUrl: URL) {
    self.init(unsafeResultMap: ["__typename": "Spot", "id": id, "imageURL": imageUrl])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var imageUrl: URL {
    get {
      return resultMap["imageURL"]! as! URL
    }
    set {
      resultMap.updateValue(newValue, forKey: "imageURL")
    }
  }
}

public struct SpotDetailMapFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment SpotDetailMapFragment on Spot {
      __typename
      id
      geoPoint {
        __typename
        latitude
        longitude
      }
    }
    """

  public static let possibleTypes: [String] = ["Spot"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("geoPoint", type: .nonNull(.object(GeoPoint.selections))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, geoPoint: GeoPoint) {
    self.init(unsafeResultMap: ["__typename": "Spot", "id": id, "geoPoint": geoPoint.resultMap])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var geoPoint: GeoPoint {
    get {
      return GeoPoint(unsafeResultMap: resultMap["geoPoint"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "geoPoint")
    }
  }

  public struct GeoPoint: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["GeoPoint"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("latitude", type: .nonNull(.scalar(Latitude.self))),
        GraphQLField("longitude", type: .nonNull(.scalar(Longitude.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(latitude: Latitude, longitude: Longitude) {
      self.init(unsafeResultMap: ["__typename": "GeoPoint", "latitude": latitude, "longitude": longitude])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var latitude: Latitude {
      get {
        return resultMap["latitude"]! as! Latitude
      }
      set {
        resultMap.updateValue(newValue, forKey: "latitude")
      }
    }

    public var longitude: Longitude {
      get {
        return resultMap["longitude"]! as! Longitude
      }
      set {
        resultMap.updateValue(newValue, forKey: "longitude")
      }
    }
  }
}
