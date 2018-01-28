//
//  Climb.swift
//
//  Created by Carter Luck on 1/14/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Climb: NSObject {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let activeLift = "activeLift"
    static let assistedLift = "assistedLift"
    static let passiveClimb = "passiveClimb"
    static let soloClimb = "soloClimb"
  }

  // MARK: Properties
  public var activeLift: ActiveLift?
  public var assistedLift: AssistedLift?
  public var passiveClimb: PassiveClimb?
  public var soloClimb: SoloClimb?

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
    activeLift = ActiveLift(json: json[SerializationKeys.activeLift])
    assistedLift = AssistedLift(json: json[SerializationKeys.assistedLift])
    passiveClimb = PassiveClimb(json: json[SerializationKeys.passiveClimb])
    soloClimb = SoloClimb(json: json[SerializationKeys.soloClimb])
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = activeLift { dictionary[SerializationKeys.activeLift] = value }
    if let value = assistedLift { dictionary[SerializationKeys.assistedLift] = value }
    if let value = passiveClimb { dictionary[SerializationKeys.passiveClimb] = value }
    if let value = soloClimb { dictionary[SerializationKeys.soloClimb] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.activeLift = aDecoder.decodeObject(forKey: SerializationKeys.activeLift) as? ActiveLift
    self.assistedLift = aDecoder.decodeObject(forKey: SerializationKeys.assistedLift) as? AssistedLift
    self.passiveClimb = aDecoder.decodeObject(forKey: SerializationKeys.passiveClimb) as? PassiveClimb
    self.soloClimb = aDecoder.decodeObject(forKey: SerializationKeys.soloClimb) as? SoloClimb
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(activeLift, forKey: SerializationKeys.activeLift)
    aCoder.encode(assistedLift, forKey: SerializationKeys.assistedLift)
    aCoder.encode(passiveClimb, forKey: SerializationKeys.passiveClimb)
    aCoder.encode(soloClimb, forKey: SerializationKeys.soloClimb)
  }

}
