//
//  Climb.swift
//
//  Created by Carter Luck on 1/14/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class SlackProfile: NSObject {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let starredMatches = "starredMatches"
    static let appToken = "appToken"
    static let tag = "tag"
    static let notifyInAdvance = "notifyInAdvance"
  }

  // MARK: Properties
    public var name: String?
    public var starredMatches: [String:Int]?
    public var appToken: String?
    public var tag: String?
    public var notifyInAdvance: Int?

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
    starredMatches = json[SerializationKeys.starredMatches].dictionaryObject as? [String : Int]
    appToken = json[SerializationKeys.appToken].string
    tag = json[SerializationKeys.tag].string
    notifyInAdvance = json[SerializationKeys.notifyInAdvance].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[SerializationKeys.name] = value }
    dictionary[SerializationKeys.starredMatches] = starredMatches
    if let value = appToken { dictionary[SerializationKeys.appToken] = value }
    if let value = tag { dictionary[SerializationKeys.tag] = value }
    if let value = notifyInAdvance { dictionary[SerializationKeys.notifyInAdvance] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
    self.starredMatches = aDecoder.decodeObject(forKey: SerializationKeys.starredMatches) as? [String:Int]
    self.appToken = aDecoder.decodeObject(forKey: SerializationKeys.appToken) as? String
    self.tag = aDecoder.decodeObject(forKey: SerializationKeys.tag) as? String
    self.notifyInAdvance = aDecoder.decodeObject(forKey: SerializationKeys.notifyInAdvance) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: SerializationKeys.name)
    aCoder.encode(starredMatches, forKey: SerializationKeys.starredMatches)
    aCoder.encode(appToken, forKey: SerializationKeys.appToken)
    aCoder.encode(tag, forKey: SerializationKeys.tag)
    aCoder.encode(notifyInAdvance, forKey: SerializationKeys.notifyInAdvance)
  }
}
