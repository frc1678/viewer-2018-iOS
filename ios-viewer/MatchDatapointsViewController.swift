//
//  MatchDatapointsViewController.swift
//  ios-viewer
//
//  Created by Carter Luck on 5/9/18.
//  Copyright © 2018 brytonmoeller. All rights reserved.
//

import UIKit

class MatchDatapointsViewController: UITableViewController {
   
    //get firebase fetcher
    var firebaseFetcher = AppDelegate.getAppDelegate().firebaseFetcher
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetDatapoints))
    }
    
    @objc func resetDatapoints() {
        self.firebaseFetcher?.currentMatchManager.matchDetailsDatapoints = (self.firebaseFetcher?.currentMatchManager.defaultMatchDetailsDatapoints)!
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Utils.teamDetailsKeys.allTeamKeys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TIMDTableViewCell", for: indexPath) as! TIMDTableViewCell

        cell.datapointLabel.text = Utils.humanReadableNames[Utils.teamDetailsKeys.allTeamKeys[indexPath.row]]
        if (firebaseFetcher?.currentMatchManager.matchDetailsDatapoints.contains(Utils.teamDetailsKeys.allTeamKeys[indexPath.row]))! {
            cell.backgroundColor = UIColor.green
        } else {
            cell.backgroundColor = UIColor.clear
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (firebaseFetcher?.currentMatchManager.matchDetailsDatapoints.contains(Utils.teamDetailsKeys.allTeamKeys[indexPath.row]))! {
            firebaseFetcher?.currentMatchManager.matchDetailsDatapoints.remove(at: (firebaseFetcher?.currentMatchManager.matchDetailsDatapoints.index(of: Utils.teamDetailsKeys.allTeamKeys[indexPath.row]))!)
        } else {
            firebaseFetcher?.currentMatchManager.matchDetailsDatapoints.append(Utils.teamDetailsKeys.allTeamKeys[indexPath.row])
        }
        self.tableView.reloadData()
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
