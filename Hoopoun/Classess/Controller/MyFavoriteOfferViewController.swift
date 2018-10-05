//
//  MyFavoriteOfferViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 03/11/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class MyFavoriteOfferViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var offerArray : NSMutableArray! = NSMutableArray()
    var appDelegate : AppDelegate! = nil
    var isLoadRewardArray : Bool = false
    var selectedOfferId : String = ""
    var storIdString : String = ""
    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
  
    }
  
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            let window = UIApplication.shared.keyWindow!
            let addReviewButton = window.viewWithTag(2017)
            addReviewButton?.isHidden = true
        }
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        if appDelegate.userType == kguestUser {
            
            self.messageLabel.text = "Please Login to see your Favourite offers"
            messageLabel.isHidden = false
            collectionView.isHidden = true
        }
        else {
            messageLabel.isHidden = true
            collectionView.isHidden = true
            self.getFavOfferList()
        }
    }
  

    
    // MARK:- Collection view Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.offerArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favOffer", for: indexPath) as! FavOfferCollectionCell
         cell.setCellData(dictionary:(self.offerArray[indexPath.row] as? NSMutableDictionary)!)

            return cell
    }
  
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (kIphoneWidth-30)/2, height: 245) // The size of one cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10) // margin between cells
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
                    self.getOfferDetails(dict: offerArray.object(at: indexPath.row ) as! NSMutableDictionary)
                }
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
        
        
        if (appDelegate.lat == 0 && appDelegate.long == 0) {
            
            params = [
                klocality_id : appDelegate.locality_id,
                kstore_id : storIdString,
                koffer_id : dict.value(forKey: "offerid")!,
                "user_id" : loginInfoDictionary.value(forKey: kid)!
            ]
        }
        else{
            params = [
                
                klatitude: String(appDelegate.lat),
                klongitude: String(appDelegate.long),
                kstore_id : storIdString,
                koffer_id : dict.value(forKey: "offerid")!,
                "user_id" : loginInfoDictionary.value(forKey: kid)!
            ]
        }
        
        selectedOfferId = dict.value(forKey: "offerid")! as! String
        print(params)
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"offerDetails_New")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                
                DispatchQueue.main.async {
                    print(response![kCode]!)
                    
                    let dictResponce  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        
                        print(dictResponce[kPayload] as Any)
                        
                        let payLoadDictionary = (dictResponce[kPayload]) as! NSMutableDictionary
                        
                        self.performSegue(withIdentifier: kcategorySegmentSegueIdentifier, sender: payLoadDictionary)
                        
                    }
                    else
                    {
                        let message = dictResponce[kMessage]
                        
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

    // MARK: get Offer Details
    
    func getFavOfferList(){
        
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
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"offerLikeHistory")
        
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: false, showSystemError: false, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    let message = dict[kMessage]

                    if index == "200" {
                        print(dict[kPayload] as Any)
                        self.offerArray = (dict[kPayload]) as! NSMutableArray
                        
                        if self.offerArray.count > 0 {
                            self.messageLabel.isHidden = true
                            self.collectionView.isHidden = false
                        }
                        else{
                            self.messageLabel.isHidden = false
                            self.messageLabel.text = message as? String
                            self.collectionView.isHidden = true
                        }
                        
                        self.collectionView.reloadData()
                        
                    }
                    else
                    {
                        self.messageLabel.isHidden = false
                        self.messageLabel.text = message as? String
                        self.collectionView.isHidden = true

                    }
                }
            }
                
            else {
                
                // show alert
                self.messageLabel.isHidden = true
                self.collectionView.isHidden = true
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
