//
//  AroundMeViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 21/08/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class AroundMeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var offerArray : NSMutableArray! = NSMutableArray()
    var selectedOfferId : String = ""
     var storIdString : String = ""
    
    @IBOutlet weak var aroundMeTable: UITableView!
    @IBOutlet var messageLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if offerArray.count == 0 {
            messageLabel.isHidden = false
            aroundMeTable.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    // MARK TableView Deleage ////////////////////////////////////////////
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.offerArray.count
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
        
        if self.offerArray.count>0 {
            cell.setAroundMeCellData(dictionary: self.offerArray.object(at: indexPath.section) as! NSMutableDictionary, cellType: "") 
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let dict : NSMutableDictionary =  self.offerArray.object(at: indexPath.section) as! NSMutableDictionary
        let offetType : String = (dict.value(forKey: kofferTitle) as? String)!
        
        let storeName :String = (dict.value(forKey: kstore_name) as? String)!
        let address = String(format: "%@ %@",storeName,(dict.value(forKey: kstoreAddress) as? String)!)
        
        
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
        
        self.getOfferDetails(dict: offerArray.object(at: indexPath.section) as! NSMutableDictionary)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
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
                koffer_id : dict.value(forKey: koffer_id)!,
                "user_id" : userIDString
            ]
        }
        else{
            params = [
                
                klatitude: String(appDelegate.lat),
                klongitude: String(appDelegate.long),
                kstore_id : storIdString,
                koffer_id : dict.value(forKey: koffer_id)!,
                "user_id" : userIDString
            ]
        }
        selectedOfferId = dict.value(forKey:koffer_id)! as! String
        
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
