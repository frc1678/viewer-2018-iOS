//
//  Climb.swift
//
//  Created by Carter Luck on 1/14/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class ActiveLift: NSObject {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let startTime = "startTime"
    static let endTime = "endTime"
    static let didSucceed = "didSucceed"
    static let didClimb = "didClimb"
    static let didFailToLift = "didFailToLift"
    static let numRobotsLifted = "numRobotsLifted"
    static let partnerLiftType = "partnerLiftType"
  }

  // MARK: Properties
  public var startTime: Int? = 0
  public var endTime: Int? = 0
  public var didSucceed: Bool? = false
  public var didClimb: Bool? = false
  public var didFailToLift: Bool? = false
  public var numRobotsLifted: Int? = 0
  public var partnerLiftType: String? = ""

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public convenience init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    startTime = json[SerializationKeys.startTime].intValue
    endTime = json[SerializationKeys.endTime].intValue
    didSucceed = json[SerializationKeys.didSucceed].boolValue
    didClimb = json[SerializationKeys.didClimb].boolValue
    didFailToLift = json[SerializationKeys.didFailToLift].boolValue
    numRobotsLifted = json[SerializationKeys.numRobotsLifted].intValue
    partnerLiftType = json[SerializationKeys.partnerLiftType].stringValue
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = startTime { dictionary[SerializationKeys.startTime] = value }
    if let value = endTime { dictionary[SerializationKeys.endTime] = value }
    dictionary[SerializationKeys.didSucceed] = didSucceed
    dictionary[SerializationKeys.didClimb] = didClimb
    dictionary[SerializationKeys.didFailToLift] = didFailToLift
    dictionary[SerializationKeys.numRobotsLifted] = numRobotsLifted
    if let value = partnerLiftType { dictionary[SerializationKeys.partnerLiftType] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.startTime = aDecoder.decodeObject(forKey: SerializationKeys.startTime) as? Int
    self.endTime = aDecoder.decodeObject(forKey: SerializationKeys.endTime) as? Int
    self.didSucceed = aDecoder.decodeBool(forKey: SerializationKeys.didSucceed)
    self.didClimb = aDecoder.decodeBool(forKey: SerializationKeys.didClimb)
    self.didFailToLift = aDecoder.decodeBool(forKey: SerializationKeys.didFailToLift)
    self.numRobotsLifted = aDecoder.decodeObject(forKey: SerializationKeys.numRobotsLifted) as? Int
    self.partnerLiftType = aDecoder.decodeObject(forKey: SerializationKeys.partnerLiftType) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(startTime, forKey: SerializationKeys.startTime)
    aCoder.encode(endTime, forKey: SerializationKeys.endTime)
    aCoder.encode(didSucceed, forKey: SerializationKeys.didSucceed)
    aCoder.encode(didClimb, forKey: SerializationKeys.didClimb)
    aCoder.encode(didFailToLift, forKey: SerializationKeys.didFailToLift)
    aCoder.encode(numRobotsLifted, forKey: SerializationKeys.numRobotsLifted)
    aCoder.encode(partnerLiftType, forKey: SerializationKeys.partnerLiftType)
  }

}
