//
//  CalculatedTeamData.swift
//
//  Created by Carter Luck on 1/14/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class CalculatedTeamData: NSObject, NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let avgNumCubesFumbledAuto = "avgNumCubesFumbledAuto"
    static let avgNumHumanPortalIntakeTele = "avgNumHumanPortalIntakeTele"
    static let switchFailPercentageAuto = "switchFailPercentageAuto"
    static let avgNumElevatedPyramidIntakeAuto = "avgNumElevatedPyramidIntakeAuto"
    static let avgAllianceSwitchCubesTele = "avgAllianceSwitchCubesTele"
    static let avgOpponentSwitchCubesTele = "avgOpponentSwitchCubesTele"
    static let avgCubesPlacedInScaleTele = "avgCubesPlacedInScaleTele"
    static let avgAgility = "avgAgility"
    static let secondPickAbility = "secondPickAbility"
    static let avgNumGoodDecisions = "avgNumGoodDecisions"
    static let avgNumAlliancePlatformIntakeAuto = "avgNumAlliancePlatformIntakeAuto"
    static let avgNumReturnIntakeTele = "avgNumReturnIntakeTele"
    static let avgNumOpponentPlatformIntakeTele = "avgNumOpponentPlatformIntakeTele"
    static let avgNumBadDecisions = "avgNumBadDecisions"
    static let avgClimbTime = "avgClimbTime"
    static let predictedClimb = "predictedClimb"
    static let avgDrivingAbility = "avgDrivingAbility"
    static let avgNumExchangeInputTele = "avgNumExchangeInputTele"
    static let avgDefense = "avgDefense"
    static let avgCubesPlacedInScaleAuto = "avgCubesPlacedInScaleAuto"
    static let disabledPercentage = "disabledPercentage"
    static let predictedNumScaleCubesAuto = "predictedNumScaleCubesAuto"
    static let scaleFailPercentageTele = "scaleFailPercentageTele"
    static let incapacitatedPercentage = "incapacitatedPercentage"
    static let predictedNumAllianceSwitchCubesAuto = "predictedNumAllianceSwitchCubesAuto"
    static let autoRunPercentage = "autoRunPercentage"
    static let avgNumCubesFumbledTele = "avgNumCubesFumbledTele"
    static let scaleFailPercentageAuto = "scaleFailPercentageAuto"
    static let avgCubesSpilledAuto = "avgCubesSpilledAuto"
    static let avgCubesSpilledTele = "avgCubesSpilledTele"
    static let avgAllianceSwitchCubesAuto = "avgAllianceSwitchCubesAuto"
    static let avgOpponentSwitchCubesAuto = "avgOpponentSwitchCubesAuto"
    static let switchFailPercentageTele = "switchFailPercentageTele"
    static let avgNumAlliancePlatformIntakeTele = "avgNumAlliancePlatformIntakeTele"
    static let avgNumGroundIntakeTele = "avgNumGroundIntakeTele"
    static let climbPercentage = "climbPercentage"
    static let avgNumOpponentPlatformIntakeAuto = "avgNumOpponentPlatformIntakeAuto"
    static let canScoreBothSwitchSidesAuto = "canScoreBothSwitchSidesAuto"
    static let avgNumGroundPortalIntakeTele = "avgNumGroundPortalIntakeTele"
    static let avgNumElevatedPyramidIntakeTele = "avgNumElevatedPyramidIntakeTele"
    static let avgNumGroundPyramidIntakeTele = "avgNumGroundPyramidIntakeTele"
    static let numMatchesPlayed = "numMatchesPlayed"
    static let avgNumGroundPyramidIntakeAuto = "avgNumGroundPyramidIntakeAuto"
    static let avgSpeed = "avgSpeed"
    static let firstPickAbility = "firstPickAbility"
    static let actualSeed = "actualSeed"
    static let predictedSeed = "predictedSeed"
    static let predictedNumRPs = "predictedNumRPs"
    static let actualNumRPs = "actualNumRPs"
    static let dysfunctionalPercentage = "dysfunctionalPercentage"
    static let totalNumGoodDecisions = "totalNumGoodDecisions"
    static let totalNumBadDecisions = "totalNumBadDecisions"
    static let avgNumRobotsLifted = "avgNumRobotsLifted"
    static let avgTimeToOwnAllianceSwitchAuto = "avgTimeToOwnAllianceSwitchAuto"
    static let avgTimeToOwnScaleAuto = "avgTimeToOwnScaleAuto"
    static let parkPercentage = "parkPercentage"
    static let percentSuccessOppositeSwitchSideAuto = "percentSuccessOppositeSwitchSideAuto"
    static let allianceSwitchSuccessPercentageAuto = "allianceSwitchSuccessPercentageAuto"
    static let canPlaceHighLayerCube = "canPlaceHighLayerCube"
    static let pitAvgDriveTime = "pitAvgDriveTime"
    static let pitAvgRampTime = "pitAvgRampTime"
    static let avgTotalCubesPlaced = "avgTotalCubesPlaced"
    static let avgSwitchOwnership = "avgSwitchOwnership"
    static let avgScaleCubesBy100s = "avgScaleCubesBy100s"
    static let avgScaleCubesBy110s = "avgScaleCubesBy110s"
    static let avgAllVaultTime = "avgAllVaultTime"
 }

  // MARK: Properties
  @objc public var avgNumCubesFumbledAuto: Float = -1.0
  @objc public var avgNumHumanPortalIntakeTele: Float = -1.0
  @objc public var switchFailPercentageAuto: Float = -1.0
  @objc public var avgNumElevatedPyramidIntakeAuto: Float = -1.0
  @objc public var avgOpponentSwitchCubesAuto: Float = -1.0
  @objc public var avgOpponentSwitchCubesTele: Float = -1.0
  @objc public var avgAllianceSwitchCubesAuto: Float = -1.0
  @objc public var avgAllianceSwitchCubesTele: Float = -1.0
  @objc public var avgAgility: Float = -1.0
  @objc public var secondPickAbility: Float = -1.0
  @objc public var avgNumGoodDecisions: Float = -1.0
  @objc public var avgNumAlliancePlatformIntakeAuto: Float = -1.0
  @objc public var avgNumReturnIntakeTele: Float = -1.0
  @objc public var avgNumOpponentPlatformIntakeTele: Float = -1.0
  @objc public var avgNumBadDecisions: Float = -1.0
  @objc public var avgClimbTime: Float = -1.0
  @objc public var predictedClimb: Float = -1.0
  @objc public var avgDrivingAbility: Float = -1.0
  @objc public var avgNumExchangeInputTele: Float = -1.0
  @objc public var avgDefense: Float = -1.0
  @objc public var avgCubesPlacedInScaleAuto: Float = -1.0
  @objc public var disabledPercentage: Float = -1.0
  @objc public var predictedNumScaleCubesAuto: Float = -1.0
  @objc public var scaleFailPercentageTele: Float = -1.0
  @objc public var incapacitatedPercentage: Float = -1.0
  @objc public var predictedNumAllianceSwitchCubesAuto: Float = -1.0
  @objc public var autoRunPercentage: Float = -1.0
  @objc public var avgNumCubesFumbledTele: Float = -1.0
  @objc public var scaleFailPercentageAuto: Float = -1.0
  @objc public var avgCubesSpilledAuto: Float = -1.0
  @objc public var avgCubesSpilledTele: Float = -1.0
  @objc public var switchFailPercentageTele: Float = -1.0
  @objc public var avgNumAlliancePlatformIntakeTele: Float = -1.0
  @objc public var avgNumGroundIntakeTele: Float = -1.0
  @objc public var climbPercentage: Float = -1.0
  @objc public var avgNumOpponentPlatformIntakeAuto: Float = -1.0
  @objc public var canScoreBothSwitchSidesAuto: Bool = false
  @objc public var avgNumGroundPortalIntakeTele: Float = -1.0
  @objc public var avgNumElevatedPyramidIntakeTele: Float = -1.0
  @objc public var avgNumGroundPyramidIntakeTele: Float = -1.0
  public var numMatchesPlayed: Int?
  @objc public var avgNumGroundPyramidIntakeAuto: Float = -1.0
  @objc public var avgSpeed: Float = -1.0
  @objc public var firstPickAbility: Float = -1.0
    @objc public var actualSeed: Int = -1
    @objc public var predictedSeed: Int = -1
    @objc public var predictedNumRPs: Float = 1.0
    @objc public var actualNumRPs: Float = -1.0
    @objc public var dysfunctionalPercentage: Float = -1.0
    @objc public var avgCubesPlacedInScaleTele: Float = -1.0
    @objc public var totalNumGoodDecisions: Int = -1
    @objc public var totalNumBadDecisions: Int = -1
    @objc public var avgNumRobotsLifted: Float = -1.0
    @objc public var avgTimeToOwnAllianceSwitchAuto: Float = -1.0
    @objc public var avgTimeToOwnScaleAuto: Float = -1.0
    @objc public var parkPercentage: Float = -1.0
    @objc public var percentSuccessOppositeSwitchSideAuto: Float = -1.0
    @objc public var allianceSwitchSuccessPercentageAuto: Float = -1.0
    @objc public var canPlaceHighLayerCube: Bool = false
    @objc public var pitAvgDriveTime: Float = -1.0
    @objc public var pitAvgRampTime: Float = -1.0
    @objc public var avgTotalCubesPlaced: Float = -1.0
    @objc public var avgSwitchOwnership: Int = -1
    @objc public var avgScaleCubesBy100s: Float = -1.0
    @objc public var avgScaleCubesBy110s: Float = -1.0
    @objc public var avgAllVaultTime: Float = -1.0
    
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
    avgNumCubesFumbledAuto = json[SerializationKeys.avgNumCubesFumbledAuto].floatValue
    avgNumHumanPortalIntakeTele = json[SerializationKeys.avgNumHumanPortalIntakeTele].floatValue
    switchFailPercentageAuto = json[SerializationKeys.switchFailPercentageAuto].floatValue
    avgNumElevatedPyramidIntakeAuto = json[SerializationKeys.avgNumElevatedPyramidIntakeAuto].floatValue
    avgAllianceSwitchCubesAuto = json[SerializationKeys.avgAllianceSwitchCubesAuto].floatValue
    avgAllianceSwitchCubesTele = json[SerializationKeys.avgAllianceSwitchCubesTele].floatValue
    avgOpponentSwitchCubesAuto = json[SerializationKeys.avgOpponentSwitchCubesAuto].floatValue
    avgOpponentSwitchCubesTele = json[SerializationKeys.avgOpponentSwitchCubesTele].floatValue
    avgAgility = json[SerializationKeys.avgAgility].floatValue
    secondPickAbility = json[SerializationKeys.secondPickAbility].floatValue
    avgNumGoodDecisions = json[SerializationKeys.avgNumGoodDecisions].floatValue
    avgNumAlliancePlatformIntakeAuto = json[SerializationKeys.avgNumAlliancePlatformIntakeAuto].floatValue
    avgNumReturnIntakeTele = json[SerializationKeys.avgNumReturnIntakeTele].floatValue
    avgNumOpponentPlatformIntakeTele = json[SerializationKeys.avgNumOpponentPlatformIntakeTele].floatValue
    avgNumBadDecisions = json[SerializationKeys.avgNumBadDecisions].floatValue
    avgClimbTime = json[SerializationKeys.avgClimbTime].floatValue
    predictedClimb = json[SerializationKeys.predictedClimb].floatValue
    avgDrivingAbility = json[SerializationKeys.avgDrivingAbility].floatValue
    avgNumExchangeInputTele = json[SerializationKeys.avgNumExchangeInputTele].floatValue
    avgDefense = json[SerializationKeys.avgDefense].floatValue
    avgCubesPlacedInScaleAuto = json[SerializationKeys.avgCubesPlacedInScaleAuto].floatValue
    disabledPercentage = json[SerializationKeys.disabledPercentage].floatValue
    predictedNumScaleCubesAuto = json[SerializationKeys.predictedNumScaleCubesAuto].floatValue
    scaleFailPercentageTele = json[SerializationKeys.scaleFailPercentageTele].floatValue
    incapacitatedPercentage = json[SerializationKeys.incapacitatedPercentage].floatValue
    predictedNumAllianceSwitchCubesAuto = json[SerializationKeys.predictedNumAllianceSwitchCubesAuto].floatValue
    autoRunPercentage = json[SerializationKeys.autoRunPercentage].floatValue
    avgNumCubesFumbledTele = json[SerializationKeys.avgNumCubesFumbledTele].floatValue
    scaleFailPercentageAuto = json[SerializationKeys.scaleFailPercentageAuto].floatValue
    avgCubesSpilledAuto = json[SerializationKeys.avgCubesSpilledAuto].floatValue
    avgCubesSpilledTele = json[SerializationKeys.avgCubesSpilledTele].floatValue
    avgAllianceSwitchCubesTele = json[SerializationKeys.avgAllianceSwitchCubesTele].floatValue
    avgAllianceSwitchCubesAuto = json[SerializationKeys.avgAllianceSwitchCubesAuto].floatValue
    avgOpponentSwitchCubesTele = json[SerializationKeys.avgOpponentSwitchCubesTele].floatValue
    avgOpponentSwitchCubesAuto = json[SerializationKeys.avgOpponentSwitchCubesAuto].floatValue
    switchFailPercentageTele = json[SerializationKeys.switchFailPercentageTele].floatValue
    avgNumAlliancePlatformIntakeTele = json[SerializationKeys.avgNumAlliancePlatformIntakeTele].floatValue
    avgNumGroundIntakeTele = json[SerializationKeys.avgNumGroundIntakeTele].floatValue
    climbPercentage = json[SerializationKeys.climbPercentage].floatValue
    avgNumOpponentPlatformIntakeAuto = json[SerializationKeys.avgNumOpponentPlatformIntakeAuto].floatValue
    canScoreBothSwitchSidesAuto = json[SerializationKeys.canScoreBothSwitchSidesAuto].boolValue
    avgNumGroundPortalIntakeTele = json[SerializationKeys.avgNumGroundPortalIntakeTele].floatValue
    avgNumElevatedPyramidIntakeTele = json[SerializationKeys.avgNumElevatedPyramidIntakeTele].floatValue
    avgNumGroundPyramidIntakeTele = json[SerializationKeys.avgNumGroundPyramidIntakeTele].floatValue
    numMatchesPlayed = json[SerializationKeys.numMatchesPlayed].int
    avgNumGroundPyramidIntakeAuto = json[SerializationKeys.avgNumGroundPyramidIntakeAuto].floatValue
    avgSpeed = json[SerializationKeys.avgSpeed].floatValue
    firstPickAbility = json[SerializationKeys.firstPickAbility].floatValue
    actualSeed = json[SerializationKeys.actualSeed].intValue
    predictedSeed = json[SerializationKeys.predictedSeed].intValue
    predictedNumRPs = json[SerializationKeys.predictedNumRPs].floatValue
    actualNumRPs = json[SerializationKeys.actualNumRPs].floatValue
    dysfunctionalPercentage = json[SerializationKeys.dysfunctionalPercentage].floatValue
    avgCubesPlacedInScaleTele = json[SerializationKeys.avgCubesPlacedInScaleTele].floatValue
    totalNumGoodDecisions = json[SerializationKeys.totalNumGoodDecisions].intValue
    totalNumBadDecisions = json[SerializationKeys.totalNumBadDecisions].intValue
    avgNumRobotsLifted = json[SerializationKeys.avgNumRobotsLifted].floatValue
    avgTimeToOwnAllianceSwitchAuto = json[SerializationKeys.avgTimeToOwnAllianceSwitchAuto].floatValue
    avgTimeToOwnScaleAuto = json[SerializationKeys.avgTimeToOwnScaleAuto].floatValue
    parkPercentage = json[SerializationKeys.parkPercentage].floatValue
    percentSuccessOppositeSwitchSideAuto = json[SerializationKeys.percentSuccessOppositeSwitchSideAuto].floatValue
    allianceSwitchSuccessPercentageAuto = json[SerializationKeys.allianceSwitchSuccessPercentageAuto].floatValue
    canPlaceHighLayerCube = json[SerializationKeys.canPlaceHighLayerCube].boolValue
    pitAvgDriveTime = json[SerializationKeys.pitAvgDriveTime].floatValue
    pitAvgRampTime = json[SerializationKeys.pitAvgRampTime].floatValue
    avgTotalCubesPlaced = json[SerializationKeys.avgTotalCubesPlaced].floatValue
    avgSwitchOwnership = json[SerializationKeys.avgSwitchOwnership].intValue
    avgScaleCubesBy100s = json[SerializationKeys.avgScaleCubesBy100s].floatValue
    avgScaleCubesBy110s = json[SerializationKeys.avgScaleCubesBy110s].floatValue
    avgAllVaultTime = json[SerializationKeys.avgAllVaultTime].floatValue
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    dictionary[SerializationKeys.avgNumCubesFumbledAuto] = avgNumCubesFumbledAuto
    dictionary[SerializationKeys.avgNumHumanPortalIntakeTele] = avgNumHumanPortalIntakeTele
    dictionary[SerializationKeys.switchFailPercentageAuto] = switchFailPercentageAuto
    dictionary[SerializationKeys.avgNumElevatedPyramidIntakeAuto] = avgNumElevatedPyramidIntakeAuto
    dictionary[SerializationKeys.avgAllianceSwitchCubesTele] = avgAllianceSwitchCubesTele
    dictionary[SerializationKeys.avgAllianceSwitchCubesAuto] = avgAllianceSwitchCubesAuto
    dictionary[SerializationKeys.avgOpponentSwitchCubesTele] = avgOpponentSwitchCubesTele
    dictionary[SerializationKeys.avgOpponentSwitchCubesTele] = avgOpponentSwitchCubesAuto
    dictionary[SerializationKeys.avgAgility] = avgAgility
    dictionary[SerializationKeys.secondPickAbility] = secondPickAbility
    dictionary[SerializationKeys.avgNumGoodDecisions] = avgNumGoodDecisions
    dictionary[SerializationKeys.avgNumAlliancePlatformIntakeAuto] = avgNumAlliancePlatformIntakeAuto
    dictionary[SerializationKeys.avgNumReturnIntakeTele] = avgNumReturnIntakeTele
    dictionary[SerializationKeys.avgNumOpponentPlatformIntakeTele] = avgNumOpponentPlatformIntakeTele
    dictionary[SerializationKeys.avgNumBadDecisions] = avgNumBadDecisions
    dictionary[SerializationKeys.avgClimbTime] = avgClimbTime
    dictionary[SerializationKeys.predictedClimb] = predictedClimb
    dictionary[SerializationKeys.avgDrivingAbility] = avgDrivingAbility
    dictionary[SerializationKeys.avgNumExchangeInputTele] = avgNumExchangeInputTele
    dictionary[SerializationKeys.avgDefense] = avgDefense
    dictionary[SerializationKeys.avgCubesPlacedInScaleAuto] = avgCubesPlacedInScaleAuto
    dictionary[SerializationKeys.disabledPercentage] = disabledPercentage
    dictionary[SerializationKeys.predictedNumScaleCubesAuto] = predictedNumScaleCubesAuto
    dictionary[SerializationKeys.scaleFailPercentageTele] = scaleFailPercentageTele
    dictionary[SerializationKeys.incapacitatedPercentage] = incapacitatedPercentage
    dictionary[SerializationKeys.predictedNumAllianceSwitchCubesAuto] = predictedNumAllianceSwitchCubesAuto
    dictionary[SerializationKeys.autoRunPercentage] = autoRunPercentage
    dictionary[SerializationKeys.avgNumCubesFumbledTele] = avgNumCubesFumbledTele
    dictionary[SerializationKeys.scaleFailPercentageAuto] = scaleFailPercentageAuto
    dictionary[SerializationKeys.avgCubesSpilledAuto] = avgCubesSpilledAuto
    dictionary[SerializationKeys.avgCubesSpilledTele] = avgCubesSpilledTele
    dictionary[SerializationKeys.switchFailPercentageTele] = switchFailPercentageTele
    dictionary[SerializationKeys.avgNumAlliancePlatformIntakeTele] = avgNumAlliancePlatformIntakeTele
    dictionary[SerializationKeys.avgNumGroundIntakeTele] = avgNumGroundIntakeTele
    dictionary[SerializationKeys.climbPercentage] = climbPercentage
    dictionary[SerializationKeys.avgNumOpponentPlatformIntakeAuto] = avgNumOpponentPlatformIntakeAuto
    dictionary[SerializationKeys.canScoreBothSwitchSidesAuto] = canScoreBothSwitchSidesAuto
    dictionary[SerializationKeys.avgNumGroundPortalIntakeTele] = avgNumGroundPortalIntakeTele
    dictionary[SerializationKeys.avgNumElevatedPyramidIntakeAuto] = avgNumElevatedPyramidIntakeAuto
    dictionary[SerializationKeys.avgNumGroundPyramidIntakeTele] = avgNumGroundPyramidIntakeTele
    if let value = numMatchesPlayed { dictionary[SerializationKeys.numMatchesPlayed] = value }
    dictionary[SerializationKeys.avgNumGroundPyramidIntakeAuto] = avgNumGroundPyramidIntakeAuto

    dictionary[SerializationKeys.avgSpeed] = avgSpeed
    dictionary[SerializationKeys.firstPickAbility] = firstPickAbility
    dictionary[SerializationKeys.actualSeed] = actualSeed
    dictionary[SerializationKeys.predictedSeed] = predictedSeed
    dictionary[SerializationKeys.predictedNumRPs] = predictedNumRPs
    dictionary[SerializationKeys.actualNumRPs] = actualNumRPs
    dictionary[SerializationKeys.dysfunctionalPercentage] = dysfunctionalPercentage
    dictionary[SerializationKeys.avgCubesPlacedInScaleTele] = avgCubesPlacedInScaleTele
    dictionary[SerializationKeys.totalNumGoodDecisions] = totalNumGoodDecisions
    dictionary[SerializationKeys.totalNumBadDecisions] = totalNumBadDecisions
    dictionary[SerializationKeys.avgNumRobotsLifted] = avgNumRobotsLifted
    dictionary[SerializationKeys.avgTimeToOwnAllianceSwitchAuto] = avgTimeToOwnAllianceSwitchAuto
    dictionary[SerializationKeys.avgTimeToOwnScaleAuto] = avgTimeToOwnScaleAuto
    dictionary[SerializationKeys.parkPercentage] = parkPercentage
    dictionary[SerializationKeys.percentSuccessOppositeSwitchSideAuto] = percentSuccessOppositeSwitchSideAuto
    dictionary[SerializationKeys.allianceSwitchSuccessPercentageAuto] = allianceSwitchSuccessPercentageAuto
    dictionary[SerializationKeys.canPlaceHighLayerCube] = canPlaceHighLayerCube
    dictionary[SerializationKeys.pitAvgDriveTime] = pitAvgDriveTime
    dictionary[SerializationKeys.pitAvgRampTime] = pitAvgRampTime
    dictionary[SerializationKeys.avgTotalCubesPlaced] = avgTotalCubesPlaced
    dictionary[SerializationKeys.avgSwitchOwnership] = avgSwitchOwnership
    dictionary[SerializationKeys.avgScaleCubesBy100s] = avgScaleCubesBy100s
    dictionary[SerializationKeys.avgScaleCubesBy110s] = avgScaleCubesBy110s
    dictionary[SerializationKeys.avgAllVaultTime] = avgAllVaultTime
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.avgNumCubesFumbledAuto = aDecoder.decodeFloat(forKey: SerializationKeys.avgNumCubesFumbledAuto)
    self.avgNumHumanPortalIntakeTele = aDecoder.decodeFloat(forKey: SerializationKeys.avgNumHumanPortalIntakeTele)
    self.switchFailPercentageAuto = aDecoder.decodeFloat(forKey: SerializationKeys.switchFailPercentageAuto)
    self.avgNumElevatedPyramidIntakeAuto = aDecoder.decodeFloat(forKey: SerializationKeys.avgNumElevatedPyramidIntakeAuto)
    self.avgAllianceSwitchCubesTele = aDecoder.decodeFloat(forKey: SerializationKeys.avgAllianceSwitchCubesTele)
    self.avgAllianceSwitchCubesAuto = aDecoder.decodeFloat(forKey: SerializationKeys.avgAllianceSwitchCubesAuto)
    self.avgOpponentSwitchCubesTele = aDecoder.decodeFloat(forKey: SerializationKeys.avgOpponentSwitchCubesTele)
    self.avgOpponentSwitchCubesAuto = aDecoder.decodeFloat(forKey: SerializationKeys.avgOpponentSwitchCubesAuto)
    self.avgAgility = aDecoder.decodeFloat(forKey: SerializationKeys.avgAgility)
    self.secondPickAbility = aDecoder.decodeFloat(forKey: SerializationKeys.secondPickAbility)
    self.avgNumGoodDecisions = aDecoder.decodeFloat(forKey: SerializationKeys.avgNumGoodDecisions)
    self.avgNumAlliancePlatformIntakeAuto = aDecoder.decodeFloat(forKey: SerializationKeys.avgNumAlliancePlatformIntakeAuto)
    self.avgNumReturnIntakeTele = aDecoder.decodeFloat(forKey: SerializationKeys.avgNumReturnIntakeTele)
    self.avgNumOpponentPlatformIntakeTele = aDecoder.decodeFloat(forKey: SerializationKeys.avgNumOpponentPlatformIntakeTele)
    self.avgNumBadDecisions = aDecoder.decodeFloat(forKey: SerializationKeys.avgNumBadDecisions)
    self.avgClimbTime = aDecoder.decodeFloat(forKey: SerializationKeys.avgClimbTime)
    self.predictedClimb = aDecoder.decodeFloat(forKey: SerializationKeys.predictedClimb)
    self.avgDrivingAbility = aDecoder.decodeFloat(forKey: SerializationKeys.avgDrivingAbility)
    self.avgNumExchangeInputTele = aDecoder.decodeFloat(forKey: SerializationKeys.avgNumExchangeInputTele)
    self.avgDefense = aDecoder.decodeFloat(forKey: SerializationKeys.avgDefense)
    self.avgCubesPlacedInScaleAuto = aDecoder.decodeFloat(forKey: SerializationKeys.avgCubesPlacedInScaleAuto)
    self.disabledPercentage = aDecoder.decodeFloat(forKey: SerializationKeys.disabledPercentage)
    self.predictedNumScaleCubesAuto = aDecoder.decodeFloat(forKey: SerializationKeys.predictedNumScaleCubesAuto)
    self.scaleFailPercentageTele = aDecoder.decodeFloat(forKey: SerializationKeys.scaleFailPercentageTele)
    self.incapacitatedPercentage = aDecoder.decodeFloat(forKey: SerializationKeys.incapacitatedPercentage)
    self.predictedNumAllianceSwitchCubesAuto = aDecoder.decodeFloat(forKey: SerializationKeys.predictedNumAllianceSwitchCubesAuto)
    self.autoRunPercentage = aDecoder.decodeFloat(forKey: SerializationKeys.autoRunPercentage)
    self.avgNumCubesFumbledTele = aDecoder.decodeFloat(forKey: SerializationKeys.avgNumCubesFumbledTele)
    self.scaleFailPercentageAuto = aDecoder.decodeFloat(forKey: SerializationKeys.scaleFailPercentageAuto)
    self.avgCubesSpilledAuto = aDecoder.decodeFloat(forKey: SerializationKeys.avgCubesSpilledAuto)
    self.avgCubesSpilledTele = aDecoder.decodeFloat(forKey: SerializationKeys.avgCubesSpilledTele)
    self.switchFailPercentageTele = aDecoder.decodeFloat(forKey: SerializationKeys.switchFailPercentageTele)
    self.avgNumAlliancePlatformIntakeTele = aDecoder.decodeFloat(forKey: SerializationKeys.avgNumAlliancePlatformIntakeTele)
    self.avgNumGroundIntakeTele = aDecoder.decodeFloat(forKey: SerializationKeys.avgNumGroundIntakeTele)
    self.climbPercentage = aDecoder.decodeFloat(forKey: SerializationKeys.climbPercentage)
    self.avgNumOpponentPlatformIntakeAuto = aDecoder.decodeFloat(forKey: SerializationKeys.avgNumOpponentPlatformIntakeAuto)
    self.canScoreBothSwitchSidesAuto = aDecoder.decodeBool(forKey: SerializationKeys.canScoreBothSwitchSidesAuto)
    self.avgNumGroundPortalIntakeTele = aDecoder.decodeFloat(forKey: SerializationKeys.avgNumGroundPortalIntakeTele)
    self.avgNumElevatedPyramidIntakeTele = aDecoder.decodeFloat(forKey: SerializationKeys.avgNumElevatedPyramidIntakeTele)
    self.avgNumGroundPyramidIntakeTele = aDecoder.decodeFloat(forKey: SerializationKeys.avgNumGroundPyramidIntakeTele)
    self.numMatchesPlayed = aDecoder.decodeObject(forKey: SerializationKeys.numMatchesPlayed) as? Int
    self.avgNumGroundPyramidIntakeAuto = aDecoder.decodeFloat(forKey: SerializationKeys.avgNumGroundPyramidIntakeAuto)
    self.avgSpeed = aDecoder.decodeFloat(forKey: SerializationKeys.avgSpeed)
    self.firstPickAbility = aDecoder.decodeFloat(forKey: SerializationKeys.firstPickAbility)
    self.actualSeed = aDecoder.decodeInteger(forKey: SerializationKeys.actualSeed)
     self.predictedSeed = aDecoder.decodeInteger(forKey: SerializationKeys.predictedSeed)
    self.predictedNumRPs = aDecoder.decodeFloat(forKey: SerializationKeys.predictedNumRPs)
    self.actualNumRPs = aDecoder.decodeFloat(forKey: SerializationKeys.actualNumRPs)
    self.dysfunctionalPercentage = aDecoder.decodeFloat(forKey: SerializationKeys.dysfunctionalPercentage)
    self.avgCubesPlacedInScaleTele = aDecoder.decodeFloat(forKey: SerializationKeys.avgCubesPlacedInScaleTele)
    self.totalNumGoodDecisions = aDecoder.decodeInteger(forKey: SerializationKeys.totalNumGoodDecisions)
    self.totalNumBadDecisions = aDecoder.decodeInteger(forKey: SerializationKeys.totalNumBadDecisions)
    self.avgNumRobotsLifted = aDecoder.decodeFloat(forKey: SerializationKeys.avgNumRobotsLifted)
    self.avgTimeToOwnAllianceSwitchAuto = aDecoder.decodeFloat(forKey: SerializationKeys.avgTimeToOwnAllianceSwitchAuto)
    self.avgTimeToOwnScaleAuto = aDecoder.decodeFloat(forKey: SerializationKeys.avgTimeToOwnScaleAuto)
    self.parkPercentage = aDecoder.decodeFloat(forKey: SerializationKeys.parkPercentage)
    self.percentSuccessOppositeSwitchSideAuto = aDecoder.decodeFloat(forKey: SerializationKeys.percentSuccessOppositeSwitchSideAuto)
    self.allianceSwitchSuccessPercentageAuto = aDecoder.decodeFloat(forKey: SerializationKeys.percentSuccessOppositeSwitchSideAuto)
    self.canPlaceHighLayerCube = aDecoder.decodeBool(forKey: SerializationKeys.canPlaceHighLayerCube)
    self.pitAvgDriveTime = aDecoder.decodeFloat(forKey: SerializationKeys.pitAvgDriveTime)
    self.pitAvgRampTime = aDecoder.decodeFloat(forKey: SerializationKeys.pitAvgRampTime)
    self.avgTotalCubesPlaced = aDecoder.decodeFloat(forKey: SerializationKeys.avgTotalCubesPlaced)
    self.avgSwitchOwnership = aDecoder.decodeInteger(forKey: SerializationKeys.avgSwitchOwnership)
    self.avgScaleCubesBy100s = aDecoder.decodeFloat(forKey: SerializationKeys.avgScaleCubesBy100s)
    self.avgScaleCubesBy110s = aDecoder.decodeFloat(forKey: SerializationKeys.avgScaleCubesBy110s)
    self.avgAllVaultTime = aDecoder.decodeFloat(forKey: SerializationKeys.avgScaleCubesBy100s) 
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(avgNumCubesFumbledAuto, forKey: SerializationKeys.avgNumCubesFumbledAuto)
    aCoder.encode(avgNumHumanPortalIntakeTele, forKey: SerializationKeys.avgNumHumanPortalIntakeTele)
    aCoder.encode(switchFailPercentageAuto, forKey: SerializationKeys.switchFailPercentageAuto)
    aCoder.encode(avgNumElevatedPyramidIntakeAuto, forKey: SerializationKeys.avgNumElevatedPyramidIntakeAuto)
    aCoder.encode(avgAllianceSwitchCubesTele, forKey: SerializationKeys.avgAllianceSwitchCubesTele)
    aCoder.encode(avgAllianceSwitchCubesAuto, forKey: SerializationKeys.avgAllianceSwitchCubesAuto)
    aCoder.encode(avgOpponentSwitchCubesTele, forKey: SerializationKeys.avgOpponentSwitchCubesTele)
    aCoder.encode(avgOpponentSwitchCubesAuto, forKey: SerializationKeys.avgOpponentSwitchCubesAuto)
    aCoder.encode(avgAgility, forKey: SerializationKeys.avgAgility)
    aCoder.encode(secondPickAbility, forKey: SerializationKeys.secondPickAbility)
    aCoder.encode(avgNumGoodDecisions, forKey: SerializationKeys.avgNumGoodDecisions)
    aCoder.encode(avgNumAlliancePlatformIntakeAuto, forKey: SerializationKeys.avgNumAlliancePlatformIntakeAuto)
    aCoder.encode(avgNumReturnIntakeTele, forKey: SerializationKeys.avgNumReturnIntakeTele)
    aCoder.encode(avgNumOpponentPlatformIntakeTele, forKey: SerializationKeys.avgNumOpponentPlatformIntakeTele)
    aCoder.encode(avgNumBadDecisions, forKey: SerializationKeys.avgNumBadDecisions)
    aCoder.encode(avgClimbTime, forKey: SerializationKeys.avgClimbTime)
    aCoder.encode(predictedClimb, forKey: SerializationKeys.predictedClimb)
    aCoder.encode(avgDrivingAbility, forKey: SerializationKeys.avgDrivingAbility)
    aCoder.encode(avgNumExchangeInputTele, forKey: SerializationKeys.avgNumExchangeInputTele)
    aCoder.encode(avgDefense, forKey: SerializationKeys.avgDefense)
    aCoder.encode(avgCubesPlacedInScaleAuto, forKey: SerializationKeys.avgCubesPlacedInScaleAuto)
    aCoder.encode(disabledPercentage, forKey: SerializationKeys.disabledPercentage)
    aCoder.encode(predictedNumScaleCubesAuto, forKey: SerializationKeys.predictedNumScaleCubesAuto)
    aCoder.encode(scaleFailPercentageTele, forKey: SerializationKeys.scaleFailPercentageTele)
    aCoder.encode(incapacitatedPercentage, forKey: SerializationKeys.incapacitatedPercentage)
    aCoder.encode(predictedNumAllianceSwitchCubesAuto, forKey: SerializationKeys.predictedNumAllianceSwitchCubesAuto)
    aCoder.encode(autoRunPercentage, forKey: SerializationKeys.autoRunPercentage)
    aCoder.encode(avgNumCubesFumbledTele, forKey: SerializationKeys.avgNumCubesFumbledTele)
    aCoder.encode(scaleFailPercentageAuto, forKey: SerializationKeys.scaleFailPercentageAuto)
    aCoder.encode(avgCubesSpilledAuto, forKey: SerializationKeys.avgCubesSpilledAuto)
    aCoder.encode(avgCubesSpilledTele, forKey: SerializationKeys.avgCubesSpilledTele)
    aCoder.encode(switchFailPercentageTele, forKey: SerializationKeys.switchFailPercentageTele)
    aCoder.encode(avgNumAlliancePlatformIntakeTele, forKey: SerializationKeys.avgNumAlliancePlatformIntakeTele)
    aCoder.encode(avgNumGroundIntakeTele, forKey: SerializationKeys.avgNumGroundIntakeTele)
    aCoder.encode(climbPercentage, forKey: SerializationKeys.climbPercentage)
    aCoder.encode(avgNumOpponentPlatformIntakeAuto, forKey: SerializationKeys.avgNumOpponentPlatformIntakeAuto)
    aCoder.encode(canScoreBothSwitchSidesAuto, forKey: SerializationKeys.canScoreBothSwitchSidesAuto)
    aCoder.encode(avgNumGroundPortalIntakeTele, forKey: SerializationKeys.avgNumGroundPortalIntakeTele)
    aCoder.encode(avgNumElevatedPyramidIntakeTele, forKey: SerializationKeys.avgNumElevatedPyramidIntakeTele)
    aCoder.encode(avgNumGroundPyramidIntakeTele, forKey: SerializationKeys.avgNumGroundPyramidIntakeTele)
    aCoder.encode(numMatchesPlayed, forKey: SerializationKeys.numMatchesPlayed)
    aCoder.encode(avgNumGroundPyramidIntakeAuto, forKey: SerializationKeys.avgNumGroundPyramidIntakeAuto)
    aCoder.encode(avgSpeed, forKey: SerializationKeys.avgSpeed)
    aCoder.encode(firstPickAbility, forKey: SerializationKeys.firstPickAbility)
    aCoder.encode(actualSeed, forKey: SerializationKeys.actualSeed)
    aCoder.encode(predictedSeed, forKey: SerializationKeys.predictedSeed)
    aCoder.encode(actualNumRPs, forKey: SerializationKeys.actualNumRPs)
    aCoder.encode(predictedNumRPs, forKey: SerializationKeys.predictedNumRPs)
    aCoder.encode(dysfunctionalPercentage, forKey: SerializationKeys.dysfunctionalPercentage)
    aCoder.encode(avgCubesPlacedInScaleTele, forKey: SerializationKeys.avgCubesPlacedInScaleTele)
    aCoder.encode(totalNumGoodDecisions, forKey: SerializationKeys.totalNumGoodDecisions)
    aCoder.encode(totalNumBadDecisions, forKey: SerializationKeys.totalNumBadDecisions)
    aCoder.encode(avgNumRobotsLifted, forKey: SerializationKeys.avgNumRobotsLifted)
    aCoder.encode(avgTimeToOwnAllianceSwitchAuto, forKey: SerializationKeys.avgTimeToOwnAllianceSwitchAuto)
    aCoder.encode(avgTimeToOwnScaleAuto, forKey: SerializationKeys.avgTimeToOwnScaleAuto)
    aCoder.encode(parkPercentage, forKey: SerializationKeys.parkPercentage)
    aCoder.encode(percentSuccessOppositeSwitchSideAuto, forKey: SerializationKeys.percentSuccessOppositeSwitchSideAuto)
    aCoder.encode(allianceSwitchSuccessPercentageAuto, forKey: SerializationKeys.allianceSwitchSuccessPercentageAuto)
    aCoder.encode(canPlaceHighLayerCube, forKey: SerializationKeys.canPlaceHighLayerCube)
    aCoder.encode(avgTotalCubesPlaced, forKey: SerializationKeys.avgTotalCubesPlaced)
    aCoder.encode(avgSwitchOwnership, forKey: SerializationKeys.avgSwitchOwnership)
    aCoder.encode(avgScaleCubesBy100s, forKey: SerializationKeys.avgScaleCubesBy100s)
    aCoder.encode(avgScaleCubesBy110s, forKey: SerializationKeys.avgScaleCubesBy110s)
    aCoder.encode(avgAllVaultTime, forKey: SerializationKeys.avgAllVaultTime)
  }

}
