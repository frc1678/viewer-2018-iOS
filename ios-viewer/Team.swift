//
//  Team.swift
//
//  Created by Carter Luck on 1/14/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Team: NSObject {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let pitDriveTrain = "pitDriveTrain"
    static let number = "number"
    static let calculatedData = "calculatedData"
    static let pitAllImageURLs = "pitAllImageURLs"
    static let pitSEALsNotes = "pitSEALsNotes"
    static let pitCanCheesecake = "pitCanCheesecake"
    static let pitSelectedImage = "pitSelectedImage"
    static let numMatchesPlayed = "numMatchesPlayed"
    static let pitClimberType = "pitClimberType"
    static let pitProgrammingLanguage = "pitProgrammingLanguage"
    static let pitAvailableWeight = "pitAvailableWeight"
    static let pitRobotDimensions = "pitRobotDimensions"
    static let picklistPosition = "picklistPosition"
    static let pitRampTimes = "pitRampTimes"
    static let pitDriveTimes = "pitDriveTimes"
    static let pitWheelDiameter = "pitWheelDiameter"
    static let pitHasCamera = "pitHasCamera"
  }

  // MARK: Properties
  public var name: String?
  public var pitDriveTrain: String?
  @objc public var number: Int = -1
  @objc public var calculatedData: CalculatedTeamData?
    @objc public var pitAllImageURLs: [String]?
  public var pitSEALsNotes: String?
  public var pitCanCheesecake: Bool? = false
  public var pitSelectedImage: String?
  public var numMatchesPlayed: Int?
  public var pitClimberType: String?
  public var pitProgrammingLanguage: String?
  public var pitAvailableWeight: Float = -1
  public var pitRobotDimensions: String?
    public var picklistPosition: Int = -1
    public var pitWheelDiameter: String?
    public var pitHasCamera: Bool?
    
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
    name = json[SerializationKeys.name].string
    pitDriveTrain = json[SerializationKeys.pitDriveTrain].string
    number = json[SerializationKeys.number].intValue
    calculatedData = CalculatedTeamData(json: json[SerializationKeys.calculatedData])
    var a : [String] = []
    if json[SerializationKeys.pitAllImageURLs].array != nil { for i in json[SerializationKeys.pitAllImageURLs].array! { a.append(i.string!) } }
    pitAllImageURLs = a
    pitSEALsNotes = json[SerializationKeys.pitSEALsNotes].string
    pitCanCheesecake = json[SerializationKeys.pitCanCheesecake].boolValue
    pitSelectedImage = json[SerializationKeys.pitSelectedImage].string
    numMatchesPlayed = json[SerializationKeys.numMatchesPlayed].int
    pitClimberType = json[SerializationKeys.pitClimberType].string
    pitProgrammingLanguage = json[SerializationKeys.pitProgrammingLanguage].string
    pitAvailableWeight = json[SerializationKeys.pitAvailableWeight].floatValue
    pitRobotDimensions = json[SerializationKeys.pitRobotDimensions].string
    picklistPosition = json[SerializationKeys.picklistPosition].intValue
    pitWheelDiameter = json[SerializationKeys.pitWheelDiameter].string
    pitHasCamera = json[SerializationKeys.pitHasCamera].bool
}

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = pitDriveTrain { dictionary[SerializationKeys.pitDriveTrain] = value }
    if let value = calculatedData { dictionary[SerializationKeys.calculatedData] = value.dictionaryRepresentation() }
    if let value = pitAllImageURLs { dictionary[SerializationKeys.pitAllImageURLs] = value }
    if let value = pitSEALsNotes { dictionary[SerializationKeys.pitSEALsNotes] = value }
    dictionary[SerializationKeys.pitCanCheesecake] = pitCanCheesecake
    if let value = pitSelectedImage { dictionary[SerializationKeys.pitSelectedImage] = value }
    if let value = numMatchesPlayed { dictionary[SerializationKeys.numMatchesPlayed] = value }
    if let value = pitClimberType { dictionary[SerializationKeys.pitClimberType] = value }
    if let value = pitProgrammingLanguage { dictionary[SerializationKeys.pitProgrammingLanguage] = value }
    if let value = pitRobotDimensions { dictionary[SerializationKeys.pitRobotDimensions] = value }
    dictionary[SerializationKeys.pitAvailableWeight] = pitAvailableWeight
    dictionary[SerializationKeys.picklistPosition] = picklistPosition
    if let value = pitWheelDiameter { dictionary[SerializationKeys.pitWheelDiameter] = value }
    if let value = pitHasCamera { dictionary[SerializationKeys.pitHasCamera] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
    self.pitDriveTrain = aDecoder.decodeObject(forKey: SerializationKeys.pitDriveTrain) as? String
    self.number = (aDecoder.decodeObject(forKey: SerializationKeys.number) as? Int)!
    self.calculatedData = aDecoder.decodeObject(forKey: SerializationKeys.calculatedData) as? CalculatedTeamData
    self.pitAllImageURLs = aDecoder.decodeObject(forKey: SerializationKeys.pitAllImageURLs) as? [String]
    self.pitSEALsNotes = aDecoder.decodeObject(forKey: SerializationKeys.pitSEALsNotes) as? String
    self.pitCanCheesecake = aDecoder.decodeBool(forKey: SerializationKeys.pitCanCheesecake)
    self.pitSelectedImage = aDecoder.decodeObject(forKey: SerializationKeys.pitSelectedImage) as? String
    self.numMatchesPlayed = aDecoder.decodeObject(forKey: SerializationKeys.numMatchesPlayed) as? Int
    self.pitClimberType = aDecoder.decodeObject(forKey: SerializationKeys.pitClimberType) as? String
    self.pitProgrammingLanguage = aDecoder.decodeObject(forKey: SerializationKeys.pitProgrammingLanguage) as? String
    self.pitAvailableWeight = (aDecoder.decodeObject(forKey: SerializationKeys.pitAvailableWeight) as? Float)!
    self.pitRobotDimensions = aDecoder.decodeObject(forKey: SerializationKeys.pitRobotDimensions) as? String
    self.picklistPosition = (aDecoder.decodeObject(forKey: SerializationKeys.picklistPosition) as? Int)!
    self.pitWheelDiameter = aDecoder.decodeObject(forKey: SerializationKeys.pitWheelDiameter) as? String
    self.pitHasCamera = aDecoder.decodeObject(forKey: SerializationKeys.pitHasCamera) as? Bool
    }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: SerializationKeys.name)
    aCoder.encode(pitDriveTrain, forKey: SerializationKeys.pitDriveTrain)
    aCoder.encode(number, forKey: SerializationKeys.number)
    aCoder.encode(calculatedData, forKey: SerializationKeys.calculatedData)
    aCoder.encode(pitAllImageURLs, forKey: SerializationKeys.pitAllImageURLs)
    aCoder.encode(pitSEALsNotes, forKey: SerializationKeys.pitSEALsNotes)
    aCoder.encode(pitCanCheesecake, forKey: SerializationKeys.pitCanCheesecake)
    aCoder.encode(pitSelectedImage, forKey: SerializationKeys.pitSelectedImage)
    aCoder.encode(numMatchesPlayed, forKey: SerializationKeys.numMatchesPlayed)
    aCoder.encode(pitClimberType, forKey: SerializationKeys.pitClimberType)
    aCoder.encode(pitProgrammingLanguage, forKey: SerializationKeys.pitProgrammingLanguage)
    aCoder.encode(pitAvailableWeight, forKey: SerializationKeys.pitAvailableWeight)
    aCoder.encode(pitRobotDimensions, forKey: SerializationKeys.pitRobotDimensions)
    aCoder.encode(picklistPosition, forKey: SerializationKeys.picklistPosition)
    aCoder.encode(pitWheelDiameter, forKey: SerializationKeys.pitWheelDiameter)
    aCoder.encode(pitHasCamera, forKey: SerializationKeys.pitHasCamera)
  }

}
