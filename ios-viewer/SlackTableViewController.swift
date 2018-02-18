//
//  SlackTableViewController.swift
//  ios-viewer
//
//  Created by Carter Luck on 2/17/18.
//  Copyright © 2018 brytonmoeller. All rights reserved.
//

import UIKit

class SlackTableViewController: UITableViewController {
    
    let firebaseFetcher = AppDelegate.getAppDelegate().firebaseFetcher
    
    var firebase : DatabaseReference = Database.database().reference()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.firebaseFetcher?.slackProfiles.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "slackTableViewCell", for: indexPath) as? SlackTableViewCell
        cell?.displayNameLabel?.text = Array(self.firebaseFetcher!.slackProfiles.values)[indexPath.row].name
        cell?.slackUsernameLabel?.text = Array(self.firebaseFetcher!.slackProfiles.values)[indexPath.row].tag
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let defaults = UserDefaults.standard
        let token = defaults.value(forKey: "NotificationToken")
        var existingSlack : String?
        for i in 0..<Array(self.firebaseFetcher!.slackProfiles.values).count {
            if Array(self.firebaseFetcher!.slackProfiles.values)[i].appToken == token as? String {
                //this is really ugly and it will probably crash...
                existingSlack = (self.firebaseFetcher?.slackProfiles as! NSDictionary).allKeys(for: Array(self.firebaseFetcher!.slackProfiles.values)[i])[0] as? String
            }
        }
        let newSlack = (self.firebaseFetcher?.slackProfiles as! NSDictionary).allKeys(for: Array(self.firebaseFetcher!.slackProfiles.values)[indexPath.row])[0] as? String
        if existingSlack == nil {
            firebase.child("SlackProfiles").child(newSlack!).child("appToken").setValue(token)
        } else {
            firebase.child("SlackProfiles").child(existingSlack!).child("appToken").setValue(nil)
            firebase.child("SlackProfiles").child(newSlack!).child("appToken").setValue(token)
        }
        self.firebaseFetcher?.getSlackProfiles()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
