//
//  SpecificTeamScheduleTableViewController.swift
//  scout-viewer-2016-iOS
//
//  Created by Bryton Moeller on 7/4/16.
//  Copyright © 2016 Citrus Circuits. All rights reserved.
//

import UIKit
import Firebase

class SpecificTeamScheduleTableViewController : ScheduleTableViewController {
    
    var teamNumber : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(self.teamNumber)'s Matches"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Star All", style: .plain, target: self, action: #selector(starAll))
    }
    
    override func loadDataArray(_ shouldForce: Bool) -> [Any]! {
        return self.firebaseFetcher.getMatchesForTeamWithNumber(self.teamNumber)
    }
    
    func starAll() {
        var starredMatches: [String] = firebaseFetcher.currentMatchManager.starredMatchesArray
        var teamMatchNums: [String] = []
        for i in self.dataArray {
            if let j = i as? Match {
                teamMatchNums.append(String(describing: j.number))
            }
        }
        if Set(teamMatchNums).isSubset(of: Set(starredMatches)) {
            var remove : [String] = []
            for j in 0..<starredMatches.count {
                if teamMatchNums.contains(starredMatches[j]){
                    remove.append(starredMatches[j])
                }
            }
            for i in remove {
                starredMatches.remove(at: starredMatches.index(of: i)!)
            }
        } else {
            for i in teamMatchNums {
                if !starredMatches.contains(i) {
                    starredMatches.append(i)
                }
            }
        }
        firebaseFetcher.currentMatchManager.starredMatchesArray = starredMatches
        let defaults : UserDefaults = UserDefaults.standard
        let token = defaults.value(forKey: "NotificationToken")
        Database.database().reference().child("AppTokens").child(token as! String).child("StarredMatches").setValue("")
        for i in starredMatches {
            Database.database().reference().child("AppTokens").child(token as! String).child("StarredMatches").childByAutoId().setValue(Int(i))
        }
        viewDidLoad()
    }
}
