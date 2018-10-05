//
//  MyFavoritescardViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 03/11/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit
let colors = [UIColor.brown, UIColor.blue, UIColor.orange, UIColor.purple,UIColor.darkGray,UIColor.lightGray,UIColor.green,]

class MyFavoritescardViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!

    var  cardProviderDetailsDictionary : NSMutableDictionary = NSMutableDictionary()
    var favcardArray : NSMutableArray! = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let  appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if appDelegate.userType == kguestUser {
            
            self.messageLabel.text = "Please Login to see your Favourite cards"
            messageLabel.isHidden = false
            collectionView.isHidden = true
        }
        else {
            messageLabel.isHidden = true
            collectionView.isHidden = true
        }
        self.getListOfFavoritesCard()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK:- Collection view Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       return self.favcardArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RightNowCollectionCell
        
        cell.setWallet(dictionary:(self.favcardArray[indexPath.row] as? NSMutableDictionary)!)
        cell.nameLabel.backgroundColor = colors[indexPath.row % colors.count]
        
        return cell
    }
    
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (kIphoneWidth-30)/2, height: 150) // The size of one cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 0, 10) // margin between cells
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if (appDelegate.lat == 0 && appDelegate.long == 0 && appDelegate.locality_id == "") {
            alertController(controller: self, title: "", message: "Please select city/location for get offers", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return
        }
        else{
            self.getcardProviderDetails(providerDicationary: (self.favcardArray[indexPath.row] as? NSMutableDictionary)!)
        }
    }
    
    
    // MARK : APIs call
    
    // get card list
    func getListOfFavoritesCard(){
        
        let loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        var params : NSMutableDictionary = [:]
        
        params = [
            "user_id": loginInfoDictionary.value(forKey: kid) as Any
        ]
        print(params)
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"FavoriteCardList")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    print(response![kCode]!)
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        print(dict[kPayload] as Any)
                        self.collectionView.isHidden = false

                        self.favcardArray = dict[kPayload] as! NSMutableArray
                        self.collectionView.reloadData()
                        
                        if self.favcardArray.count == 0 {
                        self.messageLabel.isHidden = false
                         self.messageLabel.text = "No Favorite Loyalty Card List Found! "
                        
                        }
                    }
                    else{
                        self.messageLabel.isHidden = false
                        self.messageLabel.text = "No Favorite Loyalty Card List Found!"
                    }
                    
                }
            }
            
        }
        
    }
    
    
    // MARK:- Get cart Details
    
    func getcardProviderDetails( providerDicationary : NSDictionary){
        
        var params : NSMutableDictionary = [:]
        
        
        params = [
            kid: providerDicationary.value(forKey: kid) ?? "",
            "r_id" : providerDicationary.value(forKey: kcardRelatedToId) ?? ""
        ]
        
        print(params)
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"cardProviderDetails")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    print(response![kCode]!)
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        
                        self.cardProviderDetailsDictionary = dict[kPayload] as! NSMutableDictionary

                        self.performSegue(withIdentifier: kwalletDetailsSegieIdentifier, sender:providerDicationary)
                        
                        
                    }
                    else{
                        
                        
                    }
                    
                }
            }
            
        }
        
    }
    
    
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kwalletDetailsSegieIdentifier {
            
            let walletDetails : walletDetailsSegmentViewController = (segue.destination as? walletDetailsSegmentViewController)!
            walletDetails.cardProviderDetailsDictionary = self.cardProviderDetailsDictionary
//            walletDetails.walletDictionary = sender as? NSMutableDictionary
            
        }
    }
    

}
