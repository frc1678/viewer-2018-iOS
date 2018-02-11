//
//  Team.swift
//
//  Created by Carter Luck on 1/14/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class TimedData: NSObject {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let didSucceed = "didSucceed"
    static let time = "time"
  }

  // MARK: Properties
    public var didSucceed : Bool?
    public var time : Float?
    
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
    didSucceed = json[SerializationKeys.didSucceed].bool
    time = json[SerializationKeys.time].float
}

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = didSucceed { dictionary[SerializationKeys.didSucceed] = value }
    if let value = time { dictionary[SerializationKeys.didSucceed] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.didSucceed = aDecoder.decodeObject(forKey: SerializationKeys.didSucceed) as? Bool
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(didSucceed, forKey: SerializationKeys.didSucceed)
    aCoder.encode(time, forKey: SerializationKeys.time)
  }

}
