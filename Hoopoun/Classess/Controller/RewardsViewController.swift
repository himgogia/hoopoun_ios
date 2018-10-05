//
//  RewardsViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 21/08/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class RewardsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var searchBar: UISearchBar!
    var rewardArray : NSMutableArray! = NSMutableArray()
    var appDelegate : AppDelegate! = nil
    var showHude : Bool = false
    var  loginInfoDictionary : NSMutableDictionary! = nil
    var searchText : NSString = ""
    var selectedOfferId : String = ""
    var storIdString : String = ""

    
    @IBOutlet weak var rewardTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rewardTable.isHidden = true
        self.messageLabel.isHidden = true
        showHude = true
        
        // change search bar text and place holder color
        if let txfSearchField = searchBar.value(forKey: "_searchField") as? UITextField {
            txfSearchField.borderStyle = .none
            txfSearchField.layer.cornerRadius = 5.0
            txfSearchField.layer.masksToBounds = true
            txfSearchField.backgroundColor = .white
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // hide review button
        let window = UIApplication.shared.keyWindow!
        let addReviewButton = window.viewWithTag(2017)
        addReviewButton?.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        self.navigationController?.isNavigationBarHidden = false

        loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
        self.searchBar.text = ""
        
        creatTitleView()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // check guest user
        if appDelegate.userType == kguestUser {
            
            self.messageLabel.isHidden = false
            self.messageLabel.text = "Please Login to see your rewards"
        }
        else{
            
            if (appDelegate.lat == 0 && appDelegate.long == 0 && appDelegate.locality_id == "") {
                
                alertController(controller: self, title: "", message: "Please select city/location to get Rewards", okButtonTitle: "OK", completionHandler: {(index) -> Void in
                })
            }
            else{
                self.getRewardsHistory()
            }
        }
    }
    
    
    
    // MARK:- Set title View
    
    func creatTitleView(){
        
        let titleView = UIView()
        titleView.backgroundColor = UIColor.clear
        titleView.frame =  CGRect (x: 10, y: 0, width: kIphoneWidth-20, height: 40)
        self.navigationItem.titleView = titleView
        
        // profile button
        
        let profileButton = UIButton()
        profileButton.frame = CGRect(x: 5, y: 3, width: 34, height: 34)
        profileButton.backgroundColor = UIColor.clear
        profileButton.addTarget(self, action: #selector(profileButton_clicked), for:UIControlEvents.touchUpInside)
        profileButton.layer.borderWidth = 3.0
        profileButton.layer.borderColor = kDefaultColor.cgColor
        profileButton.layer.cornerRadius = 34/2
        profileButton.layer.masksToBounds = true
        
        // set profile button image
        
        let tempImageView : UIImageView = UIImageView()
        tempImageView.frame = profileButton.frame
        tempImageView.layer.borderWidth = 3.0
        tempImageView.layer.borderColor = kDefaultColor.cgColor
        tempImageView.layer.cornerRadius = 34/2
        tempImageView.layer.masksToBounds = true
        titleView.addSubview(tempImageView)
        
        if (loginInfoDictionary.value(forKey: kimage) != nil && (loginInfoDictionary.value(forKey: kimage) as? String)! != "") {
            let imageName : String = (loginInfoDictionary.value(forKey: kimage) as? String)!
            
            let imageUrl : NSURL = NSURL(string: imageName as String)!
            
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
                
                DispatchQueue.main.async {
                    tempImageView.image = UIImage(data: imageData as Data)
                }
            }

        }
        else{
            tempImageView.image = UIImage(named: "userPlaceHolder")
        }
        
        titleView.addSubview(profileButton)
        
        
        let titleLabel = UILabel()
        
        titleLabel.frame = CGRect(x:70, y: 3, width: kIphoneWidth-140, height: 36)
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.text = "Rewards"
        titleView.addSubview(titleLabel)
        
    }
    
    
    
    
    
    // MARK TableView Deleage ////////////////////////////////////////////
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.rewardArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "cell"
        
        var cell: RewardsCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? RewardsCell
        
        tableView.register(UINib(nibName: "RewardsCell", bundle: nil), forCellReuseIdentifier: identifier)
        cell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? RewardsCell)!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if self.rewardArray.count>0 {
            cell.setCellData(dictionary: self.rewardArray.object(at: indexPath.section) as! NSMutableDictionary)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let dict : NSMutableDictionary =  self.rewardArray.object(at: indexPath.section) as! NSMutableDictionary
        let offetType : String = (dict.value(forKey: kofferTitle) as? String)!
        
        let storeName :String = (dict.value(forKey: kstore_name) as? String)!
        let address = String(format: "%@ %@",storeName,(dict.value(forKey: kLocality) as? String)!)
        
        var cellHeight : CGFloat = 0.0
        let width =  kIphoneWidth - 125
        
        var height  = offetType.height(withConstrainedWidth: width, font: UIFont(name: "SFUIText-Semibold", size: 12)!)
        
        if height > 30 {
            cellHeight = 30
        }
        else {
            cellHeight = CGFloat(height)
        }
        
        
        let addressWidth = kIphoneWidth - 135
        height =  address.height(withConstrainedWidth: addressWidth, font: UIFont(name: "SFUIText-Regular", size: 12)!)
        
        if height > 30 {
            cellHeight += 30
        }
        else {
            cellHeight += CGFloat(height)
        }
        
        return CGFloat(295+cellHeight);
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let appDelegate :AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if appDelegate.userType == kguestUser {
            
            alertController(controller: self, title: "", message: "Please Login first for view offer details", okButtonTitle: "LOGIN", cancelButtonTitle: "CANCEL", completionHandler: {(index) -> Void in
                
                if index == 1 {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let signIn = storyBoard.instantiateViewController(withIdentifier: kSignInStoryBoardID) as? SignInViewController
                    let nav : UINavigationController = UINavigationController(rootViewController: signIn!)
                    appDelegate.window?.rootViewController = nav
                    appDelegate.window?.makeKeyAndVisible()                  }
                
            })
        }
        else{
            self.getOfferDetails(dict: self.rewardArray.object(at: indexPath.section) as! NSMutableDictionary)
        }
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // MARK: get Offer Details
    
    func getRewardsHistory(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        
        var params : NSMutableDictionary = [:]
        
        
        if (appDelegate.lat == 0 && appDelegate.long == 0) {
            
            params = [
                klocality_id : appDelegate.locality_id,
                "user_id" : loginInfoDictionary.value(forKey: kid)!
            ]
        }
        else{
            params = [
                
                klatitude: String(appDelegate.lat),
                klongitude: String(appDelegate.long),
                "user_id" : loginInfoDictionary.value(forKey: kid)!
            ]
        }
        
        print(params)
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"offerrewardsHistory")
        
        // let baseUrl = String(format: "http://hoopoun.com/admin/api/offerrewardsHistory")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: showHude, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    let message : String =  dict[kMessage] as! String
                    
                    if index == "200" {
                        print(dict[kPayload] as Any)
                        self.showHude = false
                        self.rewardArray = (dict[kPayload]) as! NSMutableArray
                        
                        if self.rewardArray.count > 0 {
                            self.rewardTable.isHidden = false
                            self.messageLabel.isHidden = true
                        }
                        else{
                            self.rewardTable.isHidden = true
                            self.messageLabel.isHidden = false
                            self.messageLabel.text = message as? String
                        }
                        
                        self.rewardTable.reloadData()
                        
                    }
                    else
                    {
                        
                        self.rewardTable.isHidden = true
                        self.messageLabel.isHidden = false
                        self.messageLabel.text = message as? String
                        
                        //                        alertController(controller: self, title: "", message:message! as! String, okButtonTitle: "OK", completionHandler: {(index) -> Void in
                        //
                        //                        })
                        
                    }
                }
            }
                
            else {
                
                self.rewardTable.isHidden = true
                self.messageLabel.isHidden = true
                // show alert
            }
            
            
        }
        
    }
    
    
    
    // MARK Button clicked Action
    
    // Set profile image on button and its action
    func profileButton_clicked(sender :UIButton!){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let myProfileViewController = storyBoard.instantiateViewController(withIdentifier: KMyProfileController) as? MyProfileViewController
        
        self.navigationController?.pushViewController(myProfileViewController!, animated: true)
    }
    
    @IBAction func searchButton_clicked(_ sender: Any) {
        
        let searchViewController = self.storyboard?.instantiateViewController(withIdentifier: ksearchStoryBoardID) as? SearchViewController
        self.navigationController?.pushViewController(searchViewController!, animated: true)
    }
    
    
    // MARK: - Search bar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text != "" {
            
            self.searchText = searchBar.text! as NSString
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.searchcardAPI), object: nil)
            self.perform(#selector(self.searchcardAPI), with: nil, afterDelay: 3.0)
        }
        else{
            
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    
    
    // MARK APIs Call
    
    // MARK: get Offer Details
    
    func getOfferDetails( dict: NSMutableDictionary){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let  loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
         storIdString  = (dict.value(forKey: kstoreId) as? String)!
        let storeIds : NSArray = storIdString.components(separatedBy: ",") as NSArray
        
        if storeIds.count > 0 {
            storIdString = storeIds[0] as! String
        }
        else{
            
            storIdString = ""
        }
        
        var params : NSMutableDictionary = [:]
        
        
        if (appDelegate.lat == 0 && appDelegate.long == 0) {
            
            params = [
                klocality_id : appDelegate.locality_id,
                kstore_id : storIdString,
                koffer_id : dict.value(forKey: koffer_id)!,
                "user_id" : loginInfoDictionary.value(forKey: kid)!
            ]
        }
        else{
            params = [
                
                klatitude: String(appDelegate.lat),
                klongitude: String(appDelegate.long),
                kstore_id : storIdString,
                koffer_id : dict.value(forKey: koffer_id)!,
                "user_id" : loginInfoDictionary.value(forKey: kid)!
            ]
        }
        
        selectedOfferId = dict.value(forKey: koffer_id)! as! String

        print(params)
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"offerDetails_New")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                
                DispatchQueue.main.async {
                    print(response![kCode]!)
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        
                        print(dict[kPayload] as Any)
                        
                        let payLoadDictionary = (dict[kPayload]) as! NSMutableDictionary
                        
                        self.performSegue(withIdentifier: kcategorySegmentSegueIdentifier, sender: payLoadDictionary)
                        
                    }
                    else
                    {
                        let message = dict[kMessage]
                        
                        alertController(controller: self, title: "", message:message! as! String, okButtonTitle: "OK", completionHandler: {(index) -> Void in
                            
                        })
                        
                    }
                }
            }
                
            else {
                
                DispatchQueue.main.async {
                    alertController(controller:self, title: "", message:"No Record Found", okButtonTitle: "OK", completionHandler: {(index) -> Void in
                        
                    })
                }
            }
            
            
        }
        
    }
    
    
    // Search API
    func searchcardAPI(){
        
        searchBar.resignFirstResponder()
        var params : NSMutableDictionary = [:]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if (appDelegate.lat == 0 && appDelegate.long == 0 && appDelegate.locality_id == "") {
            
            alertController(controller: self, title: "", message: "Please select city/location to get offers", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return
        }
        
        // if user select current location
        if (appDelegate.lat == 0 && appDelegate.long == 0) {
            params = [
                "search_for": self.searchBar.text as Any,
                klocality_id : appDelegate.locality_id,
            ]
        }
        else{
            params = [
                klatitude: appDelegate.lat,
                klongitude: appDelegate.long,
                "search_for": self.searchBar.text as Any
            ]
        }
        print(params)
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"searchOffer")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    print(response![kCode]!)
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        print(dict[kPayload] as Any)
                        
                        let cardArray = dict[kPayload] as! NSMutableArray
                        
                        let searchViewController = self.storyboard?.instantiateViewController(withIdentifier: ksearchStoryBoardID) as? SearchViewController
                        searchViewController?.searchText = self.searchText
                        searchViewController?.cardArray  = cardArray; self.navigationController?.pushViewController(searchViewController!, animated: true)
                    }
                    else
                    {
                        let message = dict[kMessage]
                        
                        alertController(controller: self, title: "", message:message! as! String, okButtonTitle: "OK", completionHandler: {(index) -> Void in
                            
                        })
                        
                    }
                }
            }
                
            else {
                
                // show alert
            }
            
            
            
            
        }
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kcategorySegmentSegueIdentifier {
            
            let categorySegmentViewController : CategorySegmentViewController = segue.destination as! CategorySegmentViewController
            categorySegmentViewController.offerDictionary = sender as! NSMutableDictionary
            categorySegmentViewController.selectedOfferId = self.selectedOfferId
            categorySegmentViewController.selectedStoreId = storIdString


        }
    }
    
}
