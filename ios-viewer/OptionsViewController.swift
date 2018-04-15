//
//  OptionsViewController.swift
//  ios-viewer
//
//  Created by Carter Luck on 4/14/18.
//  Copyright © 2018 brytonmoeller. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController, UITableViewDelegate {
    
    var firebaseFetcher: FirebaseDataFetcher?
    
    @IBOutlet weak var scrollingMatchSwitch: UISwitch!
    @IBOutlet weak var showRPSwitch: UISwitch!
    
    override func viewDidLoad() {
        firebaseFetcher = AppDelegate.getAppDelegate().firebaseFetcher
        if let showRPs = firebaseFetcher?.currentMatchManager.showRP {
            showRPSwitch.setOn(showRPs, animated: false)
        }
        if let scrollMatch = firebaseFetcher?.currentMatchManager.matchDetailsScroll {
            scrollingMatchSwitch.setOn(scrollMatch, animated: false)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? SlackTableViewController {
            //actually need to do nothing
        }
    }

    @IBAction func matchScrollToggle(_ sender: Any) {
        firebaseFetcher?.currentMatchManager.matchDetailsScroll = (sender as! UISwitch).isOn
    }
    
    @IBAction func showRPToggled(_ sender: Any) {
        firebaseFetcher?.currentMatchManager.showRP = (sender as! UISwitch).isOn
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
