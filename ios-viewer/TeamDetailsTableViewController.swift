//
//  TeamDetailsTableViewController.swift
//  scout-viewer-2016-iOS
//
//  Created by Citrus Circuits on 2/18/15.
//  Copyright (c) 2016 Citrus Circuits. All rights reserved.
//

import UIKit
import MWPhotoBrowser
import SDWebImage
import Haneke

//TableViewDataSource/Delegate allows vc to contain a table view/pass in info.
class TeamDetailsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MWPhotoBrowserDelegate, UIDocumentInteractionControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {
    
    var firebaseFetcher = AppDelegate.getAppDelegate().firebaseFetcher
    
    //setup visuals
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var teamNumberLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamSelectedImageView: UIImageView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var seed: UILabel!
    @IBOutlet weak var predictedSeed: UILabel!
    
    @objc var team: Team? = nil {
        didSet {
            num = self.team?.number
            updateTitleAndTopInfo()
            reload()
        }
    }
    
    var num: Int? = nil
    var showMinimalistTeamDetails = false
    var shareController: UIDocumentInteractionController!
    var photoBrowser = MWPhotoBrowser()
    var photos: [MWPhoto] = []
    
    func reload() {
        if team != nil {
            if team?.number != nil {
                tableView?.reloadData()
                self.updateTitleAndTopInfo()
                
                self.reloadImage()
            }
        }
        
    }
    
    //sets selectedImage
    func reloadImage() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            //if team exists, if imageView exists
            if let team = self.team,
                let imageView = self.teamSelectedImageView {
                    //if selected image name exists
                    if team.pitSelectedImage != nil {
                        //check the cache to see if the image is saved
                        self.firebaseFetcher?.getImageForTeam((self.team?.number)!, fetchedCallback: { (image) -> () in
                            DispatchQueue.main.async(execute: { () -> Void in
                                //set the selected image
                                imageView.image = image
                                self.resetTableViewHeight()
                            })
                            }, couldNotFetch: {
                                DispatchQueue.main.async(execute: { () -> Void in
                                    //team has images
                                    if team.pitAllImageURLs != nil {
                                        //team has selected image
                                        if team.pitSelectedImage != nil && team.pitSelectedImage != "" {
                                            //get url
                                            let url = URL(string: (Array(Array(team.pitAllImageURLs!)).filter { $0.contains((team.pitSelectedImage!).replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "+", with: "%2B")) } )[0])!
                                            //set imageview
                                            imageView.hnk_setImageFromURL(url, failure: { _ in
                                                print("<reloadImage()> Failed to load image")
                                            }, success: { _ in
                                                print("<reloadImage()> Loaded image, reseting height...")
                                                self.resetTableViewHeight()
                                            })
                                            
                                        }
                                    }
                                })
                        })
                    }
                    let noRobotPhoto = UIImage(named: "SorryNoRobotPhoto")
                    //if team has urls
                    if let urls = self.team?.pitAllImageURLs {
                        //iterate thru urls
                        for url in urls {
                            //if not all photos are downloaded
                            if self.photos.count < self.team!.pitAllImageURLs!.count {
                                //add this photo
                                self.photos.append(MWPhoto(url: URL(string: url)))
                            }
                        }
                    }
                //if there's a selected image
                if self.team?.pitSelectedImage != nil && self.team?.pitSelectedImage != "string" {
                    //if photos are downloaded and image view is not the same as the image for the url
                    if self.teamSelectedImageView.image != MWPhoto(url: URL(string: (Array(Array(team.pitAllImageURLs!)).filter { $0.contains((team.pitSelectedImage!).replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "+", with: "%2B")) } )[0])!) && self.photos.count > 0 {
                        //if photos are downloaded and the first one is not a no robot photo and it's height is greater than 0
                        if self.photos.count > 0 && self.photos[0].underlyingImage != noRobotPhoto && (self.photos[0].underlyingImage ?? UIImage()).size.height > 0 {
                            DispatchQueue.main.async(execute: { () -> Void in
                                //selected image is the first picture
                                let selImage = MWPhoto(url: URL(string: (Array(Array(team.pitAllImageURLs!)).filter { $0.contains((team.pitSelectedImage!).replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "+", with: "%2B")) } )[0])!)
                                selImage?.loadUnderlyingImageAndNotify()
                                self.teamSelectedImageView.image = selImage?.underlyingImage
                                self.resetTableViewHeight()
                               

                            })
                            
                        }
                        self.resetTableViewHeight()
                    }
                }
            }
        }
        self.resetTableViewHeight()
    }
    
    //reset the height of the table so info doesn't go off
    func resetTableViewHeight() {
        DispatchQueue.main.async(execute: { () -> Void in
            // set height constraint as equal to the size of the content
            self.tableViewHeightConstraint?.constant = (self.tableView.contentSize.height)
            //if scrollview and tableview exist
            if self.scrollView != nil && self.tableView != nil {
                //scrollview height is set correctly
                self.scrollView.contentSize.height = self.tableViewHeightConstraint.constant + self.tableView.frame.origin.y
                self.scrollView.setNeedsDisplay()
                self.tableView.setNeedsDisplay()
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reload()
        NotificationCenter.default.addObserver(self, selector: #selector(TeamDetailsTableViewController.reloadTableView(_:)), name:NSNotification.Name(rawValue: "updateLeftTable"), object:nil)
        
       //set up the tableView
        tableView.register(UINib(nibName: "MultiCellTableViewCell", bundle: nil), forCellReuseIdentifier: "MultiCellTableViewCell")
        tableView.delegate = self
        
        self.navigationController?.delegate = self
        self.photoBrowser.delegate = self
        self.scrollView.delegate = self
        
        //array of all photos
        photos = []
        
        //longpress recognizer
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(TeamDetailsTableViewController.rankingDetailsSegue(_:)))
        self.view.addGestureRecognizer(longPress)
        let tap = UITapGestureRecognizer(target: self, action: #selector(TeamDetailsTableViewController.didTapImage(_:)))
        self.teamSelectedImageView.addGestureRecognizer(tap)
        
        //constraints
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44.0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.reload()
        reloadImage()

    }
    
    
    
    //Not used in 2017
    func didLongPressForMoreDetail(_ recognizer: UIGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.recognized {
            self.showMinimalistTeamDetails = !self.showMinimalistTeamDetails
            self.reload()
            self.teamNumberLabel.textColor = UIColor.black
        } else if recognizer.state == UIGestureRecognizerState.began {
            self.teamNumberLabel.textColor = UIColor.green
        } 
    }
    
    //Image is tapped
    @objc func didTapImage(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.recognized {
            //navigate to image browser
            let nav = UINavigationController(rootViewController: self.photoBrowser)
            nav.delegate = self
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.delegate = nil
        super.viewWillDisappear(animated)
    }
    
    @IBAction func exportTeamPDFs(_ sender: UIBarButtonItem) {
        
    }
    
    //set title of section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return team == nil ? nil : Utils.teamDetailsKeys.keySetNames(self.showMinimalistTeamDetails)[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return team == nil ? 1 : Utils.teamDetailsKeys.keySetNames(self.showMinimalistTeamDetails).count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Utils.teamDetailsKeys.keySetNames(self.showMinimalistTeamDetails)[section] != "super" {
            return team == nil ? 1 : Utils.teamDetailsKeys.keySets(self.showMinimalistTeamDetails)[section].count
        } else {
            return team == nil ? 1 : Utils.teamDetailsKeys.keySets(self.showMinimalistTeamDetails)[section].count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get cell
        var cell = UITableViewCell()
        //if team exists
        if team != nil {
            //if team is not real (team number)
            if team!.number == -1 {
                //no team number
                cell = tableView.dequeueReusableCell(withIdentifier: "TeamInMatchDetailStringCell", for: indexPath)
                cell.textLabel?.text = "No team yet..."
                cell.accessoryType = UITableViewCellAccessoryType.none
                return cell
            }
            //set datakey to the appropriate key
            let dataKey: String = Utils.teamDetailsKeys.keySets(self.showMinimalistTeamDetails)[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
            
            //NOTE: This is if NOT a default key! Don't go looking thru this thinking it will run if it's a default key, you will waste your time.
            if !Utils.teamDetailsKeys.defaultKeys.contains(dataKey) { //Default keys are currently just 'matchDatas' and 'TeamInMatchDatas'... if NOT a default key
                var dataPoint = AnyObject?.init(nilLiteral: ())
                var secondDataPoint = AnyObject?.init(nilLiteral: ())
                if dataKey.contains("calculatedData") {
                    dataPoint = team!.value(forKeyPath: dataKey) as AnyObject
                } else {
                    dataPoint = (team!.dictionaryRepresentation() as NSDictionary).object(forKey: dataKey) as AnyObject
                }
                
                if secondDataPoint as? String == "" {
                    secondDataPoint = nil
                }
                
                //notes
                if Utils.teamDetailsKeys.TIMDLongTextCells.contains(dataKey) {
                    //get cell
                    let notesCell: ResizableNotesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TeamInMatchDetailStringCell", for: indexPath) as! ResizableNotesTableViewCell
                    
                    //set title
                    notesCell.titleLabel?.text = Utils.humanReadableNames[dataKey]
                    
                    //get and sort timds by match num
                    let TIMDs = firebaseFetcher?.getTIMDataForTeam(self.team!).sorted { $0.matchNumber! < $1.matchNumber! }
                    var datas = [String]()
                    //iterate thru timds
                    for TIMD in TIMDs! {
                        //navigate to key
                        if let data = TIMD.value(forKey: dataKey) {
                            //add "Q##: Notes"
                            let dataString = "Q\(TIMD.matchNumber!): \(data)"
                            datas.append(dataString)
                        }
                    }
                    //consolidate into a single string file like so:
                    /*
                     Q#: Notes
                     Q#: Notes
                     Q#: Notes
                     */
                    notesCell.notesLabel.text = datas.reduce(String()) { previous, new in "\(previous)\n\(new)" }
                    //notesCell.heightAnchor
                    notesCell.selectionStyle = UITableViewCellSelectionStyle.none
                    cell = notesCell
                    
                } else if Utils.teamDetailsKeys.longTextCells.contains(dataKey) {
                    let notesCell: ResizableNotesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TeamInMatchDetailStringCell", for: indexPath) as! ResizableNotesTableViewCell
                    notesCell.titleLabel?.text = Utils.humanReadableNames[dataKey]
                    notesCell.notesLabel.text = team!.pitSEALsNotes
                    notesCell.selectionStyle = UITableViewCellSelectionStyle.none
                    cell = notesCell
                } else if Utils.teamDetailsKeys.unrankedCells.contains(dataKey) || dataKey.contains("pit") { //pit keys
                    //get cell
                    let unrankedCell: UnrankedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UnrankedCell", for: indexPath) as! UnrankedTableViewCell
                    
                    //titleLabel is the humanReadable version of dataKey
                    unrankedCell.titleLabel.text = Utils.humanReadableNames[dataKey]
                    
                    if "\(String(describing: dataPoint))".isEmpty {
                        unrankedCell.detailLabel.text = ""
                    } else if dataKey == "pitProgrammingLanguage" { //JUST WANNA SAY this sucks
                        unrankedCell.detailLabel!.text! = (team?.pitProgrammingLanguage) ?? ""
                    } else if dataKey == "pitDriveTrain" {
                        unrankedCell.detailLabel!.text! = (team?.pitDriveTrain) ?? ""
                    } else if dataKey == "pitClimberType" {
                        unrankedCell.detailLabel!.text! = (team?.pitClimberType) ?? ""
                    } else if dataKey == "pitWheelDiameter" {
                        unrankedCell.detailLabel!.text! = (team?.pitWheelDiameter) ?? ""
                    } else if dataKey == "pitRobotWidth" {
                        unrankedCell.detailLabel!.text! = String(describing: team!.pitRobotWidth ?? 0)
                    } else if dataKey == "pitRobotLength" {
                        unrankedCell.detailLabel!.text! = String(describing: team!.pitRobotLength ?? 0)
                    } else if Utils.teamDetailsKeys.addCommasBetweenCapitals.contains(dataKey) {
                        unrankedCell.detailLabel.text = "\(insertCommasAndSpacesBetweenCapitalsInString(roundValue(dataPoint!, toDecimalPlaces: 2)))"
                    } else if Utils.teamDetailsKeys.boolValues.contains(dataKey) {
                        unrankedCell.detailLabel.text = "\(boolToBoolString(dataPoint as! Bool))"
                    } else {
                        unrankedCell.detailLabel.text = "\(roundValue(dataPoint!, toDecimalPlaces: 2))"
                    }
                    
                    unrankedCell.selectionStyle = UITableViewCellSelectionStyle.none
                    cell = unrankedCell
                } else {
                    //get cell
                    let multiCell: MultiCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MultiCellTableViewCell", for: indexPath) as! MultiCellTableViewCell
                    
                    //label is humanReadable version of dataKey
                    multiCell.teamLabel!.text = Utils.humanReadableNames[dataKey]
                    
                    if secondDataPoint != nil { //This means that it is a defense crossing (Deprecated)
                        if secondDataPoint as? String != "" && dataPoint as? String != "" {
                            if let ff = dataPoint as? Float {
                                dataPoint = roundValue(ff as AnyObject?, toDecimalPlaces: 1) as AnyObject?? ?? "" as AnyObject?
                            }
                            multiCell.scoreLabel?.text = "A: \(dataPoint!) T: \(secondDataPoint!)"
                        }
                    } else {
                        
                        if Utils.teamDetailsKeys.percentageValues.contains(dataKey) {
                            //value needs to be displayed as a percentage
                            multiCell.scoreLabel!.text = "\(percentageValueOf(dataPoint!))"
                        } else {
                            if dataPoint as? String != "" {
                                 if Utils.teamDetailsKeys.yesNoKeys.contains(dataKey) {
                                    //value needs to be displayed as Yes or No
                                    if dataPoint! as! Bool == true {
                                        multiCell.scoreLabel?.text = "Yes"
                                    } else {
                                        multiCell.scoreLabel?.text = "No"
                                    }
                                } else { // it is neither a yes/no or a +1 key.
                                    multiCell.scoreLabel!.text = "\(roundValue(dataPoint!, toDecimalPlaces: 2))"
                                }
                            } else {
                                multiCell.scoreLabel?.text = ""
                            }
                        }
                        if multiCell.teamLabel?.text?.range(of: "Accuracy") != nil || multiCell.teamLabel?.text?.range(of: "Consistency") != nil { //Anything with the words "Accuracy" or "Consistency" should be a percentage
                            multiCell.scoreLabel!.text = percentageValueOf(dataPoint!)
                        }
                        
                    }
                    cell = multiCell
                    multiCell.rankLabel!.text = "\((firebaseFetcher?.rankOfTeam(team!, withCharacteristic: dataKey))! as Int)"
                }
            } else { //is a defaultKey
                let unrankedCell: UnrankedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UnrankedCell", for: indexPath) as! UnrankedTableViewCell
                
                //title is humanReadable dataKey
                unrankedCell.titleLabel.text = Utils.humanReadableNames[dataKey]
                
                unrankedCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                
                if dataKey == "matchDatas" {
                    let matchesUntilNextMatch : String = firebaseFetcher?.matchesUntilTeamNextMatch((team?.number)!) ?? "NA"
                    
                    //label: "Matches - #  Remaining
                    unrankedCell.titleLabel.text = (unrankedCell.titleLabel.text)! + ": \(Utils.sp(thing: firebaseFetcher?.remainingMatchesForTeam((team?.number)!))) Left - Next in \(matchesUntilNextMatch)"
                }
                cell = unrankedCell
            }
            
            
        } else {
            //get empty cell
            cell = tableView.dequeueReusableCell(withIdentifier: "TeamInMatchDetailStringCell", for: indexPath)
            cell.textLabel?.text = "No team yet..."
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //
    }
    
    /**
     Translates numbers into what it actually means.
     
     - parameter numString: e.g. "0" -> "C++"
     
     - returns: A string with the human readable prog lang name.
     */
    func pitProgrammingLanguageForNumberString(_ numString: String) -> String {
        var translated = ""
        switch numString {
        case "0": translated = "C++"
        case "1": translated = "Java"
        case "2": translated = "Labview"
        case "3": translated = "Other"
        default: break
        }
        return translated

    }
    
    //updates title
    func updateTitleAndTopInfo() {
        if self.teamNameLabel != nil {
            if self.teamNameLabel.text == "" || self.teamNameLabel.text == "Unknown name..." {
                let numText: String
                let nameText: String
                switch (team?.number, team?.name) {
                case (.some(let num), .some(let name)):
                    title = "\(num) - \(name)"
                    numText = "\(num)"
                    nameText = "\(name)"
                case (.some(let num), .none):
                    title = "\(num) - ???"
                    numText = "\(num)"
                    nameText = "Unknown name..."
                case (.none, .some(let name)):
                    title = "??? - \(name)"
                    numText = "????"
                    nameText = "\(name)"
                default:
                    title = "??? - ???"
                    numText = "????"
                    nameText = "Unknown name..."
                }
                
                teamNameLabel?.text = nameText
                teamNumberLabel?.text = numText
            }
            
            
            var seedText = "?"
            var predSeedText = "?"
            if let seed = team?.calculatedData!.actualSeed, seed > 0 {
                seedText = "Seed: \(seed)"
            }
            
            if let predSeed = team?.calculatedData!.predictedSeed, predSeed > 0 {
                predSeedText = "Pred. Seed: \(predSeed)"
            }
            
            
            seed?.text = seedText
            predictedSeed?.text = predSeedText
        }
    }
    
    /**
     Returns the number of photos in a PhotoBrowser.
     
    - parameter photoBrowser: PhotoBrowser you want the function to count.
    */
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(photos.count)
    }
    
    /**
    Initializes the photoBrowser.
     
    - parameter photoBrowser: The photoBrowser you want to initialize.
     
    - parameter photoAt: The index at which the photo you're initializing is located.
     
    - returns: The photo at the index you requested.
    */
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
        if index < UInt(photos.count) {
            return photos[Int(index)]
        }
        return nil;
    }
    
    //preparing to change viewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.teamSelectedImageView.isUserInteractionEnabled = true;
        if segue.identifier == "sortedRankSegue" {
            if let dest = segue.destination as? SortedRankTableViewController {
                dest.keyPath = sender as! String
            }
        } else if segue.identifier == "Photos" {
            let browser = segue.destination as! MWPhotoBrowser;
            
            browser.delegate = self;
            
            browser.displayActionButton = true; // Show action button to allow sharing, copying, etc (defaults to YES)
            browser.displayNavArrows = false; // Whether to display left and right nav arrows on toolbar (defaults to NO)
            browser.displaySelectionButtons = false; // Whether selection buttons are shown on each image (defaults to NO)
            browser.zoomPhotosToFill = true; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
            browser.alwaysShowControls = false; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
            browser.enableGrid = false; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
            
            SDImageCache.shared().maxCacheSize = UInt(20 * 1024 * 1024);
        } else if segue.identifier == "Matches" {
            let matchesForTeamController = segue.destination as! SpecificTeamScheduleTableViewController
            
            //if team exists
            if let teamNum = team?.number {
                //set team number
                matchesForTeamController.teamNumber = teamNum
            }
        } else if segue.identifier == "TIMDs" {
            //Navigate to a vc to pick which match, then to TIMD vc
            let TIMDScheduleForTeamController = segue.destination as! TIMDScheduleViewController
            
            //if team exists
            if let teamNum = team?.number {
                //set team number
                TIMDScheduleForTeamController.teamNumber = teamNum
            }
        } else if segue.identifier == "CTIMDGraph" {
            //this is called for every timd graph, not just ctimds
            let graphViewController = segue.destination as! GraphViewController
            //if team number is not nil
            if let teamNum = team?.number {
                //get indexpath
                let indexPath = sender as! IndexPath
                //if the cell exists
                if let cell = tableView.cellForRow(at: indexPath) as? MultiCellTableViewCell {
                    //set titles
                    graphViewController.graphTitle = "\(cell.teamLabel!.text!)"
                    graphViewController.displayTitle = "\(graphViewController.graphTitle): "
                    //get the key
                    var key = Utils.getKeyForHumanReadableName(graphViewController.graphTitle)
                    
                    //get rid of calculatedData in key
                    key = key?.replacingOccurrences(of: "calculatedData.", with: "")
                    //turn the key from a teamDetailsKey to a TIMD key
                    key = Utils.teamDetailsKeys.teamDetailsToTIMD[key!]
                    
                    var values: [Float]
                    let altMapping : [CGFloat: String]?
                    //if the key is predictedNumRPs
                    if key == "calculatedData.predictedNumRPs" {
                        //do stuff... we don't really use this?
                        (values, altMapping) = (firebaseFetcher!.getMatchDataValuesForTeamForPath(key!, forTeam: team!))
                    } else {
                        //get the values in timds for this key
                        (values, altMapping) = (firebaseFetcher?.getMatchValuesForTeamForPath(key!, forTeam: team!))!
                    }
                    //if the key contains accuracy, it's a percentage graph
                    if key?.range(of: "Accuracy") != nil {
                        graphViewController.isPercentageGraph = true
                    }
                    var nilValueIndecies = [Int]()
                    //iterate thru all timd values
                    for i in 0..<values.count {
                        //if the value is marked as empty, add the value
                        if values[i] == -1111.1 {
                            nilValueIndecies.append(i)
                        }
                    }
                    //iterate thru empty values and remove them
                    for i in nilValueIndecies.reversed() {
                        values.remove(at: i)
                    }
                    //set values
                    graphViewController.values = (values as NSArray).map { CGFloat($0 as! Float) }
                    //set left title
                    graphViewController.subDisplayLeftTitle = "Match: "
                    //set values
                    graphViewController.subValuesLeft = nsNumArrayToIntArray(firebaseFetcher!.matchNumbersForTeamNumber((team?.number)!) as [NSNumber]) as [AnyObject]
                    //iterate thru the values for the subvalues and remove empties
                    for i in nilValueIndecies.reversed() {
                        graphViewController.subValuesLeft.remove(at: i)
                    }
                    //replace with altmapping
                    if altMapping != nil {
                        graphViewController.zeroAndOneReplacementValues = altMapping!
                    }
                    //set title
                    graphViewController.subDisplayRightTitle = "Team: "
                    //set... something
                    graphViewController.subValuesRight = [teamNum as AnyObject,teamNum as AnyObject,teamNum as AnyObject,teamNum as AnyObject,teamNum as AnyObject]
                    
                    
                }
            }
        }
        else if segue.identifier == "TGraph" {
            let graphViewController = segue.destination as! GraphViewController
            
            if (team?.number) != nil {
                let indexPath = sender as! IndexPath
                let cell = tableView.cellForRow(at: indexPath) as! MultiCellTableViewCell
                graphViewController.graphTitle = "\(cell.teamLabel!.text!)"
                graphViewController.displayTitle = "\(graphViewController.graphTitle): "
                //keys that don't graph right: Incap, disabled, baseline, liftoff percentage, defense, agility, all super except driving ability- none of these are CTIMDs, but some normal timds work
                var values: [Float]
                let altMapping : [CGFloat: String]?
                var key = Utils.getKeyForHumanReadableName(graphViewController.graphTitle)
                key = Utils.teamDetailsKeys.teamDetailsToTIMD[key!]
                (values, altMapping) = (firebaseFetcher?.getMatchValuesForTeamForPath(key!, forTeam: team!))!
                graphViewController.values = (values as NSArray).map { CGFloat($0 as! Float) }
            }
        }
    }
    
    /** 
    Converts a boolean value to a string value.
     
    - parameter b: Bool to be converted.
     
    - returns: Yes or No for inputted true or false respectively.
     */
    func boolToBoolString(_ b: Bool) -> String {
        let strings = [false : "No", true : "Yes"]
        return strings[b]!
    }
    
    func setupControllerWithURL(_ fileURL: URL, usingDelegate: UIDocumentInteractionControllerDelegate) -> UIDocumentInteractionController {
        let interactionController = UIDocumentInteractionController(url: fileURL)
        interactionController.delegate = usingDelegate
        
        return interactionController
    }
    
    //Row has been selected, perform segue to appropriate vc
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //if the cell can be an unranked table view cell
        if let cell = tableView.cellForRow(at: indexPath) as? UnrankedTableViewCell {
            //if the title contains Matches
            if cell.titleLabel.text?.range(of: "Matches") != nil {
                //go to matches
                performSegue(withIdentifier: "Matches", sender: nil)
            //if the title contains TIMDs
            } else if cell.titleLabel.text?.range(of: "TIMDs") != nil {
                //go to timds
                performSegue(withIdentifier: "TIMDs", sender: nil)
            }
        //if the cell is a multicelltableviewcell
        } else if let cell = tableView.cellForRow(at: indexPath) as? MultiCellTableViewCell {
            //get the text on the team label
            let cs = cell.teamLabel!.text
            //if there is a key for the human readable name
            if((Utils.getKeyForHumanReadableName(cs!)) != nil) {
                //if it's not a notGraphingValue and it is not a standard deviation, segue into CTIMDGraph. Note: all timd graphs
                if !Utils.teamDetailsKeys.notGraphingValues.contains(cs!) && !cs!.contains("σ") { performSegue(withIdentifier: "CTIMDGraph", sender: indexPath) }
            } else {
                performSegue(withIdentifier: "TGraph", sender: indexPath)
            }
            
        } else if let cell = tableView.cellForRow(at: indexPath) as? ResizableNotesTableViewCell {
            //Notes do not segue anymore
            if cell.textLabel?.text == "Pit Notes" {
                performSegue(withIdentifier: "NotesSegue", sender: indexPath)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @objc func reloadTableView(_ note: Notification) {
        if note.name.rawValue == "updateLeftTable" {
            if let t = note.object as? Team {
                if t.number == team?.number {
                    self.team = t
                    self.reload()
                }
            }
            
        }
    }
    
    //Rankable row has been long-pressed, perform segue
    @objc func rankingDetailsSegue(_ gesture: UIGestureRecognizer) {
        
        if(gesture.state == UIGestureRecognizerState.began) {
            let p = gesture.location(in: self.tableView)
            let indexPath = self.tableView.indexPathForRow(at: p)
            if let index = indexPath {
                if let cell = self.tableView.cellForRow(at: index) as? MultiCellTableViewCell {
                    if cell.teamLabel!.text!.contains("Crossed") == false {
                        performSegue(withIdentifier: "sortedRankSegue", sender: cell.teamLabel!.text)
                    }
                }
            }
        }
    }
}


