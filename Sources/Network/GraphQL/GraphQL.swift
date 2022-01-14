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
      }
    }
    """

  public let operationName: String = "Spot"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + SpotDetailImageFragment.fragmentDefinition)
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

public final class SpotAddMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation SpotAdd($spotAddInput: SpotAddInput!) {
      spotAdd(input: $spotAddInput) {
        __typename
        spot {
          __typename
          id
        }
      }
    }
    """

  public let operationName: String = "SpotAdd"

  public var spotAddInput: SpotAddInput

  public init(spotAddInput: SpotAddInput) {
    self.spotAddInput = spotAddInput
  }

  public var variables: GraphQLMap? {
    return ["spotAddInput": spotAddInput]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("spotAdd", arguments: ["input": GraphQLVariable("spotAddInput")], type: .nonNull(.object(SpotAdd.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(spotAdd: SpotAdd) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "spotAdd": spotAdd.resultMap])
    }

    public var spotAdd: SpotAdd {
      get {
        return SpotAdd(unsafeResultMap: resultMap["spotAdd"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "spotAdd")
      }
    }

    public struct SpotAdd: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["SpotAddPayload"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("spot", type: .nonNull(.object(Spot.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(spot: Spot) {
        self.init(unsafeResultMap: ["__typename": "SpotAddPayload", "spot": spot.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
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
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID) {
          self.init(unsafeResultMap: ["__typename": "Spot", "id": id])
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

public final class SpotMapIconQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query SpotMapIcon {
      me {
        __typename
        id
        user {
          __typename
          id
          name
          profileImageURL
          resizedProfileImageURLs {
            __typename
            thumbnail
          }
        }
      }
    }
    """

  public let operationName: String = "SpotMapIcon"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("me", type: .object(Me.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(me: Me? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "me": me.flatMap { (value: Me) -> ResultMap in value.resultMap }])
    }

    public var me: Me? {
      get {
        return (resultMap["me"] as? ResultMap).flatMap { Me(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "me")
      }
    }

    public struct Me: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Me"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("user", type: .nonNull(.object(User.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, user: User) {
        self.init(unsafeResultMap: ["__typename": "Me", "id": id, "user": user.resultMap])
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

      public var user: User {
        get {
          return User(unsafeResultMap: resultMap["user"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "user")
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["User"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
            GraphQLField("profileImageURL", type: .scalar(URL.self)),
            GraphQLField("resizedProfileImageURLs", type: .nonNull(.object(ResizedProfileImageUrl.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, name: String, profileImageUrl: URL? = nil, resizedProfileImageUrLs: ResizedProfileImageUrl) {
          self.init(unsafeResultMap: ["__typename": "User", "id": id, "name": name, "profileImageURL": profileImageUrl, "resizedProfileImageURLs": resizedProfileImageUrLs.resultMap])
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

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var profileImageUrl: URL? {
          get {
            return resultMap["profileImageURL"] as? URL
          }
          set {
            resultMap.updateValue(newValue, forKey: "profileImageURL")
          }
        }

        public var resizedProfileImageUrLs: ResizedProfileImageUrl {
          get {
            return ResizedProfileImageUrl(unsafeResultMap: resultMap["resizedProfileImageURLs"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "resizedProfileImageURLs")
          }
        }

        public struct ResizedProfileImageUrl: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["ResizedUserProfileImageURLs"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("thumbnail", type: .scalar(URL.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(thumbnail: URL? = nil) {
            self.init(unsafeResultMap: ["__typename": "ResizedUserProfileImageURLs", "thumbnail": thumbnail])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var thumbnail: URL? {
            get {
              return resultMap["thumbnail"] as? URL
            }
            set {
              resultMap.updateValue(newValue, forKey: "thumbnail")
            }
          }
        }
      }
    }
  }
}

public final class SpotsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Spots($spotsMinLatitude: Latitude!, $spotsMinLongitude: Longitude!, $spotsMaxLatitude: Latitude!, $spotsMaxLongitude: Longitude!) {
      spots(
        minLatitude: $spotsMinLatitude
        minLongitude: $spotsMinLongitude
        maxLatitude: $spotsMaxLatitude
        maxLongitude: $spotsMaxLongitude
      ) {
        __typename
        id
        geoPoint {
          __typename
          latitude
          longitude
        }
        ...SpotMapImageFragment
      }
    }
    """

  public let operationName: String = "Spots"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + SpotMapImageFragment.fragmentDefinition)
    return document
  }

  public var spotsMinLatitude: Latitude
  public var spotsMinLongitude: Longitude
  public var spotsMaxLatitude: Latitude
  public var spotsMaxLongitude: Longitude

  public init(spotsMinLatitude: Latitude, spotsMinLongitude: Longitude, spotsMaxLatitude: Latitude, spotsMaxLongitude: Longitude) {
    self.spotsMinLatitude = spotsMinLatitude
    self.spotsMinLongitude = spotsMinLongitude
    self.spotsMaxLatitude = spotsMaxLatitude
    self.spotsMaxLongitude = spotsMaxLongitude
  }

  public var variables: GraphQLMap? {
    return ["spotsMinLatitude": spotsMinLatitude, "spotsMinLongitude": spotsMinLongitude, "spotsMaxLatitude": spotsMaxLatitude, "spotsMaxLongitude": spotsMaxLongitude]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("spots", arguments: ["minLatitude": GraphQLVariable("spotsMinLatitude"), "minLongitude": GraphQLVariable("spotsMinLongitude"), "maxLatitude": GraphQLVariable("spotsMaxLatitude"), "maxLongitude": GraphQLVariable("spotsMaxLongitude")], type: .nonNull(.list(.nonNull(.object(Spot.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(spots: [Spot]) {
      self.init(unsafeResultMap: ["__typename": "Query", "spots": spots.map { (value: Spot) -> ResultMap in value.resultMap }])
    }

    public var spots: [Spot] {
      get {
        return (resultMap["spots"] as! [ResultMap]).map { (value: ResultMap) -> Spot in Spot(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Spot) -> ResultMap in value.resultMap }, forKey: "spots")
      }
    }

    public struct Spot: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Spot"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("geoPoint", type: .nonNull(.object(GeoPoint.selections))),
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("imageURL", type: .nonNull(.scalar(URL.self))),
          GraphQLField("resizedSpotImageURLs", type: .nonNull(.object(ResizedSpotImageUrl.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, geoPoint: GeoPoint, imageUrl: URL, resizedSpotImageUrLs: ResizedSpotImageUrl) {
        self.init(unsafeResultMap: ["__typename": "Spot", "id": id, "geoPoint": geoPoint.resultMap, "imageURL": imageUrl, "resizedSpotImageURLs": resizedSpotImageUrLs.resultMap])
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

      public var imageUrl: URL {
        get {
          return resultMap["imageURL"]! as! URL
        }
        set {
          resultMap.updateValue(newValue, forKey: "imageURL")
        }
      }

      public var resizedSpotImageUrLs: ResizedSpotImageUrl {
        get {
          return ResizedSpotImageUrl(unsafeResultMap: resultMap["resizedSpotImageURLs"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "resizedSpotImageURLs")
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

        public var spotMapImageFragment: SpotMapImageFragment {
          get {
            return SpotMapImageFragment(unsafeResultMap: resultMap)
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

      public struct ResizedSpotImageUrl: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["ResizedSpotImageURLs"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("thumbnail", type: .scalar(URL.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(thumbnail: URL? = nil) {
          self.init(unsafeResultMap: ["__typename": "ResizedSpotImageURLs", "thumbnail": thumbnail])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var thumbnail: URL? {
          get {
            return resultMap["thumbnail"] as? URL
          }
          set {
            resultMap.updateValue(newValue, forKey: "thumbnail")
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

public struct SpotMapImageFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment SpotMapImageFragment on Spot {
      __typename
      id
      imageURL
      resizedSpotImageURLs {
        __typename
        thumbnail
      }
    }
    """

  public static let possibleTypes: [String] = ["Spot"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("imageURL", type: .nonNull(.scalar(URL.self))),
      GraphQLField("resizedSpotImageURLs", type: .nonNull(.object(ResizedSpotImageUrl.selections))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, imageUrl: URL, resizedSpotImageUrLs: ResizedSpotImageUrl) {
    self.init(unsafeResultMap: ["__typename": "Spot", "id": id, "imageURL": imageUrl, "resizedSpotImageURLs": resizedSpotImageUrLs.resultMap])
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

  public var resizedSpotImageUrLs: ResizedSpotImageUrl {
    get {
      return ResizedSpotImageUrl(unsafeResultMap: resultMap["resizedSpotImageURLs"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "resizedSpotImageURLs")
    }
  }

  public struct ResizedSpotImageUrl: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["ResizedSpotImageURLs"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("thumbnail", type: .scalar(URL.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(thumbnail: URL? = nil) {
      self.init(unsafeResultMap: ["__typename": "ResizedSpotImageURLs", "thumbnail": thumbnail])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var thumbnail: URL? {
      get {
        return resultMap["thumbnail"] as? URL
      }
      set {
        resultMap.updateValue(newValue, forKey: "thumbnail")
      }
    }
  }
}
