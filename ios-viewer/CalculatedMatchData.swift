//
//  CalculatedMatchData.swift
//
//  Created by Carter Luck on 1/14/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class CalculatedMatchData: NSObject, NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let actualBlueRPs = "actualBlueRPs"
    static let predictedRedAutoQuest = "predictedRedAutoQuest"
    static let predictedRedRPs = "predictedRedRPs"
    static let predictedBlueScore = "predictedBlueScore"
    static let actualRedRPs = "actualRedRPs"
    static let predictedBlueAutoQuest = "predictedBlueAutoQuest"
    static let predictedBlueRPs = "predictedBlueRPs"
    static let blueWinChance = "blueWinChance"
    static let predictedRedScore = "predictedRedScore"
    static let redWinChance = "redWinChance"
  }

  // MARK: Properties
  public var actualBlueRPs: Int?
  public var predictedRedAutoQuest: Float = -1
  public var predictedRedRPs: Float?
  @objc public var predictedBlueScore: Float = -1
  public var actualRedRPs: Int?
  public var predictedBlueAutoQuest: Float = -1
  public var predictedBlueRPs: Float?
  public var blueWinChance: Float = 0.5
  @objc public var predictedRedScore: Float = -1
  public var redWinChance: Float = 0.5

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
    actualBlueRPs = json[SerializationKeys.actualBlueRPs].int
    predictedRedAutoQuest = json[SerializationKeys.predictedRedAutoQuest].floatValue
    predictedRedRPs = json[SerializationKeys.predictedRedRPs].float
    predictedBlueScore = json[SerializationKeys.predictedBlueScore].floatValue
    actualRedRPs = json[SerializationKeys.actualRedRPs].int
    predictedBlueAutoQuest = json[SerializationKeys.predictedBlueAutoQuest].floatValue
    predictedBlueRPs = json[SerializationKeys.predictedBlueRPs].float
    blueWinChance = json[SerializationKeys.blueWinChance].floatValue
    predictedRedScore = json[SerializationKeys.predictedRedScore].floatValue
    redWinChance = json[SerializationKeys.redWinChance].floatValue
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = actualBlueRPs { dictionary[SerializationKeys.actualBlueRPs] = value }
    dictionary[SerializationKeys.predictedRedAutoQuest] = predictedRedAutoQuest
    if let value = predictedRedRPs { dictionary[SerializationKeys.predictedRedRPs] = value }
    dictionary[SerializationKeys.predictedBlueScore] = predictedBlueScore
    if let value = actualRedRPs { dictionary[SerializationKeys.actualRedRPs] = value }
    dictionary[SerializationKeys.predictedBlueAutoQuest] = predictedBlueAutoQuest
    if let value = predictedBlueRPs { dictionary[SerializationKeys.predictedBlueRPs] = value }
    dictionary[SerializationKeys.blueWinChance] = blueWinChance
    dictionary[SerializationKeys.predictedRedScore] = predictedRedScore
    dictionary[SerializationKeys.redWinChance] = redWinChance
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.actualBlueRPs = aDecoder.decodeObject(forKey: SerializationKeys.actualBlueRPs) as? Int
    self.predictedRedAutoQuest = aDecoder.decodeFloat(forKey: SerializationKeys.predictedRedAutoQuest)
    self.predictedRedRPs = aDecoder.decodeObject(forKey: SerializationKeys.predictedRedRPs) as? Float
    self.predictedBlueScore = aDecoder.decodeFloat(forKey: SerializationKeys.predictedBlueScore)
    self.actualRedRPs = aDecoder.decodeObject(forKey: SerializationKeys.actualRedRPs) as? Int
    self.predictedBlueAutoQuest = aDecoder.decodeFloat(forKey: SerializationKeys.predictedBlueAutoQuest)
    self.predictedBlueRPs = aDecoder.decodeObject(forKey: SerializationKeys.predictedBlueRPs) as? Float
    self.blueWinChance = aDecoder.decodeFloat(forKey: SerializationKeys.blueWinChance)
    self.predictedRedScore = aDecoder.decodeFloat(forKey: SerializationKeys.predictedRedScore)
    self.redWinChance = aDecoder.decodeFloat(forKey: SerializationKeys.redWinChance)
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(actualBlueRPs, forKey: SerializationKeys.actualBlueRPs)
    aCoder.encode(predictedRedAutoQuest, forKey: SerializationKeys.predictedRedAutoQuest)
    aCoder.encode(predictedRedRPs, forKey: SerializationKeys.predictedRedRPs)
    aCoder.encode(predictedBlueScore, forKey: SerializationKeys.predictedBlueScore)
    aCoder.encode(actualRedRPs, forKey: SerializationKeys.actualRedRPs)
    aCoder.encode(predictedBlueAutoQuest, forKey: SerializationKeys.predictedBlueAutoQuest)
    aCoder.encode(predictedBlueRPs, forKey: SerializationKeys.predictedBlueRPs)
    aCoder.encode(blueWinChance, forKey: SerializationKeys.blueWinChance)
    aCoder.encode(predictedRedScore, forKey: SerializationKeys.predictedRedScore)
    aCoder.encode(redWinChance, forKey: SerializationKeys.redWinChance)
  }

}
