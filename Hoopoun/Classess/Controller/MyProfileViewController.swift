//
//  MyProfileViewController.swift
//  Hoopoun
//
//  Created by Chankit on 10/6/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit
import MessageUI
import Foundation
import CoreLocation


class MyProfileViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate,cityDelegate,CLLocationManagerDelegate{
    
    //outlet
    
    @IBOutlet var profileBGView: UIView!
    @IBOutlet var profileTable: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    var appDelegate:AppDelegate! = nil
    
    var loginInfoDictionary : NSMutableDictionary!
    var profileDictionary : NSMutableDictionary!
    
    var locationManager : CLLocationManager!
    var currentLocation :CLLocation!
    
    
    //initalisation
    var labelArray = ["Edit Profile","Location","Rate us","Share","About Us","How it Works","Help & Support"];
    var logoImage = ["profileUser","locationProfile","RateUs","shareProfile","AbouUs","HowItWorks","Support"]
    
    
    @IBOutlet var logoutView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as? NSMutableDictionary
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if appDelegate.profileLocation != "" {
            
            if appDelegate.profileLocation.range(of:"Location :") != nil {

                let LocationString  = String(format: "%@",appDelegate.profileLocation)
                labelArray = ["Edit Profile",LocationString,"Rate us","Share","About Us","How it Works","Help & Support"];
}
            else {
                let LocationString  = String(format: "Location : %@",appDelegate.profileLocation)
                labelArray = ["Edit Profile",LocationString,"Rate us","Share","About Us","How it Works","Help & Support"];
            }
            
        }
        else  if appDelegate.cityName != "" {
            let LocationString  = String(format: "Location : %@",appDelegate.cityName)
            labelArray = ["Edit Profile",LocationString,"Rate us","Share","About Us","How it Works","Help & Support"];
        }
        
        
        // make profile image roundup
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.layer.borderWidth = 3.0
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.masksToBounds = true
        
        profileBGView.layer.cornerRadius = profileBGView.frame.size.width/2
        profileBGView.layer.borderWidth = 3.0
        profileBGView.layer.borderColor = kBlueColor.cgColor
        profileBGView.layer.masksToBounds = true
        
       
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if appDelegate.userType != kguestUser
        {
            self.getProfile()
        }
        loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as? NSMutableDictionary
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // guest user functionality
        if appDelegate.userType == kguestUser
        {
            logoutView.isHidden = true
            nameLabel.text = "Guest"
        }
        else{
            // set profile image if existing
            if (loginInfoDictionary.value(forKey: kimage) != nil && (loginInfoDictionary.value(forKey: kimage) as? String)! != "") {
                let imageName : String = (loginInfoDictionary.value(forKey: kimage) as? String)!
                
                let imageUrl : NSURL = NSURL(string: imageName as String)!
                DispatchQueue.global(qos: .userInitiated).async {
                    let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
                    
                    DispatchQueue.main.async {
                        self.profileImage.image = UIImage(data: imageData as Data)
                    }
                }

            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Mark: Table View Deligates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return 0.001
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "cell"
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
       // cell.backgroundColor = kProfileLightBlueColor
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.white;
        cell.textLabel?.font = UIFont(name: kFontSFUITextRegular, size: 14.0)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        
        if(indexPath.section==0)
        {
            if appDelegate.userType == kguestUser
            {
                cell.textLabel?.text = "Sign Up"
            }
            else
            {
                cell.textLabel?.text = labelArray[indexPath.section]
            }
        }
        else
        {
            cell.textLabel?.text = labelArray[indexPath.section]
        }
        cell.imageView?.image = UIImage(named: logoImage[indexPath.section])
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.section==0)
        {
            if appDelegate.userType == kguestUser
            {
                if ((self.tabBarController?.tabBar) != nil){
                self.tabBarController?.tabBar.isHidden = true
                }
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let signIn = storyBoard.instantiateViewController(withIdentifier: kSignInStoryBoardID) as? SignInViewController
                self.navigationController?.pushViewController(signIn!, animated: true)
            }
            else
            {
                let editProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: KeditProfileController) as? EditProfileViewController
                editProfileViewController?.editProfileDictionary = self.profileDictionary
                self.navigationController?.pushViewController(editProfileViewController!, animated: true)
            }
        }
        else  if(indexPath.section==1){
            self.performSegue(withIdentifier: kselectLocationSegueIdentifier, sender: nil)
        }
        else if (indexPath.section == 2){
            let url  = NSURL(string: "https://itunes.apple.com/us/app/hoopoun/id1327355263?ls=1&mt=8")
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }
        else if (indexPath.section == 3){
            // image to share
          //  let image = UIImage(named: "locationProfile")
            let shareUrl : String = "Hey check out my amazing app at : https://itunes.apple.com/us/app/hoopoun/id1327355263?ls=1&mt=8"
            // set up activity view controller
            let imageToShare = [ shareUrl ]
            let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook, UIActivityType.postToTwitter,UIActivityType.message]
            
            self.present(activityViewController, animated: true, completion: nil)
        }
        else  if(indexPath.section==4)
        {
            let WebViewController = self.storyboard?.instantiateViewController(withIdentifier: kWebViewController) as? WebViewController
            WebViewController?.headerStr = KAboutus
            self.navigationController?.pushViewController(WebViewController!, animated: true)
        }
        else  if(indexPath.section==5)
        {
            self.performSegue(withIdentifier: khowItWorkSegueIdentifier, sender: nil)
        }
        else if (indexPath.section == 6){
            
            if !MFMailComposeViewController.canSendMail() {
                print("Mail services are not available")
                alertController(controller: self, title: "", message: "Mail services are not available", okButtonTitle: "Ok", completionHandler: {(index) -> Void in
                    
                })
                return
            }
            else
            {
                let composeVC = MFMailComposeViewController()
                composeVC.mailComposeDelegate = self
                
                let email :String = "support@hoopoun.com"
                
                // Configure the fields of the interface.
                composeVC.setToRecipients([email])
                composeVC.setSubject("")
                composeVC.setMessageBody("", isHTML: false)
                
                // Present the view controller modally.
                self.present(composeVC, animated: true, completion: nil)
            }
            
        }
    }
    
    // MARK: MailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Get Selected city
    func passSelectedCityData(dict: NSDictionary, isNearBy: Bool)
    {
        
        if isNearBy == true {
            self.getLocation()
        }
        else {
            let cityName : String = (dict.value(forKey: kcityName) as? String)!
            var localityName : String = (dict.value(forKey: kLocality) as? String)!

            localityName += ", " + cityName
            
            let LocationString : String = String(format: "Location : %@",localityName)
            
            updateLocationData(profileLocation: LocationString)
            self.appDelegate.cityName = localityName
            appDelegate.locality_id = dict.value(forKey: klocality_id) as! String
            appDelegate.lat = 0.0
            appDelegate.long = 0.0
            // set auto login data
            let loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
            
            loginInfoDictionary.setValue(dict.value(forKey: klocality_id) as! String, forKey: klocality_id)
            loginInfoDictionary.setValue(dict.value(forKey: kname) as? String, forKey: kcityName)
        }
        
    }
    
    
    func getLocation() -> Void {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locationManager.stopUpdatingLocation()
        currentLocation = locations.last! as CLLocation

        let lat = currentLocation.coordinate.latitude
        let lng = currentLocation.coordinate.longitude
        
        let loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
        loginInfoDictionary.setValue(String(lng), forKey: klongitude)
        loginInfoDictionary.setValue(String(lat), forKey: klatitude)
        
        self.getAddressFromGeoCoder()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("1")
            manager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            print("2")
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            print("3")
            manager.startUpdatingLocation()
            break
        case .restricted:
            print("4")
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            print("5")
            // user denied your app access to Location Services, but can grant access from Settings.app
            break
        }
    }
    
    
    func getAddressFromGeoCoder(){
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: { (placemarks, error) -> Void in
            
            var address: String = ""
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            if let locationName = placeMark?.subLocality {
                address += locationName + ", "
            }
            
            if let city = placeMark?.locality  {
                address += city
                 let LocationString : String = String(format: "Location : %@",address)
                self.appDelegate.cityName = address
                self.appDelegate.cityName = address
                self.appDelegate.profileLocation = address
                self.updateLocationData(profileLocation: LocationString)

            }
        })
    }
    
    
    func updateLocationData(profileLocation : String){
        
        appDelegate.profileLocation = profileLocation as String
        labelArray = ["Edit Profile",profileLocation,"Rate us","Share","About Us","How it Works","Help & Support"];
        profileTable.reloadData()
    }
    
    //Mark: Button Actions
    
    @IBAction func backButton_clicked(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func profileImageButton_clicked(_ sender: Any) {
        
        if appDelegate.userType != kguestUser
        {
            let editProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: KeditProfileController) as? EditProfileViewController
            editProfileViewController?.editProfileDictionary = self.profileDictionary
            self.navigationController?.pushViewController(editProfileViewController!, animated: true)
        }
    }
    @IBAction func logoutButton_clicked(_ sender: Any) {
        
        alertController(controller: self, title: "", message: "Are you sure you want to logout?", okButtonTitle: "LOGOUT", cancelButtonTitle: "CANCEL", completionHandler: {(index) -> Void in
            if index  == 1 {
                if ((self.tabBarController?.tabBar) != nil){
                    self.tabBarController?.tabBar.isHidden = true
                }        // logout functionality
                
                self.appDelegate.locality_id = ""
                self.appDelegate.lat = 0
                self.appDelegate.long = 0
                kUserDefault.removeObject(forKey: kloginInfo)
                kUserDefault.removeObject(forKey: klocationLocalData)
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let signIn = storyBoard.instantiateViewController(withIdentifier: kSignInStoryBoardID) as? SignInViewController
                self.navigationController?.pushViewController(signIn!, animated: true)
            }
        })
        
       
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kselectLocationSegueIdentifier {
            let  citySelection : SelectLocationViewController = (segue.destination as? SelectLocationViewController)!
            citySelection.delegate = self
            citySelection.fromViewController = "MyProfile"
        }
    }
    
    
    //Mark: API call
    
    /****************************
     * Function Name : - getProfile
     * Create on : - 7 Nov 2017
     * Developed By : - Ram
     * Description : - get User Profile
     * Organisation Name :- Sirez
     * version no :- 1.0
     ****************************/
    func getProfile(){
        
        
        // param dictionary
        var params : NSMutableDictionary = [:]
        params = [
            kid : loginInfoDictionary[kid] as! String,
        ]
        
        
        let requestURL: URL = URL(string: String(format: "%@%@",kBaseUrl,KmyProfile))!
        
        NetworkManager.sharedInstance.postRequest(requestURL, hude: false, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        print(response![kPayload]!)
                        
                        self.profileDictionary = dict[kPayload] as! NSMutableDictionary
                        var nameString : String = (self.profileDictionary[kname] as? String)!
                       nameString = nameString.replacingOccurrences(of: "*", with: " ", options: .literal, range: nil)
                        self.nameLabel.text = nameString
                        self.cityLabel.text = self.profileDictionary[kcity] as? String
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
    
}
