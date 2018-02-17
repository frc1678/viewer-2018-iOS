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
    static let pitMaxHeight = "pitMaxHeight"
    static let picklistPosition = "picklistPosition"
    static let pitRampTimes = "pitRampTimes"
    static let pitDriveTimes = "pitDriveTimes"
    static let pitDriveTest = "pitDriveTest"
  }

  // MARK: Properties
  public var name: String?
  public var pitDriveTrain: String?
  @objc public var number: Int = -1
  @objc public var calculatedData: CalculatedTeamData?
  public var pitAllImageURLs: [String: String]?
  public var pitSEALsNotes: String?
  public var pitCanCheesecake: Bool? = false
  public var pitSelectedImage: String?
  public var numMatchesPlayed: Int?
  public var pitClimberType: String?
  public var pitProgrammingLanguage: String?
  public var pitAvailableWeight: Float = -1
  public var pitMaxHeight: Float?
    public var picklistPosition: Int = -1
    public var pitDriveTest: String?
    
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
    pitAllImageURLs = json[SerializationKeys.pitAllImageURLs].dictionaryObject as! [String: String]?
    pitSEALsNotes = json[SerializationKeys.pitSEALsNotes].string
    pitCanCheesecake = json[SerializationKeys.pitCanCheesecake].boolValue
    pitSelectedImage = json[SerializationKeys.pitSelectedImage].string
    numMatchesPlayed = json[SerializationKeys.numMatchesPlayed].int
    pitClimberType = json[SerializationKeys.pitClimberType].string
    pitProgrammingLanguage = json[SerializationKeys.pitProgrammingLanguage].string
    pitAvailableWeight = json[SerializationKeys.pitAvailableWeight].floatValue
    pitMaxHeight = json[SerializationKeys.pitMaxHeight].float
    picklistPosition = json[SerializationKeys.picklistPosition].intValue
    pitDriveTest = json[SerializationKeys.pitDriveTest].string
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
    if let value = pitMaxHeight { dictionary[SerializationKeys.pitMaxHeight] = value }
    dictionary[SerializationKeys.pitAvailableWeight] = pitAvailableWeight
    dictionary[SerializationKeys.picklistPosition] = picklistPosition
    if let value = pitDriveTest { dictionary[SerializationKeys.pitDriveTest] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
    self.pitDriveTrain = aDecoder.decodeObject(forKey: SerializationKeys.pitDriveTrain) as? String
    self.number = (aDecoder.decodeObject(forKey: SerializationKeys.number) as? Int)!
    self.calculatedData = aDecoder.decodeObject(forKey: SerializationKeys.calculatedData) as? CalculatedTeamData
    self.pitAllImageURLs = aDecoder.decodeObject(forKey: SerializationKeys.pitAllImageURLs) as? [String:String]
    self.pitSEALsNotes = aDecoder.decodeObject(forKey: SerializationKeys.pitSEALsNotes) as? String
    self.pitCanCheesecake = aDecoder.decodeBool(forKey: SerializationKeys.pitCanCheesecake)
    self.pitSelectedImage = aDecoder.decodeObject(forKey: SerializationKeys.pitSelectedImage) as? String
    self.numMatchesPlayed = aDecoder.decodeObject(forKey: SerializationKeys.numMatchesPlayed) as? Int
    self.pitClimberType = aDecoder.decodeObject(forKey: SerializationKeys.pitClimberType) as? String
    self.pitProgrammingLanguage = aDecoder.decodeObject(forKey: SerializationKeys.pitProgrammingLanguage) as? String
    self.pitAvailableWeight = (aDecoder.decodeObject(forKey: SerializationKeys.pitAvailableWeight) as? Float)!
    self.pitMaxHeight = aDecoder.decodeObject(forKey: SerializationKeys.pitMaxHeight) as? Float
    self.picklistPosition = (aDecoder.decodeObject(forKey: SerializationKeys.picklistPosition) as? Int)!
    self.pitDriveTest = aDecoder.decodeObject(forKey: SerializationKeys.pitDriveTest) as? String
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
    aCoder.encode(pitMaxHeight, forKey: SerializationKeys.pitMaxHeight)
    aCoder.encode(picklistPosition, forKey: SerializationKeys.picklistPosition)
    aCoder.encode(pitDriveTest, forKey: SerializationKeys.pitDriveTest)
  }

}
