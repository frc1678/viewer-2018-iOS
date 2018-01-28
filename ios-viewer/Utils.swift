//
//  Utils.swift
//  scout-viewer-2016-iOS
//
//  Created by Citrus Circuits on 2/19/15.
//  Copyright (c) 2016 Citrus Circuits. All rights reserved.
//
import Foundation


/**
 Rounds a value.
 - parameter value: Value to be rounded
 - parameter numDecimalPlaces: How many decimal places it should be rounded to
 */
func roundValue(_ value: AnyObject?, toDecimalPlaces numDecimalPlaces: Int) -> String {
    if let val = value as? NSNumber {
        let f = NumberFormatter()
        f.numberStyle = NumberFormatter.Style.decimal
        f.maximumFractionDigits = numDecimalPlaces
        
        if val == 0 {
            return "0"
        }
        
        return f.string(from: val as NSNumber!)!
    }
    
    return ""
}

/**
 Converts a float value into a percentage.
 - parameter number: Float value
 */
func percentageValueOf(_ number: AnyObject?) -> String {
    if let n = number as? Float {
        return "\(roundValue(NSNumber(value: n * 100), toDecimalPlaces: 1))%"
    }
    
    return ""
}

/**
 Inserts commas and spaces between capitals in a string.
 - parameter string: String to be change
 */
func insertCommasAndSpacesBetweenCapitalsInString(_ string: String) -> String {
    var toReturn = ""
    for char in string.characters {
        if "\(char)".uppercased() == "\(char)" {
            toReturn += ", \(char)"
        } else {
            toReturn.append(char)
        }
    }
    
    for _ in 0...1 {
        toReturn.remove(at: string.startIndex)
    }
    
    return toReturn
}

/**
 Turns an NSNumArray into an Int Array
 - parameter nsNumberArray: NSNumberArray to be converted
 */
func nsNumArrayToIntArray(_ nsNumberArray: [NSNumber]) -> [Int] {
    var values: [Int] = []
    for num in nsNumberArray {
        if let int = Int("\(num)") {
            values.append(int)
        }
    }
    
    return values
}

/**
 A class filled with undoubtably underwhelmingly useful utilities.
 */
@objc class Utils: NSObject {
    static let teamDetailsKeys = TeamDetailsKeys()
    struct TeamDetailsKeys {
        
        let yesNoKeys : [String] = []
        
        let abilityKeys = [
            "calculatedData.firstPickAbility",
            "calculatedData.secondPickAbility",
            "calculatedData.autoAbility",
            "calculatedData.citrusDPR",
            "calculatedData.avgGroundIntakes",
            "calculatedData.avgTorque",
            "calculatedData.avgEvasion",
            "calculatedData.avgSpeed",
            "calculatedData.avgBallControl",
            "calculatedData.avgDefense",
            "calculatedData.actualNumRPs",
            "calculatedData.predictedNumRPs"
        ]
        
        // Add carrying stability into stacking security
        
        /* let superKeys = [
         "calculatedData.avgEvasion",
         "calculatedData.avgDefense"
         ]
         */
        
        /**
         Values that should not be graphed
         */
        let notGraphingValues = [
            "First Pick Ability",
            "Second Pick Ability",
            "Avg. Driving Ability",
            "SW Fail Percentage Tele",
            "SC Fail Percentage Tele",
            "SW Fail Percentage Auto",
            "SC Fail Percentage Auto",
            "Multi-Side Auto",
            "Total # of Good Decisions",
            "Total # of Bad Decisions",
        ]
        
        /** Values that should be displayed as long text cells */
        let TIMDLongTextCells : [String] = [
            "superNotes"
        ]
        
        let longTextCells : [String] = [
            "pitSEALsNotes"
        ]
        
        let unrankedCells = [
            "selectedImageURL",
            "otherUrls"
        ]
        
        /** Values to be displayed as percentages. */
        let percentageValues = [
            "calculatedData.disabledPercentage",
            "calculatedData.dysfunctionalPercentage",
            "calculatedData.incapacitatedPercentage",
            "calculatedData.climbPercentage",
            "calculatedData.scaleFailPercentageAuto",
            "calculatedData.switchFailPercentageAuto",
            "calculatedData.scaleFailPercentageTele",
            "calculatedData.switchFailPercentageTele",
            "calculatedData.autoRunPercentage"
        ]
        
        //let otherNoCalcDataValues = [
        //
        //]
        
        let addCommasBetweenCapitals : [String] = []
        
        let boolValues = [
            "calculatedData.disabledPercentage",
            "calculatedData.incapacitatedPercentage",
            "pitCanCheesecake",
            "calculatedData.canScoreBothSwitchSidesAuto",
            "didMakeAutoRun",
            "crossedAutoZone",
            "didGetDisabled",
            "wasIncapacitated",
            "calculatedData.didClimb",
            "didPark"
        ]
        
        
        let keySetNamesOld = [
            "Information",
            "Ability - High Level",
            "Autonomous",
            "TeleOp",
            "Percentages",
            "Pit Scouting / Robot Design",
            "Additional Info",
            ]
        // MARK: KeySets, TeamDetails keys.
        func keySetNames(_ minimalist : Bool) -> [String] {
            if minimalist {
                return  [
                    "",
                    //"High Level",
                    "Autonomous",
                    "Teleoperated",
                    "Siege",
                    "Status",
                    //superKeys,
                    //pitKeys,
                    //"SEALS"
                ]
            }
            return [
                "Default",
                //"High Level",
                "Status",
                "Autonomous",
                "Teleoperated",
                "End Game",
                "Super Scout",
                "Pit Scout",
                "SEALS"
            ]
            
        }
        
        /** Sections of teamDetails view. */
        func keySets(_ minimalist : Bool) -> [[String]] {
            if minimalist {
                return [
                    defaultKeys,
                    //highLevel,
                    //autoKeysMini,
                    teleKeysMini,
                    siegeKeysMini,
                    statusKeysMini,
                    //superKeys,
                    //pitKeys,
                    //sealKeys
                ]
            }
            return [
                defaultKeys,
                //highLevel,
                statusKeys,
                autoKeys,
                teleKeys,
                endGame,
                superKeys,
                pitKeys,
                sealKeys
            ]
            
        }
        
        /** Segues to schedules, things unrelated to data */
        let defaultKeys = [
            "TeamInMatchDatas",
            "matchDatas"
        ]
        
        let highLevel : [String] = [ //not needed
            /*"calculatedData.firstPickAbility",
             "calculatedData.secondPickAbility",
             "calculatedData.avgKeyShotTime",
             "calculatedData.avgHopperShotTime"*/
        ]
        
        //let autoKeysMini = [
        
        //]
        /** Keys relating to autonomous to be displayed on teamDetails. */
        let autoKeys = [
        //Some stuff is not needed
            "calculatedData.avgCubesPlacedInScaleAuto",
            "calculatedData.avgAllianceSwitchCubesAuto",
            "calculatedData.canScoreBothSwitchSidesAuto",
            //"didMakeAutoRun",
            "calculatedData.switchFailPercentageAuto",
            "calculatedData.scaleFailPercentageAuto"
        ]
        
        let teleKeysMini : [String] = [
            //"calculatedData.avgHighShotsTele",
            //"calculatedData.sdHighShotsTele",
            //"calculatedData.avgLowShotsTele",
            //"calculatedData.sdLowShotsTele",
            //"calculatedData.avgLowShotsAttemptedTele",
            //"calculatedData.avgHighShotsAttemptedTele",
        ]
        
        /** Keys relating to Teleoperated to be displayed on teamDetails */
        let teleKeys = [
            "calculatedData.avgNumCubesFumbledTele",
            "calculatedData.avgCubesPlacedInScaleTele",
            "calculatedData.avgOpponentSwitchCubesTele",
            "calculatedData.avgAllianceSwitchCubesTele",
            "calculatedData.avgNumExchangeInputTele",
            "calculatedData.avgNumGroundIntakeTele",
            "calculatedData.avgNumHumanPortalIntakeTele",
            "calculatedData.avgNumGroundPortalIntakeTele",
            "calculatedData.switchFailPercentageTele",
            "calculatedData.scaleFailPercentageTele"
        
        ]
        
        /** Dict translating a key for a teamDetails datapoint to the key for the respective TIMD datapoint. Does not include "calculatedData." in the keys. */
        let teamDetailsToTIMD = [
            //status
            "incapacitatedPercentage" : "didGetIncapacitated",
            "disabledPercentage" : "didGetDisabled",
            "dysfunctionalPercentage" : "calculatedData.isDysfunctional",
            //scoring stuff
            "avgCubesPlacedInScaleAuto" : "calculatedData.numScaleSuccessAuto",
            "avgAllianceSwitchCubesAuto" : "calculatedData.numAllianceSwitchSuccessAuto",
            "avgCubesPlacedInScaleTele" : "calculatedData.numScaleSuccessTele",
            "avgAllianceSwitchCubesTele" : "calculatedData.numAllianceSwitchSuccessTele",
            "avgNumCubesFumbledTele" : "numCubesFumbledTele",
            "avgOpponentSwitchCubesTele" : "calculatedData.numOpponentSwitchSuccessTele",
            "avgNumExchangeInputTele" : "numExchangeInput",
            "avgNumGroundIntakeTele" : "numGroundIntakeTele",
            "avgNumHumanPortalIntakeTele" : "numHumanPortalIntakeTele",
            "avgNumGroundPortalIntakeTele" : "numGroundPortalIntakeTele",
            "avgClimbTime" : "calculatedData.climbTime",
            "climbPercentage" : "calculatedData.didClimb",
            //super data
            "avgSpeed" : "rankSpeed",
            "avgAgility" : "rankAgility",
            "avgTorque" : "rankTorque",
            "avgDrivingAbility" : "calculatedData.drivingAbility",
            "avgDefense" : "rankDefense",
            //RScore super data
            "RScoreDrivingAbility" : "calculatedData.drivingAbility",
            "RScoreAgility" : "rankAgility",
            "RScoreDefense" : "rankDefense",
            "RScoreSpeed" : "rankSpeed",
            "RScoreTorque" : "rankTorque",
 
            //Misc
            "actualNumRPs" : "calculatedData.numRPs",
            "numAutoPoints" : "calculatedData.numAutoPoints",
            
            ]
        
        /** Keys relating to the portions of the game that occur in the end (climbing, challenging, etc) */
        let endGame = [
            "calculatedData.climbPercentage",
            "calculatedData.avgClimbTime"
        ]
        
        let siegeKeysMini : [String] = [
            //"calculatedData.liftoffAbility",
            //"calculatedData.sdLiftoffAbility"
        ]
        
        let statusKeysMini = [
            "calculatedData.dysfunctionalPercentage",
            //"calculatedData.disabledPercentage",
            //"calculatedData.incapacitatedPercentage",
        ]
        
        /** Keys relating to the status of a robot to be displayed on teamDetails */
        let statusKeys = [
            "calculatedData.dysfunctionalPercentage",
            "calculatedData.disabledPercentage",
            "calculatedData.incapacitatedPercentage",
        ]
        
        /** Keys relating to the data the pit scout collects to be displayed on teamDetails */
        let pitKeys = [
            "pitDriveTrain",
            "pitClimberType",
            "pitAvailableWeight",
            "pitProgrammingLanguage"
        ]
        
        /** Data collected by SEALS */
        let sealKeys = [
            "pitCanCheesecake",
            "pitSEALsNotes"
        ]
        
        /** Human readable names for CTIMD keys */
        let calculatedTeamInMatchDataHumanReadableKeys = [
            "First Pick Ability",
            "R Score Torque",
            "R Score Evasion",
            "R Score Speed",
            "Number of RPs",
            "Number of Auto Points",
            "R Score Defense",
            "R Score Driving Ability",
            "Citrus DPR",
            "Second Pick Ability",
            "Overall Second Pick Ability",
            "Score Contribution"
        ]
    }
    
    
    static let superKeys = [
        //superNotes- They're in TIMDs, so see TeamDetails for more info
        "superNotes",
        "calculatedData.avgDrivingAbility",
        "calculatedData.avgSpeed",
        "calculatedData.avgAgility",
        "calculatedData.avgDefense",
        "calculatedData.totalNumGoodDecisions",
        "calculatedData.totalNumBadDecisions"
        
        //"calculatedData.avgBallControl",
        //"calculatedData.avgGearControl",
        //"calculatedData.RScoreDrivingAbility"
    ]
    static let statusKeys = ["uploadedData.incapacitated", "uploadedData.disabled"]
    static let miscKeys = ["uploadedData.miscellaneousNotes"]
    
    
    
    // MARK: TIMD keys
    /** Keys relating to the Autonomous period to be displayed in the TIMD view */
    static let TIMDAutoKeys : [String] = [
        "didMakeAutoRun",
        "didCrossAutoZone",
        "numCubesFumbledAuto",
        "calculatedData.numAllianceSwitchCubeSuccessAuto",
        "calculatedData.numScaleSuccessAuto"
    ]
    
    /** Keys relating to the Teleoperated period to be displayed in the TIMD view */
    static let TIMDTeleKeys : [String] = [
        "calculatedData.numAllianceSwitchSuccessTele",
        "calculatedData.numScaleSuccessTele",
        "calculatedData.numOpponentSwitchSuccessTele",
        "numExchangeInput",
        "numGroundIntakeTele",
        "numHumanPortalIntakeTele",
        "climb",
        //"calculatedData.didClimb",
        "didPark"
    ]
    
    /** Keys relating to the status of a robot to be displayed in the TIMD view */
    static let TIMDStatusKeys = [
        "didStartDisabled",
        "didBecomeIncapacitated"
    ]
    
    /** Keys relating to the data Super Scouts collect to be displayed in the TIMD view */
    static let TIMDSuperKeys = [
        "rankSpeed",
        "rankAgility",
        "rankDefense",
        "superNotes",
        "numGoodDecisions",
        "numBadDecisions"
    ]
    
    /** All sections of the TIMD view */
    static let TIMDKeys = [
        TIMDAutoKeys,
        TIMDTeleKeys,
        TIMDStatusKeys,
        TIMDSuperKeys
    ]
    
    /** A dictionary turning TIMD keys into teamDetails keys */
    static let graphTitleSwitch = [
        
        "didBecomeIncapacitated" : "incapacitatedPercentage",
        "didStartDisabled" : "disabledPercentage",
        //"numShotsBlockedTele" : "avgShotsBlocked",
        //"didReachBaselineAuto" : "baselineReachedPercentage",
        //"didLiftoff" : "liftoffPercentage",
        //"calculatedData.liftoffAbility" : "liftoffAbility",
        //"numLowShotsTele" : "avgLowShotsTele",
        //"calculatedData.numHighShotsTele" : "avgHighShotsTele",
        "calculatedData.RScoreSpeed" : "calculatedData.avgSpeed",
        "calculatedData.RScoreEvasion" : "calculatedData.avgEvasion",
        "calculatedData.RScoreTorque" : "calculatedData.avgTorque",
        //"rankBallControl" : "calculatedData.avgBallControl",
    ]
    
    /** Team Details keys? */
    static let teamCalcKeys = [
        "actualSeed",
        //"avgBallControl",
        "avgDefense",
        "avgEvasion",
        "avgGroundIntakes",
        //"avgHighShotsAuto",
        //"avgHighShotsTele",
        //"avgLowShotsAuto",
        //"avgLowShotsTele",
        "avgSpeed",
        "avgTorque",
        "disabledPercentage",
        "dysfunctionalPercentage",
        "firstPickAbility",
        "incapacitatedPercentage",
        "actualNumRPs",
        "predictedNumRPs",
        "predictedSeed",
        "scalePercentage",
        "sdGroundIntakes",
        "sdHighShotsAuto",
        "sdHighShotsTele",
        "sdLowShotsAuto",
        "sdLowShotsTele",
        "secondPickAbility",
        "secondPickAbility",
        //"avgGearsFumbledTele",
        //"avgGearsEjectedTele",
        //"avgGearGroundInakesTele",
        //"avgLoaderIntakesTele",
        //"avgHoppersOpenedTele",
        //"avgHoppersOpenedAuto"
    ]
    
    /** Calculated TIMD keys */
    static let calculatedTeamInMatchDataKeys = [
        "calculatedData.firstPickAbility",
        "calculatedData.numRPs",
        "calculatedData.secondPickAbility",
        "calculatedData.secondPickAbility",
        "calculatedData.scoreContribution",
        //"calculatedData.hoppersOpenedAuto",
        //"calculatedData.hoppersOpenedTele",
        //"calculatedData.liftoffAbility",
        //"calculatedData.numLowShotsAuto",
        //"calculatedData.numHighShotsTele",
        //"calculatedData.numLowShotsTele",
        //"calculatedData.numHighShotsAuto"
    ]
    
    /** A dictionary with datapoints as keys and Human Readable versions as values */
    static let humanReadableNames = [
        "superNotes": "Super Scout Notes",
        "pitSEALsNotes" : "SEALs Notes",
        "calculatedData.actualSeed" : "Seed",
        "calculatedData.avgEvasion" : "Avg. Evasion",
        "calculatedData.avgTorque" : "Avg. Torque",
        "calculatedData.disabledPercentage" : "Disabled Percentage",
        "calculatedData.dysfunctionalPercentage" : "Dysfunctional Percentage",
        "calculatedData.driverAbility" : "Driver Ability",
        "calculatedData.firstPickAbility" : "First Pick Ability",
        "calculatedData.incapacitatedPercentage" : "Incapacitated Percentage",
        "calculatedData.numRPs" : "Number of RPs",
        "calculatedData.actualNumRPs": "# of RPs",
        "calculatedData.predictedNumRPs" : "Predicted # of RPs",
        "calculatedData.predictedSeed" : "Predicted Seed",
        "calculatedData.scalePercentage" : "Scale Percentage",
        "calculatedData.secondPickAbility" : "Second Pick Ability",
        "matchDatas" : "Matches",
        "TeamInMatchDatas" : "TIMDs",
        "pitLowBarCapability": "Low Bar Ability",
        "calculatedData.autoAbility" : "Auto Ability",
        "calculatedData.citrusDPR" : "Citrus DPR",
        "calculatedData.RScoreDrivingAbility": "R Score Driving Ability",
        "calculatedData.drivingAbility": "Driving Ability",
        "pitPotentialLowBarCapability" : "Low Bar Potential",
        "pitHeightOfBallLeavingShooter": "Shot Release Height",
        "pitDriveBaseWidth" : "Drive Base Width",
        "pitDriveBaseLength" : "Drive Base Length",
        "pitBumperHeight" : "Bumper Height",
        "pitPotentialShotBlockerCapability" : "Shot Blocking Potential",
        "pitNotes" : "Pit Notes",
        "pitCheesecakeAbility" : "Cheesecake Ease",
        "pitProgrammingLanguage": "Prog. Lang.",
        "pitAvailableWeight" : "Avail. Weight",
        "pitOrganization" : "Pit Organization",
        "pitDidUseStandardTankDrive" : "Has Normal Tank Drivetrain",
        "pitCanCheesecake": "Cheesecakable",
        "rankDefense" : "Defense Rank",
        "rankAgility" : "Agility Rank",
        "rankSpeed" : "Speed Rank",
        "rankTorque" : "Torque Rank",
        "didBecomeIncapacitated" : "Was Incap.",
        "didStartDisabled" : "Was Disabled",
        "calculatedData.RScoreSpeed" : "R Score Speed",
        "calculatedData.RScoreEvasion" : "R Score Evasion",
        "calculatedData.RScoreTorque" : "R Score Torque",
        "calculatedData.RScoreAgility": "R Score Agility",
        "calculatedData.RScoreDefense": "R Score Defense",
        "calculatedData.RScoreGearControl": "R Score Gear Control",
        "calculatedData.avgAgility": "Avg. Agility",
        "calculatedData.avgDefense": "Avg. Defense",
        "calculatedData.avgSpeed": "Avg. Speed",
        "calculatedData.avgDrivingAbility": "Avg. Driving Ability",
        "pitNumberOfWheels": "Number of Wheels",
        "didPotentiallyConflictingAuto" : "Did a Potentially Conflicting Auto",
        "pitDriveTrain" : "Drive Train",
        "calculatedData.avgNumGroundPyramidIntakeAuto" : "Avg. Ground PY Intakes Auto",
        "calculatedData.avgNumGroundPortalIntakeAuto" : "Avg. Ground PO Intakes Auto",
        "calculatedData.avgNumElevatedPyramidIntakeAuto" : "Avg. Elevated PY Intakes Auto",
        "calculatedData.avgNumCubesFumbledAuto" : "Avg. Cubes Fumbled in Auto",
        "calculatedData.avgNumAlliancePlatformIntakeAuto" : "Avg. PZ Intakes Auto",
        "calculatedData.avgNumCubesSpilledAuto" : "Avg. Cubes Spilled Auto",
        "calculatedData.avgCubesPlacedInScaleAuto" : "Avg. Cubes in SC Auto",
        "calculatedData.avgAllianceSwitchCubesAuto" : "Avg. Cubes in SW Auto",
        "calculatedData.avgNumGroundPyramidIntakeTele" : "Avg. Ground PY Intakes Tele",
        "calculatedData.avgNumGroundPortalIntakeTele" : "Avg. Ground PO Intakes Tele",
        "calculatedData.avgNumElevatedPyramidIntakeTele" : "Avg. Elevated PY Intakes Tele",
        "calculatedData.avgNumCubesFumbledTele" : "Avg. Cubes Fumbled in Tele",
        "calculatedData.avgNumAlliancePlatformIntakeTele" : "Avg. PZ Intakes Tele",
        "calculatedData.avgNumCubesSpilledTele" : "Avg. Cubes Spilled Tele",
        "calculatedData.avgCubesPlacedInScaleTele" : "Avg. Cubes in SC Tele",
        "calculatedData.avgAllianceSwitchCubesTele" : "Avg. Cubes in SW Tele",
        "calculatedData.avgNumExchangeInputTele" : "Avg. EX Input Tele",
        "calculatedData.autoRunPercentage" : "Auto Run Percentage",
        "calculatedData.totalNumGoodDecisions" : "Total # of Good Decisions",
        "calculatedData.totalNumBadDecisions" : "Total # of Bad Decisions",
        "calculatedData.avgClimbTime" : "Avg. Climb Time",
        "calculatedData.avgOpponentSwitchCubesTele" : "Avg. Cubes in SWO Tele",
        "calculatedData.avgNumGroundIntakeTele" : "Avg. Ground Intakes Tele",
        "calculatedData.avgNumPortalIntakeTele" : "Avg. PO Intakes Tele",
        "calculatedData.switchFailPercentageTele" : "SW Fail Percentage Tele",
        "calculatedData.scaleFailPercentageTele" : "SC Fail Percentage Tele",
        "calculatedData.canScoreBothSwitchSidesAuto" : "Multi-Side Auto",
        "didMakeAutoRun" : "Did Make Auto Run",
        "calculatedData.switchFailPercentageAuto" : "SW Fail Percentage Auto",
        "calculatedData.scaleFailPercentageAuto" : "SC Fail Percentage Auto",
        "calculatedData.avgNumHumanPortalIntakeTele" : "Avg. Human PO Intakes Tele",
        "calculatedData.climbPercentage" : "Climb Percentage",
        "pitClimberType" : "Climber Type",
        "calculatedData.avgCubesSpilledTele" : "Avg. Cubes Spilled Tele",
        "didPark" : "Parked",
        "climb" : "Climb",
        "numHumanPortalIntakeTele" : "Human Portal Intakes Tele",
        "numGoodDecisions" : "Good Decisions",
        "numBadDecisions" : "Bad Decisions",
        "numGroundIntakeTele" : "Ground Intakes Tele",
        "numExchangeInput" : "EX Inputs",
        "numCubesFumbledAuto" : "Cubes Fumbled Auto",
        "didCrossAutoZone" : "Crossed Auto Zone",
        //"didMakeAutoRun" : "Made Auto Run",
        "calculatedData.numAllianceSwitchCubeSuccessAuto" : "Successful SW Cubes Auto",
        "calculatedData.numScaleSuccessAuto" : "Successful SC Cubes Auto",
        "calculatedData.numAllianceSwitchSuccessTele" : "Successful SW Cubes Tele",
        "calculatedData.numScaleSuccessTele" : "Successful SC Cubes Tele",
        "calculatedData.numOpponentSwitchSuccessTele" : "Successful SWO Cubes Tele",
        "calculatedData.didClimb" : "Climbed",
    ]
    
    /**
     Rounds a given float value to a given number of decimal places.
     - parameter value: Input value
     - parameter numDecimalPlaces: Number of decimal places
     */
    class func roundValue(_ value: Float, toDecimalPlaces numDecimalPlaces: Int) -> String {
        let val = value as NSNumber
        let f = NumberFormatter()
        f.numberStyle = NumberFormatter.Style.decimal
        f.maximumFractionDigits = numDecimalPlaces
        
        if val == 0 {
            return "0"
        }
        
        return f.string(from: val)!
    }
    
    /**
     Rounds a given double value to a given number of decimal places.
     - parameter value: Input value
     - parameter toDecimalPlaces: Number of decimal places to round to
     */
    class func roundDoubleValue(_ value: Double, toDecimalPlaces numDecimalPlaces: Int) -> String {
        let val = value as NSNumber
        let f = NumberFormatter()
        f.numberStyle = NumberFormatter.Style.decimal
        f.maximumFractionDigits = numDecimalPlaces
        
        if val == 0 {
            return "0"
        }
        
        return f.string(from: val)!
    }
    
    /** Returns a human readable name for a given key. */
    class func getHumanReadableNameForKey(_ key: String) -> String? {
        return humanReadableNames[key]
    }
    
    /** Returns the key for a human readable name */
    class func findKeyForValue(_ value: String) ->String?
    {
        for (key, stringValue) in humanReadableNames
        {
            if (stringValue == value)
            {
                return key
            }
        }
        
        return nil
    }
    
    /**
     Returns a key for a given Human Readable Name.
     - parameter name: Human Readable Name
     */
    class func getKeyForHumanReadableName(_ name: String) -> String? {
        var computerReadableNames = [String: String]()
        for (key, value) in humanReadableNames {
            computerReadableNames[value] = key
        }
        return computerReadableNames[name]
    }
    
    /** Detects if a given value is null. */
    class func isNull(_ object: AnyObject?) -> Bool {
        if object_getClass(object) == object_getClass(NSNull()) {
            return true
        }
        return false
    }
    
    /** Converts a value to one that is presentable as a string on the screen. It won't have Optional() or anything like that in it. */
    class func sp(thing : Any?) -> String {
        if thing != nil {
            if let s = thing as? String {
                return s
            } else if ((thing as? Int) != nil) || ((thing as? Float) != nil) || ((thing as? Double) != nil) {
                return "\(thing!)"
            } else if let n = thing as? NSNumber {
                return n.stringValue
            } else {
                print("Presentable String Unknown Type")
                return "\(thing)"
            }
        } else {
            return ""
        }
    }
    
    /**Conversion of bool value to string "Yes" or "No".*/
    class func boolToString(b: Bool?) -> String? {
        let stringBool : String? = b?.description ?? nil
        let boolToStringValues = [
            "true" : "Yes",
            "false" : "No"
        ]
        if stringBool != nil {
            let stringReadable = boolToStringValues[stringBool!]
            return (stringReadable)
        }
        return(nil)
    }
    
    /**
     Unwraps a value.
     */
    class func unwrap(any:Any) -> Any {
        
        let mi = Mirror(reflecting: any)
        if mi.displayStyle != .optional {
            return any
        }
        
        if mi.children.count == 0 { return NSNull() }
        let (_, some) = mi.children.first!
        return some
        
    }
    
    /** Gets the human readable name from a key... use humanReadableNames instead */
    class func humanReadableNameFromKey(key: String) -> String {
        let noCalculatedDataKey = key.replacingOccurrences(of: "calculatedData.", with: "").replacingOccurrences(of: "pit", with: "pitScout")
        var indiciesToAddSpaces = [Int]()
        for i in 0..<noCalculatedDataKey.characters.count {
            if i != 0 {
                let currentChar = Array(noCalculatedDataKey.characters)[i]
                let previousChar = Array(noCalculatedDataKey.characters)[i-1]
                if !self.isLowercase(string: String(currentChar)) && self.isLowercase(string: String(previousChar)) {
                    indiciesToAddSpaces.append(i)
                }
            }
        }
        var finalName = noCalculatedDataKey
        indiciesToAddSpaces.sort()
        for i in 0..<indiciesToAddSpaces.count {
            let ind = indiciesToAddSpaces[i] + i //Adding i to ajust for the fact that we are adding characters as we go here
            finalName = finalName.insert(string: " ", ind: ind)
        }
        finalName = String(Array(finalName.characters)[0]).uppercased() + String(finalName.characters.dropFirst())
        return finalName
    }
    
    static func isLowercase(string: String) -> Bool {
        let set = CharacterSet.lowercaseLetters
        
        if let scala = UnicodeScalar(string) {
            return set.contains(scala)
        } else {
            return false
        }
    }
}

extension String {
    func insert(string:String,ind:Int) -> String {
        return  String(self.characters.prefix(ind)) + string + String(self.characters.suffix(self.characters.count-ind))
    }
}

