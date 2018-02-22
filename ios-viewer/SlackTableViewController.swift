//
//  SlackTableViewController.swift
//  ios-viewer
//
//  Created by Carter Luck on 2/17/18.
//  Copyright © 2018 brytonmoeller. All rights reserved.
//

import UIKit

class SlackTableViewController: ArrayTableViewController {
    
    var firebase : DatabaseReference = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector:#selector(SlackTableViewController.reloadTableView), name:NSNotification.Name(rawValue: "updateLeftTable"), object:nil)
    }
    
    @objc func reloadTableView(_ note: Notification) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.firebaseFetcher?.slackProfiles.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SlackTableViewCell = tableView.dequeueReusableCell(withIdentifier: "slackTableViewCell", for: indexPath) as! SlackTableViewCell
        cell.displayNameLabel.text = Array(self.firebaseFetcher!.slackProfiles.values)[indexPath.row].name
        cell.slackUsernameLabel.text = Array(self.firebaseFetcher!.slackProfiles.values)[indexPath.row].tag
        return cell
    }
    
    override func filteredArray(forSearchText text: String!, inScope scope: Int) -> [Any]! {
        return self.firebaseFetcher?.slackProfiles.filter({ (p) -> Bool in
            if p.value.name?.range(of: text) != nil { return true }
            return false
        })
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
        self.firebaseFetcher?.currentMatchManager.slackId = newSlack
        let preAlert = UIAlertController(title: "Notified in Advance", message: "How many matches in advance do you want to be notified?", preferredStyle: .alert)
        preAlert.addTextField(configurationHandler: { (field) in
            field.keyboardType = .numberPad
        })
        preAlert.addAction(UIAlertAction(title:"Submit",style:.default,handler: { (action) in
            self.firebaseFetcher?.currentMatchManager.preNotify = Int((preAlert.textFields?[0].text)!) ?? 0
            if existingSlack == nil {
                self.firebase.child("slackProfiles").child(newSlack!).child("appToken").setValue(token)
                self.firebase.child("slackProfiles").child(newSlack!).child("notifyInAdvance").setValue(self.firebaseFetcher?.currentMatchManager.preNotify)
            } else {
                self.firebase.child("slackProfiles").child(existingSlack!).child("appToken").setValue(nil)
                self.firebase.child("slackProfiles").child(newSlack!).child("appToken").setValue(token)
                self.firebase.child("slackProfiles").child(newSlack!).child("notifyInAdvance").setValue(self.firebaseFetcher?.currentMatchManager.preNotify)
            }
            self.firebaseFetcher?.getSlackProfiles()
        }))
        self.present(preAlert, animated: true, completion: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
