//
//  CategoryDetailCell.swift
//  Hoopoun
//
//  Created by vineet patidar on 30/08/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class CategoryDetailCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet var collectionView: UICollectionView!
    
    var storeArray : NSMutableArray = NSMutableArray()
    var nav : UINavigationController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        addCollectionView()
    }
    
    func addCollectionView(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "CategoryDetailCollectionCell", bundle: nil), forCellWithReuseIdentifier: "collectionCell")
        
    }
        
    // MARK:- Collection view Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : CategoryDetailCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CategoryDetailCollectionCell
  
        cell.setCellData(offerAray: storeArray, index: indexPath.row)
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        

        let dict : NSMutableDictionary =  storeArray.object(at: indexPath.section) as! NSMutableDictionary
        let offetType : String = (dict.value(forKey: kofferTitle) as? String)!
        
        let storeName :String = (dict.value(forKey: kstore_name) as? String)!
        let address = String(format: "%@, %@",storeName,(dict.value(forKey: kaddress) as? String)!)
        
        var height :Float = Float(calculateHeightForlblTextWithFont(offetType, _width: (kIphoneWidth-125), font: UIFont(name: "SFUIText-Semibold", size: 12)!))
        
        height = Float(calculateHeightForlblTextWithFont(address, _width: (kIphoneWidth-135), font: UIFont(name: "SFUIText-Regular", size: 12)!)) + height
        
        
        // collection view cell size
        if self.storeArray.count > 1 {
            return CGSize(width: kIphoneWidth-40, height:265)
        }
        else{
            return CGSize(width: kIphoneWidth, height: 265)
        }
        
    }
        
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
      
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            if appDelegate.offerDictionary != nil {
//                appDelegate.selectedOfferId = ""
//                appDelegate.offerDictionary.removeAllObjects()
//            }
       
        
       // let appDelegate :AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
     /*   if appDelegate.userType == kguestUser {
            
            alertController(controller: self.nav!, title: "", message: "Please Login first for view offer details", okButtonTitle: "LOGIN", cancelButtonTitle: "CANCEL", completionHandler: {(index) -> Void in
                
                if index == 1 {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let signIn = storyBoard.instantiateViewController(withIdentifier: kSignInStoryBoardID) as? SignInViewController
                    let nav : UINavigationController = UINavigationController(rootViewController: signIn!)
                    appDelegate.window?.rootViewController = nav
                    appDelegate.window?.makeKeyAndVisible()                  }
                
            })
        }
        else{*/
            self.getOfferDetails(dict: storeArray.object(at: indexPath.row) as! NSMutableDictionary)
      //  }
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    // MARK: get Offer Details
    
    func getOfferDetails( dict: NSMutableDictionary){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let  loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
        var storIdString : String = (dict.value(forKey: "store_id") as? String)!
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
        
        print(params)
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"offerDetails_New")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            
            if (response != nil) {
                
                DispatchQueue.main.async {
                    
                    let dictResponce  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        
                        let payLoadDictionary = (dictResponce[kPayload]) as! NSMutableDictionary
                        
                        let offerDict : NSMutableDictionary = payLoadDictionary.value(forKey: "offer_detail") as! NSMutableDictionary
                        
                        let stringTemp = offerDict.value(forKey: "ccount") as? String
                        if stringTemp == "1"  && stringTemp != nil {
                            
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let categorySegmentView = storyBoard.instantiateViewController(withIdentifier: kCategorySegmentStoryBoardID) as? CategorySegmentViewController
                        categorySegmentView?.selectedOfferId = dict.value(forKey: koffer_id)! as! String
                        categorySegmentView?.selectedStoreId = storIdString
                        categorySegmentView?.offerDictionary = payLoadDictionary
                        
                        self.nav?.pushViewController(categorySegmentView!, animated: true)
                        }
                        else{
                            
                            alertController(controller: self.viewController()!, title: "", message: "Offer details are not found", okButtonTitle: "OK", completionHandler: {(index) -> Void in
                            })
                        }
                    }
                    else
                    {
                        let message = dict[kMessage]
                        
                        alertController(controller: self.viewController()!, title: "", message:message! as! String, okButtonTitle: "OK", completionHandler: {(index) -> Void in
                            
                        })
                        
                    }
                }
            }
                
            else {
                
                DispatchQueue.main.async {
                }
            }
            
            
        }
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kcategorySegmentSegueIdentifier {
            
            let categorySegmentViewController : CategorySegmentViewController = segue.destination as! CategorySegmentViewController
            categorySegmentViewController.offerDictionary = sender as! NSMutableDictionary
        }
    }
    
}
