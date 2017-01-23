//
//  Utils.swift
//  scout-viewer-2016-iOS
//
//  Created by Citrus Circuits on 2/19/15.
//  Copyright (c) 2016 Citrus Circuits. All rights reserved.
//

import Foundation



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

func percentageValueOf(_ number: AnyObject?) -> String {
    if let n = number as? Float {
        return "\(roundValue(NSNumber(value: n * 100), toDecimalPlaces: 1))%"
    }
    
    return ""
}

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

func nsNumArrayToIntArray(_ nsNumberArray: [NSNumber]) -> [Int] {
    var values: [Int] = []
    for num in nsNumberArray {
        if let int = Int("\(num)") {
            values.append(int)
        }
    }
    
    return values
}

@objc class Utils: NSObject {
    static let teamDetailsKeys = TeamDetailsKeys()
    struct TeamDetailsKeys {
        
        let yesNoKeys : [String] = []
        
        let abilityKeys = [
            "calculatedData.firstPickAbility",
            "calculatedData.overallSecondPickAbility",
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
        
        let notGraphingValues = [
            "First Pick Ability",
            "Second Pick Ability",
            "R Score Driving Ability"
        ]
        
        
        let longTextCells : [String] = []
        
        let unrankedCells = [
            "selectedImageURL",
            "otherUrls"
        ]
        
        let percentageValues = [
            "calculatedData.disabledPercentage",
            "calculatedData.disfunctionalPercentage",
            "calculatedData.incapacitatedPercentage",
            "calculatedData.baselineReachedPercentage",
            "calculatedData.liftoffPercentage"
        ]
        
        let otherNoCalcDataValues = [
            "calculatedData.avgLowShotsTele",
            "calculatedData.avgHighShotsTele"
        ]
        
        let addCommasBetweenCapitals : [String] = []
        
        let boolValues = [
            "calculatedData.disabledPercentage",
            "calculatedData.incapacitatedPercentage",
            "pitDidUseStandardTankDrive",
           "pitDidDemonstrateCheesecakePotential"
        ]
        
        
        let keySetNamesOld = [
            "Information",
            "Ability - High Level",
            "Autonomous",
            "Defenses",
            "TeleOp",
            "Percentages",
            "Pit Scouting / Robot Design",
            "Additional Info",
        ]
        
        func keySetNames(_ minimalist : Bool) -> [String] {
            if minimalist {
                return  [
                    "",
                    "High Level",
                    "Autonomous",
                    "Teleoperated",
                    "Siege",
                    "Status",
                    //superKeys,
                    //pitKeys,
                ]
            }
            return [
                "",
                "High Level",
                "Status",
                "Autonomous",
                "Teleoperated",
                "End Game",
                "Super Scout",
                "Pit Scout",
            ]
            
        }
        func keySets(_ minimalist : Bool) -> [[String]] {
            if minimalist {
                return [
                    defaultKeys,
                    highLevel,
                    autoKeysMini,
                    teleKeysMini,
                    siegeKeysMini,
                    statusKeysMini,
                    //superKeys,
                    //pitKeys,
                ]
            }
            return [
                defaultKeys,
                highLevel,
                statusKeys,
                autoKeys,
                teleKeys,
                endGame,
                superKeys,
                pitKeys,
            ]
            
        }
        
        let defaultKeys = [
            "TeamInMatchDatas",
            "matchDatas"
        ]
        
        let highLevel = [
            "calculatedData.firstPickAbility",
            "calculatedData.overallSecondPickAbility",
            "calculatedData.avgKeyShotTime"
        ]
        
        let autoKeysMini = [
            //TODO: Add Avg. Num Shots in 2 ball Auto
            "calculatedData.avgHighShotsAuto",
            "calculatedData.avgLowShotsAuto"
        ]
        
        let autoKeys = [
            //TODO: Add Avg. Num Shots in 2 ball Auto
            
            "calculatedData.avgHighShotsAuto",
            "calculatedData.avgLowShotsAuto",
            "calculatedData.baselineReachedPercentage",
            "calculatedData.avgHoppersOpenedAuto"
        ]
        
        let teleKeysMini = [
            "calculatedData.avgHighShotsTele",
            //"calculatedData.sdHighShotsTele",
            "calculatedData.avgLowShotsTele",
            //"calculatedData.sdLowShotsTele",
            //"calculatedData.avgLowShotsAttemptedTele",
            //"calculatedData.avgHighShotsAttemptedTele",
        ]
        
        let teleKeys = [
            "calculatedData.avgHighShotsTele",
            "calculatedData.sdHighShotsTele",
            "calculatedData.avgLowShotsTele",
            "calculatedData.sdLowShotsTele",
            "calculatedData.avgHoppersOpenedTele",
            "calculatedData.avgGearGroundIntakesTele",
            "calculatedData.avgGearsFumbledTele",
            "calculatedData.avgGearsEjectedTele",
            "calculatedData.avgLoaderIntakesTele",
            "calculatedData.sdGearsPlacedByLiftTele",
            "calculatedData.avgGearsPlacedByLiftTele",
        ]
        
        let endGame = [
            "calculatedData.liftoffPercentage",
            "calculatedData.liftoffAbility"
        ]
        
        let siegeKeysMini = [
            "calculatedData.liftoffAbility",
            "calculatedData.sdLiftoffAbility"
        ]
        
        let statusKeysMini = [
            "calculatedData.disfunctionalPercentage",
            //"calculatedData.disabledPercentage",
            //"calculatedData.incapacitatedPercentage",
        ]
        
        let statusKeys = [
            "calculatedData.disfunctionalPercentage",
            "calculatedData.disabledPercentage",
            "calculatedData.incapacitatedPercentage",
        ]
        
        let pitKeys = [
            "pitDidUseStandardTankDrive",
            "pitDidDemonstrateCheesecakePotential",
            "pitAvailableWeight",
            "pitOrganization",
            "pitProgrammingLanguage"
        ]
        
        let calculatedTeamInMatchDataHumanReadableKeys = [
            "First Pick Ability",
            "R Score Torque",
            "R Score Evasion",
            "R Score Speed",
            "Avg. High Shots in Tele",
            "Number of RPs",
            "Number of Auto Points",
            "R Score Defense",
            "R Score Ball Control",
            "R Score Driving Ability",
            "Citrus DPR",
            "Second Pick Ability",
            "Overall Second Pick Ability",
            "Score Contribution"
        ]
    }
    
    
    static let superKeys = [
        "calculatedData.avgDefense",
        "calculatedData.avgAgility",
        "calculatedData.avgSpeed",
        "calculatedData.avgBallControl"
    ]
    static let statusKeys = ["uploadedData.incapacitated", "uploadedData.disabled"]
    static let miscKeys = ["uploadedData.miscellaneousNotes"]
    
    
    
    
    static let TIMDAutoKeys : [String] = [
        "highShotTimesForBoilerAuto",
        "numHoppersOpenedAuto",
        "gearsPlacedByLiftAuto",
        "didReachBaselineAuto",
        "lowShotTimesForBoilerAuto",
        "didPotentiallyConflictingAuto"
    ]
     
    static let TIMDTeleKeys : [String] = [
        "lowShotTimesForBoilerTele",
        "numGearLoaderIntakesTele",
        "highShotTimesForBoilerTele",
        "numGearGroundIntakesTele",
        "numHoppersOpenedTele",
        "gearsPlacedByLiftTele",
        "didLiftoff"
    ]
     
    static let TIMDStatusKeys = [
        "didStartDisabled",
        "didBecomeIncapacitated"
    ]
    
    static let TIMDSuperKeys = [
        "rankBallControl",
        "rankDefense",
        "rankAgility",
        "rankSpeed",
        "rankTorque"
    ]
    
    static let TIMDKeys = [
        TIMDAutoKeys,
        TIMDTeleKeys,
        TIMDStatusKeys,
        TIMDSuperKeys
    ]
    
    static let graphTitleSwitch = [

        "didBecomeIncapacitated" : "incapacitatedPercentage",
        "didStartDisabled" : "disabledPercentage",
        "numShotsBlockedTele" : "avgShotsBlocked",
        "didReachBaselineAuto" : "baselineReachedPercentage",
        "didLiftoff" : "liftoffPercentage",
        "calculatedData.liftoffAbility" : "liftoffAbility",
        "numLowShotsTele" : "avgLowShotsTele",
        "calculatedData.numHighShotsTele" : "avgHighShotsTele",
        "calculatedData.RScoreSpeed" : "calculatedData.avgSpeed",
        "calculatedData.RScoreEvasion" : "calculatedData.avgEvasion",
        "calculatedData.RScoreTorque" : "calculatedData.avgTorque",
        "rankBallControl" : "calculatedData.avgBallControl",
        ]
    
    static let teamCalcKeys = [
        "actualSeed",
        "avgBallControl",
        "avgDefense",
        "avgEvasion",
        "avgGroundIntakes",
        "avgHighShotsAuto",
        "avgHighShotsTele",
        "avgLowShotsAuto",
        "avgLowShotsTele",
        "avgSpeed",
        "avgTorque",
        "disabledPercentage",
        "disfunctionalPercentage",
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
        "overallSecondPickAbility",
        "secondPickAbility",
        "avgGearsFumbledTele",
        "avgGearsEjectedTele",
        "avgGearGroundInakesTele",
        "avgLoaderIntakesTele",
        "avgHoppersOpenedTele",
        "avgHoppersOpenedAuto"
    ]
    
    static let calculatedTeamInMatchDataKeys = [
        "calculatedData.firstPickAbility",
        "calculatedData.numRPs",
        "calculatedData.secondPickAbility",
        "calculatedData.overallSecondPickAbility",
        "calculatedData.scoreContribution",
        "calculatedData.hoppersOpenedAuto",
        "calculatedData.hoppersOpenedTele",
        "calculatedData.liftoffAbility",
        "calculatedData.numLowShotsAuto",
        "calculatedData.numHighShotsTele",
        "calculatedData.numLowShotsTele",
        "calculatedData.numHighShotsAuto"
    ]
    
    static let humanReadableNames = [
        "calculatedData.actualSeed" : "Seed",
        "calculatedData.avgEvasion" : "Avg. Evasion",
        "calculatedData.avgGroundIntakes" : "Avg. Ground Intakes",
        "calculatedData.avgHighShotsAuto" : "Avg. High Shots",
        "calculatedData.avgHighShotsTele" : "Avg. High Shots",
        "calculatedData.avgLowShotsAuto" : "Avg. Low Shots",
        "calculatedData.avgLowShotsTele" : "Avg. Low Shots",
        "calculatedData.avgShotsBlocked" : "Avg. Shots Blocked",
        "calculatedData.avgTorque" : "Avg. Torque",
        "calculatedData.disabledPercentage" : "Disabled Percentage",
        "calculatedData.disfunctionalPercentage" : "Disfunctional Percentage",
        "calculatedData.driverAbility" : "Driver Ability",
        "calculatedData.firstPickAbility" : "First Pick Ability",
        "calculatedData.incapacitatedPercentage" : "Incapacitated Percentage",
        "calculatedData.numRPs" : "Number of RPs",
        "calculatedData.actualNumRPs": "# of RPs",
        "calculatedData.predictedNumRPs" : "Predicted # of RPs",
        "calculatedData.predictedSeed" : "Predicted Seed",
        "calculatedData.scalePercentage" : "Scale Percentage",
        "calculatedData.avgHighShotsAttemptedTele": "Avg. H Shots Tried",
        //"calculatedData.sdBallsKnockedOffMidlineAuto" : "σ Balls off Midline Auto",
        //"calculatedData.sdFailedDefenseCrossesAuto" : "σ Failed Defenses Auto",
        "calculatedData.baselineReachedPercentage" : "Baseline Reached Percentage",
        "calculatedData.sdGroundIntakes" : "σ Ground Intakes",
        "calculatedData.sdHighShotsAuto" : "σ High Shots",
        "calculatedData.sdHighShotsTele" : "σ High Shots",
        "calculatedData.sdLowShotsAuto" : "σ Low Shots",
        "calculatedData.sdLowShotsTele" : "σ Low Shots",
        "calculatedData.sdShotsBlocked" : "σ Shots Blocked",
        "calculatedData.overallSecondPickAbility" : "Second Pick Ability",
        "matchDatas" : "Matches",
        "TeamInMatchDatas" : "TIMDs",
        "pitLowBarCapability": "Low Bar Ability",
        "calculatedData.autoAbility" : "Auto Ability",
        "calculatedData.citrusDPR" : "Citrus DPR",
        "calculatedData.RScoreDrivingAbility": " R Score Driving Ability",
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
        "pitDidDemonstrateCheesecakePotential": "Can Accommodate Cheesecake",
        "rankBallControl" : "Ball Control Rank",
        "rankDefense" : "Defense Rank",
        "rankAgility" : "Agility Rank",
        "rankSpeed" : "Speed Rank",
        "rankTorque" : "Torque Rank",
        "didScaleTele" : "Did Scale",
        "didBecomeIncapacitated" : "Was Incap.",
        "didStartDisabled" : "Was Disabled",
        "numShotsBlockedTele" : "Num Shots Blocked",
        "calculatedData.numLowShotsTele" : "Num Low Shots Made Tele",
        "calculatedData.numHighShotsTele" : "Num High Shots Made Tele",
        "calculatedData.RScoreSpeed" : "R Score Speed",
        "calculatedData.RScoreEvasion" : "R Score Evasion",
        "calculatedData.RScoreTorque" : "R Score Torque",
        "calculatedData.RScoreAgility": "R Score Agility",
        "calculatedData.RScoreDefense": "R Score Defense",
        "calculatedData.RScoreBallControl": "R Score Ball Control",
        "calculatedData.avgAgility": "Avg. Agility",
        "calculatedData.avgDefense": "Avg. Defense",
        "calculatedData.avgSpeed": "Avg. Speed",
        "calculatedData.avgBallControl": "Avg. Ball Control",
        "calculatedData.avgLowShotsAttemptedTele": "Avg. L Shots Tried",
        "pitNumberOfWheels":"Number of Wheels",
        "calculatedData.liftoffPercentage": "Liftoff Percentage",
        "calculatedData.liftoffAbility": "Liftoff Ability",
        "calculatedData.avgKeyShotTime": "Avg. Key Shooting Time",
        "lowShotTimesForBoilerTele" : "Low Shots Made Tele",
        "numGearLoaderIntakesTele" : "Gears Intaked From Loader Tele",
        "highShotTimesForBoilerTele" : "High Shots Made Tele",
        "numGearGroundIntakesTele" : "Gears Intaked From Ground Tele",
        "hoppersOpenedTele" : "Num Hoppers Opened Tele",
        "gearsPlacedByLiftTele" : "Gears Placed Tele",
        "didLiftoff" : "Did Liftoff",
        "highShotTimesForBoilerAuto" : "High Shots Made Auto",
        "hoppersOpenedAuto" : "Num Hoppers Opened Auto",
        "gearsPlacedByLiftAuto" : "Gears Placed Tele",
        "didReachBaselineAuto" : "Reached Baseline in Auto",
        "lowShotTimesForBoilerAuto" : "Low Shots Made Auto",
        "didPotentiallyConflictingAuto" : "Did a Potentially Conflicting Auto",
        "calculatedData.avgHoppersOpenedTele" : "Avg. Hoppers Opened Tele",
        "calculatedData.avgHoppersOpenedAuto" : "Avg. Hoppers Opened Auto",
        "calculatedData.avgGearGroundIntakesTele" : "Avg. Gears Intaked From Ground Tele",
        "calculatedData.avgGearGroundIntakesAuto" : "Avg. Gears Intaked From Ground Auto",
        "calculatedData.avgGearsFumbledTele" : "Avg. Gears Fumbled Tele",
        "calculatedData.avgGearsFumbledAuto" : "Avg. Gears Fumbled Auto",
        "calculatedData.avgGearsEjectedTele" : "Avg. Gears Ejected Tele",
        "calculatedData.avgGearsEjectedAuto" : "Avg. Gears Ejected Auto",
        "calculatedData.avgLoaderIntakesTele" : "Avg. Loader Intakes Tele",
        "calculatedData.avgLoaderIntakesAuto" : "Avg. Loader Intakes Auto",
        "calculatedData.sdGearsPlacedByLiftTele" : "σ Gears Placed Tele",
        "calculatedData.sdGearsPlacedByLiftAuto" : "σ Gears Placed Auto",
        "calculatedData.avgGearsPlacedByLiftTele" : "Avg. Gears Placed Tele",
        "calculatedData.avgGearsPlacedByLiftAuto" : "Avg. Gears Placed Auto",
        ]
    
    /*
     "calculatedData.avgHighShotsTele",
     "calculatedData.sdHighShotsTele",
     "calculatedData.avgLowShotsTele",
     "calculatedData.sdLowShotsTele",
     "calculatedData.avgHoppersOpenedTele",
     "calculatedData.avgGearGroundIntakesTele",
     "calculatedData.avgGearsFumbledTele",
     "calculatedData.avgGearsEjectedTele",
     "calculatedData.avgLoaderIntakesTele",
     "calculatedData.sdGearsPlacedByLiftTele",
     "calculatedData.avgGearsPlacedByLiftTele",
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
    
    class func getHumanReadableNameForKey(_ key: String) -> String? {
        return humanReadableNames[key]
    }
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
    
    class func getKeyForHumanReadableName(_ name: String) -> String? {
        var computerReadableNames = [String: String]()
        for (key, value) in humanReadableNames {
            computerReadableNames[value] = key
        }
        return computerReadableNames[name]
    }
    class func isNull(_ object: AnyObject?) -> Bool {
        if object_getClass(object) == object_getClass(NSNull()) {
            return true
        }
        return false
    }
    
    /// This is presentable as a string on the screen. It won't have Optional() or anything like that in it.
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
}


