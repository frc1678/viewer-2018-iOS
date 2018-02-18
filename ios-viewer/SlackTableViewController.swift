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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.firebaseFetcher?.slackProfiles.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "slackTableViewCell", for: indexPath) as? SlackTableViewCell
        cell?.displayNameLabel?.text = self.firebaseFetcher?.slackProfiles[indexPath.row].displayName
        cell?.slackUsernameLabel?.text = self.firebaseFetcher?.slackProfiles[indexPath.row].username
        return cell!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
