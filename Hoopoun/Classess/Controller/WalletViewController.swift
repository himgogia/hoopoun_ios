//
//  WalletViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 21/08/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import CoreLocation


class WalletViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!
    
    let tempImageView : UIImageView = UIImageView()
    
    var  loginInfoDictionary : NSMutableDictionary!
    var  cardProviderDetailsDictionary : NSMutableDictionary = NSMutableDictionary()
    let addressLable = UILabel ()
    let colors = [UIColor.brown, UIColor.blue, UIColor.orange, UIColor.purple,UIColor.darkGray,UIColor.lightGray,UIColor.green,]
    
    var appDelegate : AppDelegate! = nil
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var messageView: UIView!
    var walletArray : NSMutableArray! = NSMutableArray()
    var tempArray : NSArray! = NSArray()
    
    var showHude : Bool = false
    var isLoadRandomColor : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatTitleView()
        // Add title view in navigation bar
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        isLoadRandomColor = true
        self.searchBar.delegate = self
        
        
        if let txfSearchField = searchBar.value(forKey: "_searchField") as? UITextField {
            txfSearchField.borderStyle = .none
            txfSearchField.layer.cornerRadius = 5.0
            txfSearchField.layer.masksToBounds = true
            txfSearchField.backgroundColor = .white
        }
        
        
        self.messageLabel.text = "To start adding loyality card in your wallet,\ntap add at the top right of your screen\nand search your card,\n\nIf you can't find the card in search please select other card to add your card"
        
        self.collectionView.isHidden = true
        self.messageView.isHidden = false
        
        showHude = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        self.searchBar.text = ""
        
        getListOfCardOnWallet()
        
        loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
        // update profile image
        if (loginInfoDictionary.value(forKey: kimage) != nil && (loginInfoDictionary.value(forKey: kimage) as? String)! != "") {
            let imageName : String = (loginInfoDictionary.value(forKey: kimage) as? String)!
            
            let imageUrl : NSURL = NSURL(string: imageName as String)!
            
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
                
                DispatchQueue.main.async {
                    self.tempImageView.image = UIImage(data: imageData as Data)
                }
            }

        }
        else{
            tempImageView.image = UIImage(named: "userPlaceHolder")
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // hide review button
        let window = UIApplication.shared.keyWindow!
        let addReviewButton = window.viewWithTag(2017)
        addReviewButton?.isHidden = true
    }
    
    func creatTitleView(){
        
        loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
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
        
        tempImageView.frame = profileButton.frame
        tempImageView.layer.borderWidth = 3.0
        tempImageView.layer.borderColor = kDefaultColor.cgColor
        tempImageView.layer.cornerRadius = 34/2
        tempImageView.layer.masksToBounds = true
        titleView.addSubview(tempImageView)
        
        titleView.addSubview(profileButton)
        
        // update profile image
        if (loginInfoDictionary.value(forKey: kimage) != nil) {
            
            tempImageView.sd_setImage(with: URL(string: (loginInfoDictionary.value(forKey: kimage) as? String)!), placeholderImage: UIImage(named: "userPlaceHolder"))
        }
        else{
            tempImageView.image = UIImage(named: "userPlaceHolder")
        }
        
        let titleLabel = UILabel()
        
        titleLabel.frame = CGRect(x:70, y: 3, width: kIphoneWidth-140, height: 36)
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name:"SFUIText-Bold", size: 18.0)
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.text = "Wallet"
        titleView.addSubview(titleLabel)
        
        
        let addButton = UIButton()
        addButton.setTitle("Add", for: UIControlState.normal)
        addButton.frame = CGRect(x:titleView.frame.size.width-40 , y: 5, width: 40, height: 34)
        addButton.titleLabel?.font = UIFont(name:"SFUIText-Semibold", size: 15.0)
        addButton.backgroundColor = UIColor.clear
        addButton.addTarget(self, action: #selector(AddButon_Clicked), for:UIControlEvents.touchUpInside)
        titleView.addSubview(addButton)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK:- Collection view Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return walletArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RightNowCollectionCell
        
        // set wallet card in UI
        cell.isShowHude = self.showHude
        cell.setWallet(dictionary:(walletArray[indexPath.row] as? NSMutableDictionary)!)
        cell.nameLabel.backgroundColor =  self.colors[indexPath.row % self.colors.count]
        
        
        return cell
    }
    
    func getRandomColor() -> UIColor{
        
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (kIphoneWidth-30)/2, height: 150) // The size of one cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 0, 10) // margin between cells
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if (appDelegate.lat == 0 && appDelegate.long == 0 && appDelegate.locality_id == "") {
            alertController(controller: self, title: "", message: "Please select city/location to get offers", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return
        }
        else{
            
            
            self.getcardProviderDetails(providerDicationary: (walletArray[indexPath.row] as? NSMutableDictionary)!)
        }
        
        
    }
    
    
    // MARK: Button Action :-
    
    func profileButton_clicked(sender :UIButton!){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let myProfileViewController = storyBoard.instantiateViewController(withIdentifier: KMyProfileController) as? MyProfileViewController
        
        self.navigationController?.pushViewController(myProfileViewController!, animated: true)
    }
    
    // MARK: - Search bar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text != "" {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.getSearchText), object: nil)
            self.perform(#selector(self.getSearchText), with: nil, afterDelay: 1.5)
        }
        else{
            
            walletArray.removeAllObjects()
            walletArray = tempArray.mutableCopy() as! NSMutableArray
            self.collectionView.reloadData()
            
            self.collectionView.isHidden = false
            self.messageView.isHidden = true
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    
    func getSearchText() {
        
        // Add APIs for search card
      
        let predicate=NSPredicate(format: "ProgramName CONTAINS[cd] %@", searchBar.text!)
        let filterArray   = tempArray.filtered(using: predicate) as NSArray
        
        if filterArray.count>0 {
            walletArray.removeAllObjects()
            walletArray = filterArray.mutableCopy() as! NSMutableArray
            self.collectionView.reloadData()
            self.collectionView.isHidden = false
            self.messageView.isHidden = true
        }
        else{
            // show pop view
            
            if walletArray.count>0 {
                
                self.searchBar.resignFirstResponder()
                walletArray.removeAllObjects()
                self.collectionView.reloadData()
                self.collectionView.isHidden = true
                self.messageView.isHidden = false
            }
            
        }
    }
    
    
    //MARK:- BUtton Action
    
    func AddButon_Clicked(_ sender: Any) {
        
        
        // check guest user
        let userType = appDelegate.userType
        var cardTypeArray  : NSMutableArray!
        
        if userType == kguestUser {
            
            if walletArray.count  == 2 {
                
                alertController(controller: self, title: "", message: "Only 2 cards are allowed in Guest session, for add more cards SIGNUP/LOGIN and become a member", okButtonTitle: "LOGIN", cancelButtonTitle: "CANCEL", completionHandler: {(index) -> Void in
                    
                    if index == 1 {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let signIn = storyBoard.instantiateViewController(withIdentifier: kSignInStoryBoardID) as? SignInViewController
                        let nav : UINavigationController = UINavigationController(rootViewController: signIn!)
                        self.appDelegate.window?.rootViewController = nav
                        self.appDelegate.window?.makeKeyAndVisible()
                        
                        
                    }
                })
                return
            }else{
                cardTypeArray = ["Physical card"]
            }
        }
        else{
            cardTypeArray = ["Physical card","E-card"]
        }
        
        // Add card type picker
        
        ActionSheetStringPicker.show(withTitle: "Select card Type", rows: cardTypeArray as! [Any]!, initialSelection: 0, doneBlock: {
            picker, value, index in
            
            if value == 0 {
                
                print(cardTypeArray[value])
                self.performSegue(withIdentifier:ksearchcardSegueIdentifier , sender: nil)
                
            }
            else{
                
                if (self.appDelegate.lat == 0 && self.appDelegate.long == 0 || self.isLocationPermissionGranted() == false) {
                    alertController(controller: self, title: "", message: "Please turn on the location to scan QR Code", okButtonTitle: "OK", completionHandler: {(index) -> Void in
                        
                    })
                }
                else{
                    
                    self.performSegue(withIdentifier: kcardScanneSegueIdentifier, sender: nil)
                }
            }
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func profileButton_Clicked(_ sender: Any) {
    }
    
    // get card list
    func getListOfCardOnWallet(){
        
        
        let loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        var params : NSMutableDictionary = [:]
        
        var  userID = ""
        var deviceID = ""
        
        if appDelegate.userType == kguestUser {
            deviceID =  appDelegate.getDeviceID()
        }
        else {
            userID = loginInfoDictionary.value(forKey: kid) as! String
        }
        
        params = [
            "user_id" : userID,
            "deviceId" : deviceID
        ]
        
        print(params)
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"ListOfCardOnWallet")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: self.showHude, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    print(response![kCode]!)
                    
                    let dict  = response!
                    
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    
                    if index == "200"
                    {
                        print(dict[kPayload] as Any)
                        
                        self.walletArray = dict[kPayload] as! NSMutableArray
                        self.tempArray = self.walletArray.mutableCopy() as! NSArray
                        self.collectionView.reloadData()
                        
                        if self.walletArray.count>0 {
                            self.collectionView.isHidden = false
                            self.messageView.isHidden = true
                        }
                        else{
                            self.collectionView.isHidden = true
                            self.messageView.isHidden = false
                        }
                        
                    }
                    else{
                        
                        self.collectionView.isHidden = true
                        self.messageView.isHidden = false
                    }
                    
                }
            }
            
        }
        
    }
    
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
                        
                        self.performSegue(withIdentifier: kwalletDetailsSegieIdentifier, sender:self.cardProviderDetailsDictionary)
                        
                    }
                    else{
                        
                        
                    }
                    
                }
            }
            
        }
        
    }
    
    
    // Search Card
    
    func searchCardOnWallet(){
        
        
        var params : NSMutableDictionary = [:]
        
        params = [
            "searchstr": searchBar.text ?? ""
        ]
        
        print(params)
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"searchCard")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: self.showHude, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    print(response![kCode]!)
                    
                    let dict  = response!
                    
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    
                    if index == "200"
                    {
                        print(dict[kPayload] as Any)
                        
                        // Maintian locality hostory
                        
                        //                        if !self.appDelegate.localiryHistoryArray.contains(self.searchBar.text ?? ""){
                        //                            self.appDelegate.localiryHistoryArray.add(self.searchBar.text ?? "")
                        //                        }
                        
                        self.walletArray = dict[kPayload] as! NSMutableArray
                        self.tempArray =  dict[kPayload] as? NSMutableArray
                        self.collectionView.reloadData()
                        
                        if self.walletArray.count>0 {
                            self.collectionView.isHidden = false
                            self.messageView.isHidden = true
                        }
                        else{
                            self.collectionView.isHidden = true
                            self.messageView.isHidden = false
                        }
                    }
                    else{
                        
                        self.collectionView.isHidden = true
                        self.messageView.isHidden = false
                    }
                    
                }
            }
            
        }
        
    }
    
    /*func searchcardFromWallet(){
     
     var params : NSMutableDictionary = [:]
     
     params = [
     "searchstr": searchBar.text as Any
     ]
     
     print(params)
     
     let baseUrl = String(format: "%@%@",kBaseUrl,"searchCard")
     let requestURL: URL = URL(string: baseUrl)!
     NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: Dictionary?) in
     
     
     if response?.isEmpty == false {
     
     DispatchQueue.main.async {
     print(response![kCode]!)
     
     let dict :NSMutableDictionary = response as! NSMutableDictionary
     
     
     if dict[kCode]! as! NSInteger == 200
     {
     print(dict[kPayload] as Any)
     
     self.walletArray = dict[kPayload] as! NSMutableArray
     self.collectionView.reloadData()
     }
     else{
     
     }
     
     }
     }
     
     }
     
     }*/
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == kwalletDetailsSegieIdentifier {
            
            let walletDetails : walletDetailsSegmentViewController = (segue.destination as? walletDetailsSegmentViewController)!
            walletDetails.cardProviderDetailsDictionary = self.cardProviderDetailsDictionary
            //            walletDetails.walletDictionary = sender as? NSMutableDictionary
            
        }
    }
    
    
    // MARK: - Resign text field
    
    func touchesEnded(touches: NSSet, withEvent event: UIEvent)
    {
        self.searchBar.resignFirstResponder()
    }
    
    
     func isLocationPermissionGranted() -> Bool
    {
        guard CLLocationManager.locationServicesEnabled() else { return false }
        return [.authorizedAlways, .authorizedWhenInUse].contains(CLLocationManager.authorizationStatus())
    }
}
