//
//  OfferHistoryViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 03/11/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class OfferHistoryViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    
    var historyArray : NSMutableArray! = NSMutableArray()
    var appDelegate : AppDelegate! = nil
    var showHude : Bool = false
    @IBOutlet var messageLabel: UILabel!

    
    @IBOutlet weak var historyTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.historyTable.isHidden = true
        self.messageLabel.isHidden = true
        messageLabel.textAlignment = .center
        showHude = true
      //  self.creatTitleView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
       
        DispatchQueue.main.async {
            let window = UIApplication.shared.keyWindow!
            let addReviewButton = window.viewWithTag(2017)
            addReviewButton?.isHidden = true
        }
        // check guest user
        if appDelegate.userType == kguestUser {
            self.messageLabel.text = "Please Login to see your offer history"
            self.messageLabel.isHidden = false

        }
        else{
            
            if (appDelegate.lat == 0 && appDelegate.long == 0 && appDelegate.locality_id == "") {
                
                alertController(controller: self, title: "", message: "Please select city/location for get Rewards", okButtonTitle: "OK", completionHandler: {(index) -> Void in
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
        profileButton.backgroundColor = UIColor.white
        profileButton.addTarget(self, action: #selector(profileButton_clicked), for:UIControlEvents.touchUpInside)
        profileButton.setImage(UIImage(named: "user"), for: UIControlState.normal)
        profileButton.layer.borderWidth = 3.0
        profileButton.layer.borderColor = kDefaultColor.cgColor
        profileButton.layer.cornerRadius = 34/2
        profileButton.layer.masksToBounds = true
        titleView.addSubview(profileButton)
        
        let titleLabel = UILabel()
        
        titleLabel.frame = CGRect(x:70, y: 3, width: kIphoneWidth-140, height: 36)
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.text = "Offers History"
        titleView.addSubview(titleLabel)
        
    }
    
    
    
    
    
    // MARK TableView Deleage ////////////////////////////////////////////
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.historyArray.count
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
        
        if self.historyArray.count>0 {
            cell.setOfferHistoryCellData(dictionary: self.historyArray.object(at: indexPath.section) as! NSMutableDictionary)
        }
       
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dict : NSMutableDictionary =  self.historyArray.object(at: indexPath.section) as! NSMutableDictionary
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

        return CGFloat(255+cellHeight);
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // MARK: get Offer Details
    
    func getRewardsHistory(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let  loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
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
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"offerRedeemHistory")
        
       // let baseUrl = String(format: "http://hoopoun.com/admin/api/offerRedeemHistory")
        
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: showHude, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    let message = dict[kMessage]

                    if index == "200" {
                        print(dict[kPayload] as Any)
                        self.showHude = false
                        self.historyArray = (dict[kPayload]) as! NSMutableArray
                        
                        if self.historyArray.count > 0 {
                            self.historyTable.isHidden = false
                            self.messageLabel.isHidden = true
                        }
                        else{
                        
                            self.historyTable.isHidden = true
                            self.messageLabel.isHidden = false
                            self.messageLabel.text = message as? String

                        }
                        self.historyTable.reloadData()
                        
                    }
                    else
                    {
                        
                        self.historyTable.isHidden = true
                        self.messageLabel.isHidden = false
                        self.messageLabel.text = message as? String
                        
//                        alertController(controller: self, title: "", message:message! as! String, okButtonTitle: "OK", completionHandler: {(index) -> Void in
//                            
//                        })
                        
                    }
                }
            }
                
            else {
                
                self.historyTable.isHidden = true
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
    
    @IBAction func backButton_clicked(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kcategorySegmentSegueIdentifier {
            
            let categorySegmentViewController : CategorySegmentViewController = segue.destination as! CategorySegmentViewController
            categorySegmentViewController.offerDictionary = sender as! NSMutableDictionary
            
        }
    }
    
}
