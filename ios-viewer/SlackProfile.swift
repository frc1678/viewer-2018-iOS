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
    static let username = "username"
    static let starredMatches = "starredMatches"
    static let appToken = "appToken"
    static let displayName = "displayName"
  }

  // MARK: Properties
    public var username: String?
    public var starredMatches: [String:Int]?
    public var appToken: String?
    public var displayName: String?

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
    username = json[SerializationKeys.username].string
    starredMatches = json[SerializationKeys.starredMatches].dictionaryObject as? [String : Int]
    appToken = json[SerializationKeys.appToken].string
    displayName = json[SerializationKeys.displayName].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = username { dictionary[SerializationKeys.username] = value }
    dictionary[SerializationKeys.starredMatches] = starredMatches
    if let value = appToken { dictionary[SerializationKeys.appToken] = value }
    if let value = displayName { dictionary[SerializationKeys.displayName] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.username = aDecoder.decodeObject(forKey: SerializationKeys.username) as? String
    self.starredMatches = aDecoder.decodeObject(forKey: SerializationKeys.starredMatches) as? [String:Int]
    self.appToken = aDecoder.decodeObject(forKey: SerializationKeys.appToken) as? String
    self.displayName = aDecoder.decodeObject(forKey: SerializationKeys.displayName) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(username, forKey: SerializationKeys.username)
    aCoder.encode(starredMatches, forKey: SerializationKeys.starredMatches)
    aCoder.encode(appToken, forKey: SerializationKeys.appToken)
    aCoder.encode(displayName, forKey: SerializationKeys.displayName)
  }

}
