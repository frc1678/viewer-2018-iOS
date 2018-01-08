//
//  Match.swift
//
//  Created by Bryton Moeller on 1/18/17
//  Copyright (c) Citrus Circuits. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Team: NSObject {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let pitOrganization = "pitOrganization"
    static let pitProgrammingLanguage = "pitProgrammingLanguage"
    static let number = "number"
    static let pitAvailableWeight = "pitAvailableWeight"
    static let calculatedData = "calculatedData"
    static let pitSelectedImageName = "pitSelectedImageName"
    static let pitAllImageURLs = "pitAllImageURLs"
    static let pitDriveTrain = "pitDriveTrain"
    static let pitDidDemonstrateCheesecakePotential = "pitDidDemonstrateCheesecakePotential"
    static let pitSEALSNotes = "pitSEALSNotes"
  }

  // MARK: Properties
  public var name: String?
  public var pitOrganization: String?
  public var pitProgrammingLanguage: String?
  public var number: Int = -1
  public var pitAvailableWeight: Int = -1
  public var calculatedData: CalculatedTeamData?
  public var pitSelectedImageName: String?
  public var pitAllImageURLs: [String: String]?
  public var pitDriveTrain: String?
  public var pitDidDemonstrateCheesecakePotential: Bool? = false
  public var pitSEALSNotes: String?

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
    pitOrganization = json[SerializationKeys.pitOrganization].string
    pitProgrammingLanguage = json[SerializationKeys.pitProgrammingLanguage].string
    number = json[SerializationKeys.number].intValue
    pitAvailableWeight = json[SerializationKeys.pitAvailableWeight].intValue
    calculatedData = CalculatedTeamData(json: json[SerializationKeys.calculatedData])
    pitSelectedImageName = json[SerializationKeys.pitSelectedImageName].string
    pitAllImageURLs = json[SerializationKeys.pitAllImageURLs].dictionaryObject as! [String: String]?
    pitDriveTrain = json[SerializationKeys.pitDriveTrain].string
    pitDidDemonstrateCheesecakePotential = json[SerializationKeys.pitDidDemonstrateCheesecakePotential].boolValue
    pitSEALSNotes = json[SerializationKeys.pitSEALSNotes].stringValue
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = pitOrganization { dictionary[SerializationKeys.pitOrganization] = value }
    if let value = pitProgrammingLanguage { dictionary[SerializationKeys.pitProgrammingLanguage] = value }
    dictionary[SerializationKeys.number] = number
    dictionary[SerializationKeys.pitAvailableWeight] = pitAvailableWeight
    if let value = calculatedData { dictionary[SerializationKeys.calculatedData] = value.dictionaryRepresentation() }
    if let value = pitSelectedImageName { dictionary[SerializationKeys.pitSelectedImageName] = value }
    if let value = pitAllImageURLs { dictionary[SerializationKeys.pitAllImageURLs] = value }
    if let value = pitSEALSNotes { dictionary[SerializationKeys.pitSEALSNotes] = value }
    
    dictionary[SerializationKeys.pitDriveTrain] = pitDriveTrain
    dictionary[SerializationKeys.pitDidDemonstrateCheesecakePotential] = pitDidDemonstrateCheesecakePotential
    return dictionary
  }

}
