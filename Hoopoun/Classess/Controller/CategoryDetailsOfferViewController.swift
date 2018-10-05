//
//  CategoryDetailsOfferViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 13/10/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class CategoryDetailsOfferViewController: UITableViewController{
    
    let offerArray : NSMutableArray = NSMutableArray()
    var offerDictionary : NSMutableDictionary!
    var selectionArray : NSMutableArray = NSMutableArray()
    var selectedOfferId : String = ""
    var fromView : String = ""
    
    var isShowTerms : Bool = true
    var isShowDescription: Bool = true
    var isShowTimming : Bool  = true
    var IsShowOffers : Bool = true
    var isFromRowSelection : Bool = false
    var  loginInfoDictionary : NSMutableDictionary!
    let visitScrollView:UIScrollView = UIScrollView()
    var selectedIndex : Int = 0
    var redeemOfferDictionary : NSDictionary = NSDictionary()
    
    @IBOutlet var expDateLabel: UILabel!
    var offersTimmingString : String = ""
    
    let fontSize = 14
    let extraHeight : CGFloat = 10.0
    
    @IBOutlet var categoryOfferTable: UITableView!
    
    // MARK: - Table view data source
    
    override func viewDidLoad() {
        
        loginInfoDictionary = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
        visitScrollView.frame = CGRect(x: 0, y: 0, width: kIphoneWidth, height: 100)
        visitScrollView.showsVerticalScrollIndicator = false
        visitScrollView.showsHorizontalScrollIndicator  = false
        visitScrollView.delegate = self
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        if (self.offerDictionary != nil) {
            
            let offers_timming: NSMutableArray = self.offerDictionary.value(forKey: koffers_timming ) as! NSMutableArray
            
            let timingArray : NSMutableArray =  NSMutableArray()
            for dict in offers_timming {
                let tempString = String(format: "%@ - %@",(dict as AnyObject).value(forKey: kdayname) as! CVarArg,(dict as AnyObject).value(forKey: ktimming) as! CVarArg)
                timingArray.add(tempString)
            }
            
            offersTimmingString = timingArray.componentsJoined(by: ", ")
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self.selectedIndex)
        
        let array : NSArray = (self.offerDictionary.value(forKey: "offers_list") as? NSArray)!
        print(array)
        
        let resultPredicate = NSPredicate(format: "offer_id = %@", self.selectedOfferId)
        let  filterArray : NSArray = array.filtered(using: resultPredicate) as NSArray
        print(filterArray)
        
        if filterArray.count == 1 {
            
            let dict : NSDictionary = filterArray.object(at: 0) as! NSDictionary
            self.getOfferDetails(dict:dict  as! NSMutableDictionary, index: self.selectedIndex, fromView:"appear")
            }
       
    }
    
    // MARK TableView Deleage ////////////////////////////////////////////
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.offerDictionary != nil) {
            
            let offers_list: NSMutableArray = self.offerDictionary.value(forKey: koffers_list ) as! NSMutableArray
            
            if section == 0 && IsShowOffers  == true {
                return offers_list.count
            }
            else if section == 1 && isShowDescription == true {
                return 1
            }
            else if section == 2 && isShowTimming == true {
                return 1
            }
            else if section == 3 && isShowTerms == true {
                return 1
            }
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // header view
        let headerView: UIView =  UIView.init(frame: CGRect(x: 0, y: 0, width: kIphoneWidth, height: 40))
        headerView.backgroundColor = UIColor.white
        
        // header name label
        let labelView: UILabel = UILabel.init(frame: CGRect(x: 10, y: 0, width: kIphoneWidth-20, height: 40))
        labelView.font = UIFont.boldSystemFont(ofSize:  CGFloat(fontSize))
        headerView.addSubview(labelView);
        
        
        // top button
        let buttonHeader :UIButton = UIButton.init(frame:headerView.frame)
        buttonHeader.tag = section
        buttonHeader.addTarget(self, action:#selector(headerButton_Clicked), for: UIControlEvents.touchUpInside)
        buttonHeader.tag = section
        headerView.addSubview(buttonHeader)
        
        // check mark button
        let checkMarkImageView : UIImageView = UIImageView.init(frame: CGRect(x: kIphoneWidth-40, y: 10, width: 20, height: 20))
        headerView.addSubview(checkMarkImageView)
        
        
        // set header label text
        if section == 0 {
            labelView.text = "OFFERS"
        }
        else if section == 1 {
            labelView.text = "ABOUT OFFER"
        }
        else  if section == 2 {
            labelView.text = "OFFER AVAILABLE"
        }
        else  if section == 3 {
            labelView.text = "TERMS"
        }
        
        
        let visitArray : NSArray = (self.offerDictionary.value(forKey: "offer_day_visits") as? NSArray)!
        
        //  set check mark image
        
        if  section == 0 {
            if IsShowOffers  {
                checkMarkImageView.image = UIImage(named: "")
            }
            else{
                checkMarkImageView.image = UIImage(named: "")
            }
        }
        else if section == 1 {
            
            // description
            if isShowDescription  {
                checkMarkImageView.image = UIImage(named: "downBlue")
            }
            else{
                checkMarkImageView.image = UIImage(named: "upBlue")
            }
        }
            
        else if section == 2 {
            
            // offers_timming
            if isShowTimming  {
                checkMarkImageView.image = UIImage(named: "downBlue")
            }
            else{
                checkMarkImageView.image = UIImage(named: "upBlue")
            }
        }
        else if section == 3{
            // terms selesction
            if isShowTerms  {
                checkMarkImageView.image = UIImage(named: "downBlue")
            }
            else{
                checkMarkImageView.image = UIImage(named: "upBlue")
            }
        }
        else if section == 4  && visitArray.count > 0{
            
            visitScrollView.isHidden = false
            headerView.addSubview(visitScrollView)
            
            let offerDetailsDictionary: NSMutableDictionary  = self.offerDictionary.value(forKey: "offer_detail") as! NSMutableDictionary
            
            let max_offer_redeem_count : String  =  NSString(format:"%@",offerDetailsDictionary.value(forKey: "max_offer_redeem_count") as! CVarArg) as String
            
            let offer_redeem_by_user : String  =  NSString(format:"%@",offerDetailsDictionary.value(forKey: "offer_redeem_by_user") as! CVarArg) as String
            
            visitView(visitCount: Int(max_offer_redeem_count)! , visited: Int(offer_redeem_by_user)!)
        }
        
        
        return headerView
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let visitArray : NSArray = (self.offerDictionary.value(forKey: "offer_day_visits") as? NSArray)!
        
        if section == 4 && visitArray.count > 0  {
            return 100
        }
        return 40
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "testcell"
        
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: identifier)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.backgroundColor = UIColor.clear
        
        if indexPath.section == 0 {
            
            // check mark image view
            let checkMarkImage : UIImageView = UIImageView.init(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
            checkMarkImage.image = UIImage(named:"")
            cell.contentView.addSubview(checkMarkImage)
            
            // offer lable
            
            let offers_list: NSMutableArray = self.offerDictionary.value(forKey: koffers_list ) as! NSMutableArray
            let offerName : String =  ((offers_list.object(at: indexPath.row) as? NSDictionary)!.value(forKey: kofferTitle) as? String)!
            
            let offerHeght = offerName.height(withConstrainedWidth: kIphoneWidth-40, font: UIFont(name: kFontSFUITextRegular, size: CGFloat(fontSize))!)
            
            var height : CGFloat = 0.0
            
            height = offerHeght+5
            
            
            
            let offerx_Axis :Float = Float(checkMarkImage.frame.origin.x+checkMarkImage.frame.size.width)
            
            let offerLabel :UILabel = UILabel.init(frame: CGRect(x: Int(offerx_Axis+5), y: 5, width: Int(kIphoneWidth - 40), height: Int(height)))
            offerLabel.backgroundColor = UIColor.clear
            offerLabel.font = UIFont(name: kFontSFUITextRegular, size:  CGFloat(fontSize))
            offerLabel.text = offerName
            offerLabel.numberOfLines = 0
            cell.contentView.addSubview(offerLabel)
            
            // discount label Height
            
            var discountLabelheight : CGFloat = 0.0
            let offerType :String = ((offers_list.object(at: indexPath.row) as? NSDictionary)!.value(forKey: ktages) as? String)!
            
            let offerTypeHeight = offerType.height(withConstrainedWidth: kIphoneWidth-80, font: UIFont(name: kFontSFUITextRegular, size:  CGFloat(fontSize))!)
            discountLabelheight = offerTypeHeight
            
            
            let liveLabel :UILabel = UILabel.init(frame: CGRect(x: Int(offerx_Axis+5), y: Int(height+10), width: 45, height: Int(offerTypeHeight)))
            liveLabel.backgroundColor = UIColor.clear
            liveLabel.textColor = kLightBlueColor
            liveLabel.font = UIFont(name: kFontSFUITextRegular, size:  CGFloat(fontSize))
            liveLabel.text = "Live | "
            cell.contentView.addSubview(liveLabel)
            
            let liveLabelSize =  liveLabel.frame.origin.x+liveLabel.frame.size.width
            let discountLabel :UILabel = UILabel.init(frame: CGRect(x:Int(liveLabelSize), y: Int(height+10), width: Int(kIphoneWidth-liveLabelSize), height: Int(discountLabelheight)))
            discountLabel.backgroundColor = UIColor.clear
            discountLabel.font = UIFont(name: kFontSFUITextRegular, size: CGFloat(fontSize))
            discountLabel.numberOfLines = 0
            discountLabel.textColor = UIColor.darkGray
            discountLabel.text = offerType
            cell.contentView.addSubview(discountLabel)
            
            // set cell selection
            
            
            if selectionArray .contains(offers_list.object(at: indexPath.row)) {
                checkMarkImage.image = UIImage(named: "roundCheck")
            }
            else{
                checkMarkImage.image = UIImage(named: "roundCheckGray")
            }
            let offerDict : NSDictionary = (offers_list.object(at: indexPath.row) as? NSDictionary)!
            let offerString : String = (offerDict.value(forKey: koffer_id) as? String)!
            
            if selectionArray.count == 0 && offerString == self.selectedOfferId {
                checkMarkImage.image = UIImage(named: "roundCheck")
            }
            
        }
        else{
            cell.textLabel?.textColor = UIColor.darkGray
            cell.textLabel?.font = UIFont(name: kFontSFUITextRegular, size: CGFloat(fontSize))
            cell.textLabel?.numberOfLines = 0
        }
        
        if (self.offerDictionary != nil) {
            
            let offerDetailsDictionary: NSMutableDictionary  = self.offerDictionary.value(forKey: "offer_detail") as! NSMutableDictionary
            
            
            let description: String = offerDetailsDictionary.value(forKey: kdescription ) as! String
            
            let term: String = offerDetailsDictionary.value(forKey: kterms ) as! String
            
            
            cell.textLabel?.font = UIFont(name: kFontSFUITextRegular, size:  CGFloat(fontSize))
            
            if  indexPath.section == 1 {
                cell.textLabel?.text = description
            }
            else if indexPath.section == 2{
                cell.textLabel?.text = offersTimmingString
            }
            else if indexPath.section == 3 {
                cell.textLabel?.text = term
            }
            
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section != 0 {
            
            if (self.offerDictionary != nil) {
                let offerDetailsDictionary: NSMutableDictionary  = self.offerDictionary.value(forKey: "offer_detail") as! NSMutableDictionary
                
                let description: String = offerDetailsDictionary.value(forKey: kdescription ) as! String
                let term: String = offerDetailsDictionary.value(forKey: kterms ) as! String
                
                
                if  indexPath.section == 1 {
                    return description.height(withConstrainedWidth: kIphoneWidth-40, font: UIFont(name: kFontSFUITextRegular, size:  CGFloat(fontSize))!) + extraHeight
                    
                }
                else if indexPath.section == 2 {
                    return offersTimmingString.height(withConstrainedWidth: kIphoneWidth-40, font: UIFont(name: kFontSFUITextRegular, size:  CGFloat(fontSize))!) + extraHeight
                }
                else if indexPath.section == 3 {
                    return term.height(withConstrainedWidth: kIphoneWidth-40, font: UIFont(name: kFontSFUITextRegular, size:  CGFloat(fontSize))!) + extraHeight
                }
            }
            
        }
        else if indexPath.section == 0 {
            if (self.offerDictionary != nil) {
                
                let offers_list: NSMutableArray = self.offerDictionary.value(forKey: koffers_list ) as! NSMutableArray
                

                
                let offerName : String =  ((offers_list.object(at: indexPath.row) as? NSDictionary)!.value(forKey: kofferTitle) as? String)!
                let offerType :String = ((offers_list.object(at: indexPath.row) as? NSDictionary)!.value(forKey: ktages) as? String)!
                
                let offerHeght = offerName.height(withConstrainedWidth: kIphoneWidth-40, font: UIFont(name: kFontSFUITextRegular, size:  CGFloat(fontSize))!)
                let offerTypeHeight = offerType.height(withConstrainedWidth: kIphoneWidth-80, font: UIFont(name: kFontSFUITextRegular, size:  CGFloat(fontSize))!)
                
                return offerTypeHeight + offerHeght + 25
            }
        }
        
        return 40;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            self.selectedIndex = indexPath.row
            let offers_list: NSArray = self.offerDictionary.value(forKey: koffers_list ) as! NSArray
            isFromRowSelection = true
            self.getOfferDetails(dict: offers_list[indexPath.row]  as! NSMutableDictionary, index: indexPath.row, fromView:"cell")
            
        }
    }
    
    // MARK:BUTTON SELECTION
    
    @IBAction func redeemOfferButton_clicked(_ sender: Any) {
        
        let offers_list: NSArray = self.offerDictionary.value(forKey: koffers_list ) as! NSArray
        
        let offers_Status: NSDictionary = self.offerDictionary.value(forKey: koffer_status ) as! NSDictionary
        
        var Timestamp: TimeInterval {
            return NSDate().timeIntervalSince1970
        }
        
        if (offers_Status.value(forKey: "open_date_time") != nil) && (offers_Status.value(forKey: "close_date_time") != nil) {
            
            let openTime : Int = offers_Status.value(forKey: "open_date_time") as! Int
            let closeTime : Int = offers_Status.value(forKey: "close_date_time") as! Int
            let currentTime = Timestamp
            
            print(openTime)
            print(closeTime)
            print(currentTime)
            
            if openTime <= Int(currentTime) && closeTime >= Int(currentTime) {
                print("open")
            }
            else {
                alertController(controller: self, title: "", message: "Offer not availabe at this time", okButtonTitle: "OK", completionHandler:
                    {(index) -> Void in
                })
            }
        }
        else  if offers_Status.value(forKey: "day") as? String == "Closed" {
            alertController(controller: self, title: "", message: "Store Closed", okButtonTitle: "OK", completionHandler:
                
                {(index) -> Void in
                    
            })
            return
        }
        
        if self.selectionArray.count == 0{
            redeemOfferDictionary = (offers_list[0] as? NSDictionary)!
        }
        else {
            redeemOfferDictionary = (self.selectionArray[0] as? NSDictionary)!
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        if appDelegate.userType == (kguestUser as NSString) as String {
            
            alertController(controller: self, title: "", message: "Please login first to redeem offer", okButtonTitle: "LOGIN", cancelButtonTitle: "CANCEL", completionHandler: {(index) -> Void in
                
                if index == 1 {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let signIn = storyBoard.instantiateViewController(withIdentifier: kSignInStoryBoardID) as? SignInViewController
                    let nav : UINavigationController = UINavigationController(rootViewController: signIn!)
                    appDelegate.window?.rootViewController = nav
                    appDelegate.window?.makeKeyAndVisible()                  }
                
            })
        }
            
        else{
            if (appDelegate.lat != 0 && appDelegate.long != 0) {
                
                alertController(controller: self, title: "Confirm", message: "Are you near to merchant to share your redeemption code with merchant?", okButtonTitle: "NO", cancelButtonTitle: "YES", completionHandler: {(index) -> Void in
                    
                    if index == 0{
                        
                        self.offerAvailability()
                        
                    }
                })
            }
            else{
                
                alertController(controller: self, title: "", message: "Please turn on your location to Redeem the Offer", okButtonTitle: "OK", completionHandler: {(index) -> Void in
                    
                })
            }
        }
        
        
        
        
    }
    
    
    func headerButton_Clicked(sender : UIButton){
        
        if  sender.tag == 0 {
            if IsShowOffers  {
                IsShowOffers = true
            }
            else{
                IsShowOffers = true
            }
            return
        }
        else if sender.tag == 1 {
            
            // description
            if isShowDescription  {
                isShowDescription = false
            }
            else{
                isShowDescription = true
            }
        }
            
        else if sender.tag == 2 {
            
            // offers_timming
            if isShowTimming  {
                isShowTimming = false
            }
            else{
                isShowTimming = true
            }
        }
        else if sender.tag == 3
        {
            // terms selesction
            if isShowTerms  {
                isShowTerms = false
            }
            else{
                isShowTerms = true
            }
        }
        
        self.tableView.reloadData()
        
    }
    
    // creat visit circle
    
    func visitView(visitCount : NSInteger, visited : NSInteger){
        
        var x_axis : Float = 10.0
        
        for i in 1...visitCount{
            
            let visitButton : UIButton = UIButton()
            visitButton.frame = CGRect(x:Int(x_axis), y: 20, width: 60, height: 60)
            
            visitButton.titleLabel?.font = UIFont.systemFont(ofSize:  CGFloat(fontSize))
            visitButton.titleLabel?.textColor = UIColor.white
            visitButton.tag = i
            
            if i <= visited {
                
                visitButton.setTitle("Redeem", for: .normal)
                visitButton.backgroundColor = kLightBlueColor
                visitButton.layer.borderColor = UIColor(red: 127.0/255.0, green:
                    228.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
            }
            else{
                visitButton.setTitle("Visit", for: .normal)
                visitButton.backgroundColor = UIColor.lightGray
                visitButton.layer.borderColor = UIColor(red: 237.0/255.0, green:
                    237.0/255.0, blue: 237.0/255.0, alpha: 1.0).cgColor
            }
            
            // set visit button frame
            
            visitButton.layer.cornerRadius = 30
            visitButton.layer.borderWidth = 3.0
            visitButton.layer.masksToBounds = true
            visitButton.addTarget(self, action: #selector(visitButton_clicked), for: UIControlEvents.touchUpInside)
            self.visitScrollView.addSubview(visitButton)
            x_axis = x_axis+80
            
        }
        
        visitScrollView.contentSize = CGSize(width: Int(x_axis), height: 100)
    }
    
    // Button Action
    
    func visitButton_clicked(sender : UIButton){
        
        let visitArray : NSArray = (self.offerDictionary.value(forKey: "offer_day_visits") as? NSArray)!
        let message : NSDictionary = visitArray[sender.tag-1] as! NSDictionary
     
        
        let offerDetailsDictionary: NSMutableDictionary  = self.offerDictionary.value(forKey: "offer_detail") as! NSMutableDictionary
        
        let offerType : String  =  NSString(format:"%@",offerDetailsDictionary.value(forKey: "offerType") as! CVarArg) as String
        
        var offerString = ""
        if offerType == "5" {
        offerString = message.value(forKey:"visit_offer") as! String
        }
        else {
        offerString = message.value(forKey:"visit_offer") as! String + ", Get \(message.value(forKey:"visit_discount_value_percent") as! String)% off total bill"
        }
        
   
        
        alertController(controller: self, title: "", message: offerString, okButtonTitle: "OK", completionHandler: {(index) -> Void in
            
        })
        print(visitArray[sender.tag-1])
        
    }
    // MARK:- APIs Call
    func redeemOfferCode(){
        
        
        // param dictionary
        var params : NSMutableDictionary = [:]
        params = [
            koffer_id : redeemOfferDictionary.value(forKey: koffer_id)!,
            "user_id" : loginInfoDictionary.value(forKey: kid) as Any
        ]
        
        let requestURL: URL = URL(string: String(format: "%@%@",kBaseUrl,"offerCode"))!
        
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        self.performSegue(withIdentifier: kredeemOfferSegieIdentifier, sender: dict[kPayload])
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
    
    func offerAvailability(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        // param dictionary
        var params : NSMutableDictionary = [:]
        params = [
            klatitude: String(appDelegate.lat),
            klongitude: String(appDelegate.long),
            koffer_id : redeemOfferDictionary.value(forKey: koffer_id)!,
            "user_id" : loginInfoDictionary.value(forKey: kid) as Any
        ]
        
        
        let requestURL: URL = URL(string: String(format: "%@%@",kBaseUrl,"userLocationAval"))!
        
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        self.redeemOfferCode()
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
    
    
    // MARK: get Offer Details
    
    func getOfferDetails( dict: NSMutableDictionary, index : NSInteger, fromView : String){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let  loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
        var storIdString : String = (dict.value(forKey: kstoreId) as? String)!
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
            userIDString =  loginInfoDictionary.value(forKey: kid) as! String
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
        
        if fromView == "cell" {
            selectedOfferId = dict.value(forKey:koffer_id)! as! String
        }
        
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"offerDetails_New")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                
                DispatchQueue.main.async {
                    print(response![kCode]!)
                    
                    
                    let dictResponce  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        
                        
                        let payLoadDictionary = (dictResponce[kPayload]) as! NSMutableDictionary
                        
                        
                        let offers_list: NSArray = payLoadDictionary.value(forKey: koffers_list ) as! NSArray
                        
                        if fromView == "cell" {
                            self.selectionArray.removeAllObjects()
                            self.selectionArray.add(offers_list.object(at: self.selectedIndex))
                        }
                        
                        let array : NSArray = (self.offerDictionary.value(forKey: "offers_list") as? NSArray)!
                        print(array)
                        
                        let resultPredicate = NSPredicate(format: "offer_id = %@", dict.value(forKey: koffer_id)! as! CVarArg)
                        let  filterArray : NSArray = array.filtered(using: resultPredicate) as NSArray
                        print(filterArray)
                        
                        if filterArray.count == 1 {
                            
                            self.expDateLabel.text  = convetDateIntoString(date: ((filterArray.object(at:0) as? NSDictionary)!.value(forKey: kexpire_date) as? String)!)
                        }
                        
                        self.offerDictionary = payLoadDictionary
                        self.categoryOfferTable.reloadData()
                        let appDelegate = UIApplication.shared.delegate as? AppDelegate
                        if self.isFromRowSelection == true {
                            self.isFromRowSelection = false
                            
                            
                            if let storyboard = self.storyboard {
                                let headerController :PresentHeaderViewController = (storyboard
                                    .instantiateViewController(withIdentifier: "PresentHeader") as? PresentHeaderViewController)!
                                headerController.offerDictionary = self.offerDictionary.mutableCopy() as! NSMutableDictionary
                                appDelegate?.selectedOfferId = self.selectedOfferId
                                appDelegate?.offerDictionary = payLoadDictionary
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                            }

                        }
                        else {
                            appDelegate?.selectedOfferId = self.selectedOfferId
                            appDelegate?.offerDictionary = payLoadDictionary
                        }
                        
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
        
        if segue.identifier == kredeemOfferSegieIdentifier {
            
            let dict : NSMutableDictionary = (offerDictionary.value(forKey: "offer_detail") as? NSMutableDictionary)!
            
            let redeemOfferViewController : RedeemOfferViewController = segue.destination as! RedeemOfferViewController
            redeemOfferViewController.offerCodeDictionary = sender as! NSMutableDictionary
            redeemOfferViewController.offerInfoDictionary = dict
        }
    }
    
}
