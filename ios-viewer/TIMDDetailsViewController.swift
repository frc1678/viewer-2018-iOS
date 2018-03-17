//
//  TIMDDetailsViewController.swift
//  ios-viewer
//
//  Created by Carter Luck on 1/16/17.
//  Copyright © 2017 brytonmoeller. All rights reserved.
//

import Foundation
import UIKit
import MWPhotoBrowser
import SDWebImage
import Haneke


class TIMDDetailsViewController: UITableViewController {
    
    //ideally set when segued into from TIMDScheduleView
    var TIMD: TeamInMatchData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let teamNum = TIMD.teamNumber as? Int!, let matchNum = TIMD.matchNumber as? Int! {
            //set title: "# - Q#"
            self.title = "\(TIMD.teamNumber!) - Q\(TIMD.matchNumber!)"
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //return the number of keys in the TIMDs
        return Utils.TIMDKeys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return the number of rows in TIMDKeys section
        return Utils.TIMDKeys[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get cell
        //let lameCell = UITableViewCell()
        /*if Utils.TIMDKeys[indexPath.section][indexPath.row] == "superNotes" {
            let notesCell: ResizableNotesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TeamInMatchDetailStringCell", for: indexPath) as! ResizableNotesTableViewCell
            
            if TIMD.teamNumber != nil && TIMD.matchNumber != nil {
                let key = Utils.TIMDKeys[indexPath.section][indexPath.row]
                if Utils.humanReadableNames.keys.contains(key) {
                    //set label to the HumanReadable version of the key
                    notesCell.titleLabel.text = Utils.humanReadableNames[key]
                }
                
                var value: Any?
                if key.contains("calculatedData") {
                    //go to calculatedData, dictionaryRepresentation, key without calculatedData
                    value = ((TIMD.value(forKeyPath: "calculatedData") as! CalculatedTeamInMatchData).dictionaryRepresentation() as NSDictionary).object(forKey: key.replacingOccurrences(of: "calculatedData.", with: ""))
                } else {
                    value = (TIMD.dictionaryRepresentation() as NSDictionary).object(forKey: key)
                    print("Key: \(key)")
                }
                if value != nil {
                    //set the value label
                    
                    print("Is Value Bool? \(value is Bool)")
                    if value is String {
                        let stringValue = value as! String
                        notesCell.notesLabel.text = stringValue
                    } else if Utils.teamDetailsKeys.boolValues.contains(key) && value is Bool {
                        let boolValue = value as! Bool
                        notesCell.notesLabel.text = Utils.boolToString(b: boolValue)
                    } else if value is Int {
                        let intValue = value as! Int
                        notesCell.notesLabel.text = String(describing: intValue)
                    } else if value is Float {
                        let floatValue = value as! Float
                        notesCell.notesLabel.text = String(describing: floatValue)
                        //So these are all of the stupid types, like 2018's climb, 2017's shottimesforboiler... things that are more complex types but since they're JSON we can't directly cast them. So first we cast them to [[String: NSObject]] (sometimes there's a collection of things).
                    } else {
                        //problems
                        print("AHHH")
                    }
                    
                } else {
                    notesCell.notesLabel.text = "None"
                }
            }
            return notesCell
        } else {*/
            let cell = tableView.dequeueReusableCell(withIdentifier: "TIMDTableViewCell", for: indexPath) as! TIMDTableViewCell
        
            if TIMD.teamNumber != nil && TIMD.matchNumber != nil {
                let key = Utils.TIMDKeys[indexPath.section][indexPath.row]
                if Utils.humanReadableNames.keys.contains(key) {
                    //set label to the HumanReadable version of the key
                    cell.datapointLabel.text = Utils.humanReadableNames[key]
                }
            
                var value: Any?
                if key.contains("calculatedData") {
                    //go to calculatedData, dictionaryRepresentation, key without calculatedData
                    value = ((TIMD.value(forKeyPath: "calculatedData") as! CalculatedTeamInMatchData).dictionaryRepresentation() as NSDictionary).object(forKey: key.replacingOccurrences(of: "calculatedData.", with: ""))
                } else {
                    value = (TIMD.dictionaryRepresentation() as NSDictionary).object(forKey: key)
                    print("Key: \(key)")
                }
                if value != nil {
                    //set the value label
                
                    print("Is Value Bool? \(value is Bool)")
                    if value is String {
                        let stringValue = value as! String
                        cell.valueLabel.text = stringValue
                    } else if Utils.teamDetailsKeys.boolValues.contains(key) && value is Bool {
                        let boolValue = value as! Bool
                        cell.valueLabel.text = Utils.boolToString(b: boolValue)
                    } else if value is Int {
                        let intValue = value as! Int
                        cell.valueLabel.text = String(describing: intValue)
                    } else if value is Float {
                        let floatValue = value as! Float
                        cell.valueLabel.text = String(describing: floatValue)
                    //So these are all of the stupid types, like 2018's climb, 2017's shottimesforboiler... things that are more complex types but since they're JSON we can't directly cast them. So first we cast them to [[String: NSObject]] (sometimes there's a collection of things).
                    } else if let dictValue = value as? [[String: NSObject]] {
                        let climbValue = dictValue[0]
                        if ((climbValue["activeLift"] as? ActiveLift)?.numRobotsLifted)! > 0 {
                            //just set the label at this point
                            cell.valueLabel.text = "Active"
                        } else if (climbValue["assistedLift"] as? AssistedLift)?.didSucceed! == true {
                            cell.valueLabel.text = "Assisted"
                        } else if (climbValue["passiveClimb"] as? PassiveClimb)?.didSucceed! == true {
                            cell.valueLabel.text = "Passive"
                        } else if (climbValue["soloClimb"] as? SoloClimb)?.didSucceed! == true {
                            cell.valueLabel.text = "Solo"
                        } else {
                            cell.valueLabel.text = "Failed"
                        }
                    } else {
                        //problems
                        print("AHHH")
                    }
                
                } else {
                    cell.valueLabel.text = "None"
                }
            }
            return cell
        //}
        //return lameCell
    }
}
