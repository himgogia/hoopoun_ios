//
//  CategoryDetailsReviewViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 13/10/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class CategoryDetailsReviewViewController:  UITableViewController {
    
    var  reviewArray : NSMutableArray = NSMutableArray()
    var  offerDictionary : NSMutableDictionary!
    @IBOutlet var categoryOfferTable: UITableView!
    var addReviewButton: UIButton! = nil
    
    // MARK: - Table view data source
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        let window = UIApplication.shared.keyWindow!
        let previousReviewButton = window.viewWithTag(2017)
        
        if (previousReviewButton != nil) {
            previousReviewButton?.removeFromSuperview()
        }
        
        // Add Review Button
        addReviewButton = UIButton.init(frame: CGRect(x: kIphoneWidth-60, y: kIphoneHeight-140, width: 50, height: 50))
        addReviewButton.layer.cornerRadius = 25
        addReviewButton.tag = 2017
        addReviewButton.setImage(UIImage(named: "add"), for: UIControlState.normal)
        
        addReviewButton.addTarget(self, action:#selector(addReviewButton_clicked), for: UIControlEvents.touchUpInside)
        
        window.addSubview(addReviewButton)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        if appDelegate.addReviewButton == false {
            addReviewButton.isHidden = false
        }
        else{
            addReviewButton.isHidden = true
        }
        
        let offerID : String = ((self.offerDictionary.value(forKey: "offer_detail")as! NSMutableDictionary).value(forKey: koffer_id) as? String)!
        self.getReviewList(offerId: offerID)
        
    }
    
    
    
    
    
    // MARK :- Hide review button
    func hideAddButton(){
        let window = UIApplication.shared.keyWindow!
        let addReviewButton = window.viewWithTag(2017)
        addReviewButton?.isHidden = false
    }
    
    
    // MARK TableView Deleage ////////////////////////////////////////////
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.reviewArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    override  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "cell"
        
        var cell: StoreReviewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? StoreReviewCell
        
        tableView.register(UINib(nibName: "StoreReviewCell", bundle: nil), forCellReuseIdentifier: identifier)
        cell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? StoreReviewCell)!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if self.reviewArray.count>0 {
            
            cell.setReviewCellData(dictionary: self.reviewArray.object(at: indexPath.section) as! NSMutableDictionary)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let dict = self.reviewArray.object(at: indexPath.section) as? NSMutableDictionary
        let reviewText = dict?.value(forKey: kreview) as? String
                
        let  height =  reviewText?.height(withConstrainedWidth: kIphoneWidth-85, font: UIFont(name: "SFUIText-Regular", size: 14)!)
        return CGFloat(75+height!)

    }
    
    
    //MARK -: Button Action
    
    func addReviewButton_clicked(){
        
        // check guest user
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        if appDelegate.userType == kguestUser {
            
            alertController(controller: self, title: "", message: "Please login first to add review", okButtonTitle: "LOGIN", cancelButtonTitle: "CANCEL", completionHandler: {(index) -> Void in
                
                if index == 1 {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let signIn = storyBoard.instantiateViewController(withIdentifier: kSignInStoryBoardID) as? SignInViewController
                    let nav : UINavigationController = UINavigationController(rootViewController: signIn!)
                    appDelegate.window?.rootViewController = nav
                    appDelegate.window?.makeKeyAndVisible()                  }
                
            })
            
        }
        else{
            self.performSegue(withIdentifier: kaddStoreReviewSegueIdentifier, sender: self.offerDictionary.value(forKey: "offer_detail"))
        }
    }
    
    //MARK:- APIS CALL
    func getReviewList(offerId : String){
        
        
        let dict : NSMutableDictionary = (offerDictionary.value(forKey: "offer_detail") as? NSMutableDictionary)!
        
        var storIdString : String = (dict.value(forKey: kstoreId) as? String)!
        let storeIds : NSArray = storIdString.components(separatedBy: "") as NSArray
        
        if storeIds.count > 0 {
            storIdString = storeIds[0] as! String
        }
        else{
            
            storIdString = ""
        }
        var params : NSMutableDictionary = [:]
        params = [
            kstore_id : storIdString,
            koffer_id : dict.value(forKey: koffer_id)!
        ]
        
        print(params)
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"storeReviewListing")
        
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: false, showSystemError: false, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        print(response as Any)
                        
                        let payLoadDictionary = (dict[kPayload]) as! NSMutableDictionary
                        
                        self.reviewArray  = (payLoadDictionary.value(forKey: "review") as? NSMutableArray)!
                        
                        
                        let rating : String = String(format: "%@",payLoadDictionary.value(forKey: "totalRating") as! CVarArg)

                        let offerDetails : NSDictionary = (self.offerDictionary.value(forKey: "offer_detail") as? NSDictionary)!
                        offerDetails.setValue(rating, forKey: "offerrating")
                        
                        if let storyboard = self.storyboard {
                            let headerController :PresentHeaderViewController = (storyboard
                                .instantiateViewController(withIdentifier: "PresentHeader") as? PresentHeaderViewController)!
                            headerController.offerDictionary = self.offerDictionary.mutableCopy() as! NSMutableDictionary
                            
                           NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                            self.categoryOfferTable.reloadData()

                        }
                        
                        
                    }
                    
                }
            }
            
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kaddStoreReviewSegueIdentifier {
            let addReviewViewController = segue.destination as? AddStoreReviewViewController
            addReviewViewController?.storeDictioary = sender as? NSMutableDictionary
        }
    }
}
