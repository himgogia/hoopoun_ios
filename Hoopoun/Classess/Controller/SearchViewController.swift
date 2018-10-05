//
//  SearchViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 08/11/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    @IBOutlet var searchBar: UISearchBar!
    var cardArray : NSMutableArray = NSMutableArray()
    var selectedOfferId : String = ""

    @IBOutlet var topSearchButton: UIButton!
    var searchText : NSString!
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var searchTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
        
       // self.searchTable.isHidden = true
        self.searchBar.delegate = self
        self.searchBar.isHidden = true
        
        // change search bar text and place holder color
        if let txfSearchField = searchBar.value(forKey: "_searchField") as? UITextField {
            txfSearchField.borderStyle = .none
            txfSearchField.layer.cornerRadius = 5.0
            txfSearchField.layer.masksToBounds = true
            txfSearchField.backgroundColor = .white
        }

        self.searchBar.text = self.searchText as String?
        
        titleLabel.text = "Search Offers"
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
       
    }
    
    func keyboardWillHide(notification: NSNotification) {
        searchBar.resignFirstResponder()
        searchTable.frame.size.height = kIphoneHeight-50
    }
    
    func keyboardWillChange(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if searchBar.isFirstResponder {
                searchTable.frame.size.height = kIphoneHeight-(keyboardSize.height+50)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK TableView Deleage ////////////////////////////////////////////
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cardArray.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "cell"
        
        var cell: RewardsCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? RewardsCell
        
        tableView.register(UINib(nibName: "RewardsCell", bundle: nil), forCellReuseIdentifier: identifier)
        cell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? RewardsCell)!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if self.cardArray.count>0 {
            cell.globalSearchData(dictionary: self.cardArray.object(at: indexPath.section) as! NSMutableDictionary)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let dict : NSMutableDictionary =  self.cardArray.object(at: indexPath.section) as! NSMutableDictionary
        let offetType : String = (dict.value(forKey: kofferTitle) as? String)!
        
        let storeName :String = (dict.value(forKey: kstore_name) as? String)!
        let address = String(format: "%@ %@",storeName,(dict.value(forKey: kLocality) as? String)!)
        
        var cellHeight : CGFloat = 0.0
        let width = kIphoneWidth - 125
        
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
        return CGFloat(230+cellHeight);
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.searchBar.resignFirstResponder()
        
        let appDelegate :AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
     /*   if appDelegate.userType == kguestUser {
            
            alertController(controller: self, title: "", message: "Please Login first for view offer details", okButtonTitle: "LOGIN", cancelButtonTitle: "CANCEL", completionHandler: {(index) -> Void in
                
                if index == 1 {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let signIn = storyBoard.instantiateViewController(withIdentifier: kSignInStoryBoardID) as? SignInViewController
                    let nav : UINavigationController = UINavigationController(rootViewController: signIn!)
                    appDelegate.window?.rootViewController = nav
                    appDelegate.window?.makeKeyAndVisible()                  }
            })
        }
        else{ */
        self.getOfferDetails(dict: self.cardArray[indexPath.section] as! NSMutableDictionary)
       // }
        
    }
    
    
    
    // MARK: - searchButton
    
    @IBAction func topSearchButton_clicked(_ sender: Any) {
        self.titleLabel.isHidden = true
        self.searchBar.isHidden = false
        self.topSearchButton.isHidden = true
    }
    
    // MARK: - Search bar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text != "" {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.getSearchText), object: nil)
            self.perform(#selector(self.getSearchText), with: nil, afterDelay: 3.0)
        }
        else{
            
            searchTable.isHidden = true
            cardArray.removeAllObjects()
            searchTable.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    // APIs call for search text
    func getSearchText() {
        self.searchcardAPI()
    }
    
    
    // Search API
    func searchcardAPI(){
        
        searchBar.resignFirstResponder()
        var params : NSMutableDictionary = [:]
      let appDelegate = UIApplication.shared.delegate as! AppDelegate

        if (appDelegate.lat == 0 && appDelegate.long == 0 && appDelegate.locality_id == "") {
            
            alertController(controller: self, title: "", message: "Please select city/location for get offers", okButtonTitle: "OK", completionHandler: {(index) -> Void in
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
                        
                        self.cardArray = dict[kPayload] as! NSMutableArray
                        
                        if self.cardArray.count>0{
                            self.searchTable.isHidden = false
                            self.searchTable.reloadData()
                        }
                        else{
                            self.searchTable.isHidden = true
                            self.searchTable.reloadData()
                        }
                    }
                    else
                    {
                        self.cardArray.removeAllObjects()
                        self.searchTable.reloadData()

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
    
    
    // MARK: get Offer Details
    
    func getOfferDetails( dict: NSMutableDictionary){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let  loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
        var storIdString : String = (dict.value(forKey: "storeId") as? String)!
        let storeIds : NSArray = storIdString.components(separatedBy: ",") as NSArray
        
        if storeIds.count > 0 {
            storIdString = storeIds[0] as! String
        }
        else{
            storIdString = ""
        }
        
        var params : NSMutableDictionary = [:]
        
        var userIDString = ""
        if appDelegate.userType == kguestUser {
            userIDString = ""
        }
        else {
            userIDString =  loginInfoDictionary.value(forKey: kid)! as! String
        }
        
        if (appDelegate.lat == 0 && appDelegate.long == 0) {
            
            params = [
                klocality_id : appDelegate.locality_id,
                kstore_id : storIdString,
                koffer_id : dict.value(forKey: kid)!,
                "user_id" : userIDString
            ]
        }
        else{
            params = [
                
                klatitude: String(appDelegate.lat),
                klongitude: String(appDelegate.long),
                kstore_id : storIdString,
                koffer_id : dict.value(forKey: kid)!,
                "user_id" : userIDString
            ]
        }
        selectedOfferId = dict.value(forKey: kid)! as! String

        print(params)
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"offerDetails_New")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        
                        let payLoadDictionary = (dict[kPayload]) as! NSMutableDictionary
                        
                        let offerDict : NSMutableDictionary = payLoadDictionary.value(forKey: "offer_detail") as! NSMutableDictionary
                        
                        let stringTemp = offerDict.value(forKey: "ccount") as? String
                        if stringTemp == "1"  && stringTemp != nil {
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let categorySegmentView = storyBoard.instantiateViewController(withIdentifier: kCategorySegmentStoryBoardID) as? CategorySegmentViewController
                        categorySegmentView?.offerDictionary = payLoadDictionary
                        categorySegmentView?.selectedOfferId = self.selectedOfferId;
                            categorySegmentView?.selectedStoreId = storIdString

                            self.navigationController?.pushViewController(categorySegmentView!, animated: true)
                        }
                        else{
                            
                            alertController(controller: self, title: "", message: "Offer details are not found", okButtonTitle: "OK", completionHandler: {(index) -> Void in
                            })
                        }
                    }
                    else
                    {
                        let message = dict[kMessage]
                        
                        alertController(controller:self, title: "", message:message! as! String, okButtonTitle: "OK", completionHandler: {(index) -> Void in
                            self.searchTable.isHidden = true
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
    
    
    func isEmptyLists(dict: [String: [String]]) -> Bool {
        for list in dict.values {
            if !list.isEmpty { return false }
        }
        return true
    }
   
    // MARK Button Action
    
    
    // MARK Button Clicked
    @IBAction func BackButoon_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
