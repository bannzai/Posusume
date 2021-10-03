// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

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
