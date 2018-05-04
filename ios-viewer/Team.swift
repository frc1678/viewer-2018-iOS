//
//  Team.swift
//
//  Created by Carter Luck on 1/14/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Team: NSObject, NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let pitDriveTrain = "pitDriveTrain"
    static let number = "number"
    static let calculatedData = "calculatedData"
    static let pitAllImageURLs = "pitAllImageURLs"
    static let pitSEALsNotes = "pitSEALsNotes"
    static let pitSelectedImage = "pitSelectedImage"
    static let numMatchesPlayed = "numMatchesPlayed"
    static let pitClimberType = "pitClimberType"
    static let pitProgrammingLanguage = "pitProgrammingLanguage"
    static let pitAvailableWeight = "pitAvailableWeight"
    static let pitRobotWidth = "pitRobotWidth"
    static let pitRobotLength = "pitRobotLength"
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
  public var pitSelectedImage: String?
  public var numMatchesPlayed: Int?
  public var pitClimberType: String?
  public var pitProgrammingLanguage: String?
  public var pitAvailableWeight: Float = -1
  public var pitRobotWidth: Float?
    public var pitRobotLength: Float?
    public var picklistPosition: Int = -1
    public var pitWheelDiameter: String?
    public var pitHasCamera: Bool? = false
    
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
    pitSelectedImage = json[SerializationKeys.pitSelectedImage].string
    numMatchesPlayed = json[SerializationKeys.numMatchesPlayed].int
    pitClimberType = json[SerializationKeys.pitClimberType].string
    pitProgrammingLanguage = json[SerializationKeys.pitProgrammingLanguage].string
    pitAvailableWeight = json[SerializationKeys.pitAvailableWeight].floatValue
    pitRobotWidth = json[SerializationKeys.pitRobotWidth].float
    pitRobotLength = json[SerializationKeys.pitRobotLength].float
    picklistPosition = json[SerializationKeys.picklistPosition].intValue
    pitWheelDiameter = json[SerializationKeys.pitWheelDiameter].string
    pitHasCamera = json[SerializationKeys.pitHasCamera].boolValue
}

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = pitDriveTrain { dictionary[SerializationKeys.pitDriveTrain] = value }
    dictionary[SerializationKeys.number] = number
    if let value = calculatedData { dictionary[SerializationKeys.calculatedData] = value.dictionaryRepresentation() }
    if let value = pitAllImageURLs { dictionary[SerializationKeys.pitAllImageURLs] = value }
    if let value = pitSEALsNotes { dictionary[SerializationKeys.pitSEALsNotes] = value }
    if let value = pitSelectedImage { dictionary[SerializationKeys.pitSelectedImage] = value }
    if let value = numMatchesPlayed { dictionary[SerializationKeys.numMatchesPlayed] = value }
    if let value = pitClimberType { dictionary[SerializationKeys.pitClimberType] = value }
    if let value = pitProgrammingLanguage { dictionary[SerializationKeys.pitProgrammingLanguage] = value }
    if let value = pitRobotWidth { dictionary[SerializationKeys.pitRobotWidth] = value }
    if let value = pitRobotLength { dictionary[SerializationKeys.pitRobotLength] = value }
    dictionary[SerializationKeys.pitAvailableWeight] = pitAvailableWeight
    dictionary[SerializationKeys.picklistPosition] = picklistPosition
    if let value = pitWheelDiameter { dictionary[SerializationKeys.pitWheelDiameter] = value }
    dictionary[SerializationKeys.pitHasCamera] = pitHasCamera
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init?(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
    self.pitDriveTrain = aDecoder.decodeObject(forKey: SerializationKeys.pitDriveTrain) as? String
    self.pitAvailableWeight = aDecoder.decodeFloat(forKey: SerializationKeys.pitAvailableWeight)
    self.number = aDecoder.decodeInteger(forKey: SerializationKeys.number)
    self.calculatedData = aDecoder.decodeObject(forKey: SerializationKeys.calculatedData) as? CalculatedTeamData
    self.pitAllImageURLs = aDecoder.decodeObject(forKey: SerializationKeys.pitAllImageURLs) as? [String]
    self.pitSEALsNotes = aDecoder.decodeObject(forKey: SerializationKeys.pitSEALsNotes) as? String
    self.pitSelectedImage = aDecoder.decodeObject(forKey: SerializationKeys.pitSelectedImage) as? String
    self.numMatchesPlayed = aDecoder.decodeObject(forKey: SerializationKeys.numMatchesPlayed) as? Int
    self.pitClimberType = aDecoder.decodeObject(forKey: SerializationKeys.pitClimberType) as? String
    self.pitProgrammingLanguage = aDecoder.decodeObject(forKey: SerializationKeys.pitProgrammingLanguage) as? String
    self.pitRobotWidth = aDecoder.decodeObject(forKey: SerializationKeys.pitRobotWidth) as? Float
    self.pitRobotLength = aDecoder.decodeObject(forKey: SerializationKeys.pitRobotLength) as? Float
    self.picklistPosition = aDecoder.decodeInteger(forKey: SerializationKeys.picklistPosition)
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
    aCoder.encode(pitSelectedImage, forKey: SerializationKeys.pitSelectedImage)
    aCoder.encode(numMatchesPlayed, forKey: SerializationKeys.numMatchesPlayed)
    aCoder.encode(pitClimberType, forKey: SerializationKeys.pitClimberType)
    aCoder.encode(pitProgrammingLanguage, forKey: SerializationKeys.pitProgrammingLanguage)
    aCoder.encode(pitAvailableWeight, forKey: SerializationKeys.pitAvailableWeight)
    aCoder.encode(pitRobotWidth, forKey: SerializationKeys.pitRobotWidth)
    aCoder.encode(pitRobotLength, forKey: SerializationKeys.pitRobotLength)
    aCoder.encode(picklistPosition, forKey: SerializationKeys.picklistPosition)
    aCoder.encode(pitWheelDiameter, forKey: SerializationKeys.pitWheelDiameter)
    aCoder.encode(pitHasCamera, forKey: SerializationKeys.pitHasCamera)
  }
}
