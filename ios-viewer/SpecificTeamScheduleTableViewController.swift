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
    
    @objc var teamNumber : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(self.teamNumber)'s Matches"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Star All", style: .plain, target: self, action: #selector(starAll))
    }
    
    override func loadDataArray(_ shouldForce: Bool) -> [Any]! {
        return self.firebaseFetcher.getMatchesForTeamWithNumber(self.teamNumber)
    }
    
    @objc func starAll() {
        let slackId = self.firebaseFetcher.currentMatchManager.slackId
        if slackId != nil {
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
            Database.database().reference().child("SlackProfiles").child(slackId!).child("StarredMatches").setValue(starredMatches)
        
            viewDidLoad()
        } else {
            let ac = UIAlertController(title: "Link Slack", message:"Please link your slack account before you star matches.", preferredStyle:.alert);
            
            ac.addAction(UIAlertAction(title: "Okay", style:.default, handler: { (alert) in
                //nothing
            }))
            
            self.present(ac, animated:true, completion:nil)
        }
    }
}
