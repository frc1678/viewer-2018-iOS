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
            self.firebase!.child("SecondPicklist").setValue(self.secondPicklist)
        } else {
            self.secondPicklist = firebaseFetcher.secondPicklist
        }
    }
    
    @objc func reloadTableView(_ note: Notification) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.secondPicklist[sourceIndexPath.row]
        secondPicklist.remove(at: sourceIndexPath.row)
        secondPicklist.insert(movedObject, at: destinationIndexPath.row)
        NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row) \(secondPicklist)")
        firebase?.child("SecondPicklist").setValue(self.secondPicklist)
        // To check for correctness enable: self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
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
        multiCell!.rankLabel!.text = "\(self.firebaseFetcher.rankOfTeam(team!, withCharacteristic: "calculatedData.secondPickAbility"))"
        if inPicklist {
            
        }
    }
   
    
    override func loadDataArray(_ shouldForce: Bool) -> [Any]! {
        if !self.inPicklist {
            return self.firebaseFetcher.getOverallSecondPickList()
        }
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
        if !self.inPicklist {
            let ac = UIAlertController(title: "Password", message: "Please enter the password for access to picklists.", preferredStyle: .alert)
            ac.addTextField()
            
            let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
                let answer = ac.textFields![0].text
                if answer == self.fbpassword {
                    self.inPicklist = !self.inPicklist
                    self.tableView.isEditing = self.inPicklist
                    if !self.inPicklist {
                        self.firebase!.child("SecondPicklist").setValue(self.secondPicklist)
                    }
                    self.dataArray = self.loadDataArray(false)
                    self.tableView.reloadData()
                }
                // do something interesting with "answer" here
            }
            
            ac.addAction(submitAction)
            
            present(ac, animated: true)
        } else {
            self.inPicklist = !self.inPicklist
            self.tableView.isEditing = self.inPicklist
            if !self.inPicklist {
                firebase!.child("SecondPicklist").setValue(secondPicklist)
            }
            self.dataArray = loadDataArray(false)
            self.tableView.reloadData()
        }
    }
}
