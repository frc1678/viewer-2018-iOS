//
//  ConditionalSecondPickTableViewController.swift
//  scout-viewer-2016-iOS
//
//  Created by Bryton Moeller on 2/23/16.
//  Copyright © 2016 Citrus Circuits. All rights reserved.
//

import UIKit
import Firebase

class OverallSecondPickAbilityViewController: ArrayTableViewController {
    
    var teamNumber  = -1
    var team : Team!
    var inPicklist = false
    var secondPicklist: [Int] = []
    var firebase: DatabaseReference?
    var fbpassword: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector:#selector(OverallSecondPickAbilityViewController.reloadTableView), name:NSNotification.Name(rawValue: "updateLeftTable"), object:nil)
        self.tableView.isEditing = self.inPicklist
        self.fbpassword = firebaseFetcher.picklistPassword
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Picklist", style: .plain, target: self, action: #selector(toggleInPicklist))
        firebase = Database.database().reference()
        if firebaseFetcher.secondPicklist == [] {
            for i in self.firebaseFetcher.getOverallSecondPickList() {
                self.secondPicklist.append(i.number)
            }
        } else {
            self.secondPicklist = firebaseFetcher.secondPicklist
        }
    }
    
    @objc func reloadTableView(_ note: Notification) {
        tableView.reloadData()
    }
    /** Tell the app what to do when you move a row */
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.secondPicklist[sourceIndexPath.row]
        secondPicklist.remove(at: sourceIndexPath.row)
        secondPicklist.insert(movedObject, at: destinationIndexPath.row)
        NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row) \(secondPicklist)")
        firebaseFetcher.secondPicklist = secondPicklist
        self.dataArray = self.loadDataArray(false)
        // To check for correctness enable: self.tableView.reloadData()
    }
    
    //no - at the left side of cells
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    //dont make space for the - at the left side of cells
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //segue when you tap on a team
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "TeamDetails", sender: tableView.cellForRow(at: indexPath))
    }
    
    override func configureCell(_ cell: UITableViewCell!, at path: IndexPath!, forData data: Any!, in tableView: UITableView!) {
        let multiCell = cell as? MultiCellTableViewCell
        let team = data as? Team
        if team!.number != -1 {
            multiCell!.teamLabel!.text = String(describing: team!.number)
        }
        if team!.calculatedData?.secondPickAbility != nil {
            multiCell!.scoreLabel!.text = String(Utils.roundValue(Float(team!.calculatedData!.secondPickAbility), toDecimalPlaces: 2)
            )
        } else {
            multiCell!.scoreLabel!.text = ""
        }
        if self.inPicklist {
            multiCell!.rankLabel!.text = "\(team!.calculatedData?.actualSeed ?? 0)"
        } else {
            multiCell!.rankLabel!.text = "\(self.firebaseFetcher.rankOfTeam(team!, withCharacteristic: "calculatedData.secondPickAbility"))"
        }
    }
   
    
    override func loadDataArray(_ shouldForce: Bool) -> [Any]! {
        //if we aren't in the picklist mode
        if !self.inPicklist {
            //just look at the secondpicklist from fb
            return self.firebaseFetcher.getOverallSecondPickList()
        }
        //use user-generated picklist, and this function makes it super easy to turn it into an array of teams!
        let sortedTeams = firebaseFetcher.getTeamsFromNumbers(secondPicklist)
        return sortedTeams
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? TeamDetailsTableViewController {
            let selectedCell = sender as? MultiCellTableViewCell
            dest.team = firebaseFetcher.getTeam(Int((selectedCell?.teamLabel!.text)!)!)
        }
    }
    
    override func cellIdentifier() -> String! {
        return "MultiCellTableViewCell"
    }
    
    override func filteredArray(forSearchText text: String!, inScope scope: Int) -> [Any]! {
        return self.firebaseFetcher.filteredTeamsForSearchString(text)
    }
    
    @objc func toggleInPicklist() {
        //if we trying to get INTO the picklist
        if !self.inPicklist {
            self.fbpassword = firebaseFetcher.picklistPassword
            if firebaseFetcher.secondPicklist == [] {
                let aSecondPicklist = self.firebaseFetcher.getOverallSecondPickList()
                self.secondPicklist = []
                for i in aSecondPicklist {
                    self.secondPicklist.append(i.number)
                }
            } else {
                self.secondPicklist = firebaseFetcher.secondPicklist
            }
            self.inPicklist = !self.inPicklist
            self.tableView.isEditing = self.inPicklist
            self.dataArray = self.loadDataArray(false)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(self.clearPicklist))
            self.tableView.reloadData()
            self.navigationItem.title = "Offline Picklist"
        } else {
            self.inPicklist = !self.inPicklist
            self.tableView.isEditing = self.inPicklist
            self.dataArray = loadDataArray(false)
            self.navigationItem.leftBarButtonItem = nil
            self.tableView.reloadData()
            self.navigationItem.title = "Second Pick"
        }
    }
    
    @objc func clearPicklist() {
        var tempPicklist : [Int] = []
        for i in self.firebaseFetcher.getOverallSecondPickList() {
            tempPicklist.append(i.number)
        }
        self.firebaseFetcher.secondPicklist = tempPicklist
        self.secondPicklist = tempPicklist
        self.dataArray = loadDataArray(false)
        self.tableView.reloadData()
    }
}
