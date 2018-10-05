

import UIKit
import CoreLocation

class OffersViewController: UIViewController , SlidingContainerViewControllerDelegate,CLLocationManagerDelegate,cityDelegate,showhotDealDelegate,UISearchBarDelegate {
    
    let addressLable = UILabel ()
    var isShowHotDeal: Bool! = nil
    var appDelegate:AppDelegate! = nil
    
    var searchDelayer: Timer!
    var locality_id : String!
    var  loginInfoDictionary : NSMutableDictionary!
    
    var categoryArray : NSMutableArray = NSMutableArray()
    var offerArray : NSMutableArray! = NSMutableArray()
    var hotDealArray : NSMutableArray! = NSMutableArray()
    
    var rightNowViewController : RightNowViewController!
    var aroundMeViewController : AroundMeViewController!
    var hotDealViewController : HotDealViewController!
    var lastSelectedIndex : Int = 0
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchbarBGView: UIView!
    
    var slidingContainerViewController :SlidingContainerViewController!
    
    var locationManager : CLLocationManager!
    var currentLocation :CLLocation!
    
    var showHude : Bool = false
    var reloadHeader : Bool = false
    var searchText : NSString = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locality_id = ""
        isShowHotDeal = false
        reloadHeader = false
        showHude = true
        
        loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        if let txfSearchField = searchBar.value(forKey: "_searchField") as? UITextField {
            txfSearchField.borderStyle = .none
            txfSearchField.layer.cornerRadius = 5.0
            txfSearchField.layer.masksToBounds = true
            txfSearchField.backgroundColor = .white
        }
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
     
        loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
        self.searchBar.text = ""
        creatTitleView()
        
        // hide review button
        let window = UIApplication.shared.keyWindow!
        let addReviewButton = window.viewWithTag(2017)
        addReviewButton?.isHidden = true

        
        if (appDelegate.locality_id == "") {
            getCurrentLocation()
            return
        }
        else {
            GetNearByOffer(lat: "", lng: "", localityId: appDelegate.locality_id)
            
        }

        if reloadHeader == true {
            self.setViewControlers()
        }
    }
    
    func creatTitleView(){
        
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
        
        let tempImageView : UIImageView = UIImageView()
        tempImageView.frame = profileButton.frame
        tempImageView.layer.borderWidth = 3.0
        tempImageView.layer.borderColor = kDefaultColor.cgColor
        tempImageView.layer.cornerRadius = 34/2
        tempImageView.layer.masksToBounds = true
        titleView.addSubview(tempImageView)
        
        if (loginInfoDictionary.value(forKey: kimage) != nil && (loginInfoDictionary.value(forKey: kimage) as? String)! != "") {
            let imageName : String = (loginInfoDictionary.value(forKey: kimage) as? String)!

            let imageUrl : NSURL = NSURL(string: imageName as String)!

            tempImageView.sd_setImage(with: imageUrl as URL, placeholderImage: UIImage(named: "cartPlaceHolder"),options: [], completed: { (image, error, cacheType, imageURL) in
                // Perform operation.
                print(error as Any)
            })
        }
        else{
            tempImageView.image = UIImage(named: "userPlaceHolder")
        }
        
        titleView.addSubview(profileButton)
        
        
        addressLable.frame = CGRect(x:(kIphoneWidth-150)/2, y: 0, width: 150, height: 40)
        addressLable.numberOfLines = 0
        addressLable.textAlignment = .center
        addressLable.font = UIFont(name: "SFUIText-Medium", size: 16)
        addressLable.textColor = UIColor.white
        addressLable.backgroundColor = UIColor.clear
        addressLable.text = "Select Location"
        titleView.addSubview(addressLable)
        
        
        if appDelegate.cityName != "" {
            addressLable.text = appDelegate.cityName
        }
        
        // location image
        let locationImage = UIImageView()
        locationImage.backgroundColor = UIColor.clear
        locationImage.image = UIImage(named: "location")
        locationImage.frame = CGRect(x: addressLable.frame.origin.x-20, y: 10, width: 20, height: 20)
        titleView.addSubview(locationImage)
        
        
        // arrow image
        let arrowImage = UIImageView()
        arrowImage.backgroundColor = UIColor.clear
        arrowImage.image = UIImage(named: "dropDown")
        arrowImage.frame = CGRect(x: addressLable.frame.size.width+addressLable.frame.origin.x, y: 15, width: 14, height: 14)
        titleView.addSubview(arrowImage)
        
        
        let refreshButton = UIButton()
        refreshButton.setImage(UIImage(named: "locationArrow"), for: UIControlState.normal)
        refreshButton.frame = CGRect(x:titleView.frame.size.width-45 , y: 0, width: 55, height: 40)
        refreshButton.backgroundColor = UIColor.clear
        refreshButton.addTarget(self, action: #selector(refreshButton_clicked), for:UIControlEvents.touchUpInside)
        titleView.addSubview(refreshButton)
        
        // location button on top
        
        let selectLocation = UIButton()
        selectLocation.frame = CGRect(x:45 , y: 0, width: kIphoneWidth-110, height: 40)
        selectLocation.backgroundColor = UIColor.clear
        selectLocation.addTarget(self, action: #selector(selectLocationhButton_clicked), for:UIControlEvents.touchUpInside)
        titleView.addSubview(selectLocation)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setViewControlers(){
        
        rightNowViewController = self.storyboard?.instantiateViewController(withIdentifier: krightNowViewController) as? RightNowViewController
        rightNowViewController?.categoryArray = self.categoryArray;
        rightNowViewController?.delegateHotDeal = self
        
        aroundMeViewController = self.storyboard?.instantiateViewController(withIdentifier: karoundMeViewController) as? AroundMeViewController
        aroundMeViewController?.offerArray = self.offerArray
        
        hotDealViewController = self.storyboard?.instantiateViewController(withIdentifier: khotDealViewController) as? HotDealViewController
        hotDealViewController?.hotdealArray = self.hotDealArray
        
        
        slidingContainerViewController = SlidingContainerViewController (
            parent: self,
            contentViewControllers: [rightNowViewController!,aroundMeViewController!,hotDealViewController!],
            titles: ["Right Now","Around Me","Hot Deals"])
        
        
        view.addSubview(slidingContainerViewController.view)
        slidingContainerViewController.sliderView.appearance.outerPadding = 0
        slidingContainerViewController.sliderView.appearance.innerPadding = 0
        slidingContainerViewController.sliderView.appearance.fixedWidth = true
        
        
        slidingContainerViewController.delegate = self
        
        // check hot deal condition
        if isShowHotDeal == true {
            slidingContainerViewController.setCurrentViewControllerAtIndex(2)
        }
        else{
            slidingContainerViewController.setCurrentViewControllerAtIndex(lastSelectedIndex)
        }
        
        slidingContainerViewController.view.frame = CGRect(x: 0, y: 50, width: kIphoneWidth, height: kIphoneHeight-50)
        self.view.insertSubview(searchbarBGView, aboveSubview: slidingContainerViewController.view)
    }
    
    func viewControllerWithColorAndTitle (_ color: UIColor, title: String) -> UIViewController {
        let vc = UIViewController ()
        vc.view.backgroundColor = UIColor.white
        
        let label = UILabel (frame: vc.view.frame)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont(name: "SFUIText-Regular", size: 25)
        label.text = title
        
        label.sizeToFit()
        label.center = view.center
        
        vc.view.addSubview(label)
        
        return vc
    }
    
    // MARK :- Location Manager
    
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
        
        appDelegate.lat = Double(lat)
        appDelegate.long = Double(lng)
        
        // set auto login data(Lat Lng)
        
        let loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
        loginInfoDictionary.setValue(String(lng), forKey: klongitude)
        loginInfoDictionary.setValue(String(lat), forKey: klatitude)
        
        kUserDefault.set(NSKeyedArchiver.archivedData(withRootObject:loginInfoDictionary), forKey: kloginInfo)
        
        print(appDelegate.lat)
        print(lat)
        print(lng)
        
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
                
                self.addressLable.text = address
                self.appDelegate.cityName = address
                self.appDelegate.profileLocation = address

                
            }
            
            self.GetNearByOffer(lat: String(self.self.appDelegate.lat), lng: String(self.appDelegate.long), localityId: "")

        })
    }
 
    // MARK: Button Action
    
    func selectLocationhButton_clicked(sender : UIButton){
        
        self.performSegue(withIdentifier: kselectLocationSegueIdentifier, sender: nil)
    }
    
    func profileButton_clicked(sender :UIButton!){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let myProfileViewController = storyBoard.instantiateViewController(withIdentifier: KMyProfileController) as? MyProfileViewController
        
        self.navigationController?.pushViewController(myProfileViewController!, animated: true)
    }
    
    
    @IBAction func searchButton_clicked(_ sender: Any) {
        
        let searchViewController = self.storyboard?.instantiateViewController(withIdentifier: ksearchStoryBoardID) as? SearchViewController
        self.navigationController?.pushViewController(searchViewController!, animated: true)
        
    }
    
    
    
    func refreshButton_clicked(sender :UIButton!){
        getCurrentLocation()
    }
    
    func getCurrentLocation(){
        if CLLocationManager.locationServicesEnabled() {            switch(CLLocationManager.authorizationStatus()) {
        case  .denied:
            
            
            alertController(controller: self, title: "", message: "Enable location from your device Settings", okButtonTitle: "SETTINGS", cancelButtonTitle: "CANCEL", completionHandler: {(index) -> Void in
                
                if index == 1 {
                    let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                    UIApplication.shared.openURL(settingsUrl! as URL)
                }
            })
            
        case .authorizedAlways, .authorizedWhenInUse:
            print("Access")
            
        case .notDetermined:
            print("notDetermined")
            
            
        case .restricted:
            print("restricted")
       
            }
        }
        
        self.getLocation()
    }
    
    // MARK: Get Selected city
    func passSelectedCityData(dict: NSDictionary, isNearBy: Bool)
    {
        if isNearBy == true {
            getLocation()
            
        }
        else{
            locality_id = dict.value(forKey: klocality_id) as! String
            
            let cityName : String = (dict.value(forKey: kcityName) as? String)!
            var localityName : String = (dict.value(forKey: kLocality) as? String)!
            
            localityName += ", " + cityName
            appDelegate.locality_id = locality_id
            appDelegate.cityName = localityName as String
            appDelegate.profileLocation = localityName
            appDelegate.lat = 0.0
            appDelegate.long = 0.0
            self.addressLable.text = dict.value(forKey: kname) as? String
            
            // set auto login data
            let loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
            
            loginInfoDictionary.setValue(locality_id, forKey: klocality_id)
            loginInfoDictionary.setValue(self.addressLable.text, forKey: kcityName)
            kUserDefault.set(NSKeyedArchiver.archivedData(withRootObject:loginInfoDictionary), forKey: kloginInfo)
            
            self.GetNearByOffer(lat: "", lng: "", localityId: appDelegate.locality_id)
        }
        
    }
    
    // MARK : Hot deal selection
    func showHotDeal(){
        
        isShowHotDeal = true
        self.setViewControlers()
    }
    
    
    // MARK: SlidingContainerViewControllerDelegate
    
    func slidingContainerViewControllerDidMoveToViewController(_ slidingContainerViewController: SlidingContainerViewController, viewController: UIViewController, atIndex: Int) {
        print(atIndex)

        lastSelectedIndex = atIndex
        
    }
    
    func slidingContainerViewControllerDidShowSliderView(_ slidingContainerViewController: SlidingContainerViewController) {
        print("show")
    }
    
    func slidingContainerViewControllerDidHideSliderView(_ slidingContainerViewController: SlidingContainerViewController) {
        print("hide")
        
    }
    
    
    // MARK: - Search bar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.searchcardAPI), object: nil)
        
        self.perform(#selector(self.searchcardAPI), with: nil, afterDelay: 1.5)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    
    // GET Near By Offer
    func GetNearByOffer( lat : String, lng : String, localityId : String){
        
        var params : NSMutableDictionary = [:]
        
        params = [
            klatitude: lat,
            klongitude: lng,
            klocality_id : localityId
        ]
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"nearMeOffer")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: showHude, showSystemError: true, loadingText: false, params: params ) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    print(response![kCode]!)
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    
                    if index == "200" {
                        print(dict[kPayload] as Any)
                        
                        self.showHude = false
                        
                        // get hotdeal offers
                        self.getHotDealOffers()
                        
                        let payLoadDictionary = (dict[kPayload]) as! NSMutableDictionary
                        
                        self.categoryArray = payLoadDictionary.value(forKey: "category") as! NSMutableArray
                        self.offerArray = payLoadDictionary.value(forKey: "offers") as! NSMutableArray
                        
                    }
                    else
                    {
                        

                        
                    }
                }
            }
                
            else {
                
                // show alert
            }
            
            
        }
        
    }
    
    // get hot deal offer
    func getHotDealOffers(){
        
        var params : NSMutableDictionary = [:]
        
        // if user select current location
        if (appDelegate.lat == 0 && appDelegate.long == 0) {
            
            params = [
                klatitude: "",
                klongitude: "",
                klocality_id : locality_id
            ]
        }
        else{
            params = [
                
                klatitude: String(appDelegate.lat),
                klongitude: String(appDelegate.long),
                klocality_id : ""
            ]
        }
        
        
        print(params)
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"hotDealsOffer")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: false, showSystemError: false, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    print(response![kCode]!)
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    
                    if index == "200"{
                        
                        let payLoadDictionary = (dict[kPayload]) as! NSMutableDictionary
                        
                        self.hotDealArray = payLoadDictionary.value(forKey: "offers") as! NSMutableArray
                        
                        
                        if self.rightNowViewController != nil{
                            self.rightNowViewController.view.removeFromSuperview()
                            self.hotDealViewController.view.removeFromSuperview()
                            self.aroundMeViewController.view.removeFromSuperview()
                        }
                        self.reloadHeader = true
                        self.setViewControlers()
                        
                        
//                        // check offer filter by city ot lat long
//                        if (self.appDelegate.lat == 0 && self.appDelegate.long == 0 && self.categoryArray.count>0) {
//
//                            alertController(controller: self, title: "", message: "Cannot get your current location showing result on the basis of city selected", okButtonTitle: "OK", completionHandler: {(index) -> Void in
//                            })
//                        }
                    }
                    
                }
            }
            
        }
        
    }
    
    // MARK :- Update Location
    
    func updateLocation( lat : Double , lng : Double) -> Void{
        
        let loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
        
        // param dictionary
        var params : NSMutableDictionary = [:]
        params = [
            kid : loginInfoDictionary[kid] as! String,
            klongitude : String(lng),
            klatitude : String(lat)
        ]
        
        
        let requestURL: URL = URL(string: String(format: "%@%@",kBaseUrl,"updatelocation"))!
        
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if  index == "OK"
                    {
                        print("Location Update")
                        
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
    
    
    
    // Search API
    func searchcardAPI(){
        
        searchBar.resignFirstResponder()
        var params : NSMutableDictionary = [:]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if (appDelegate.lat == 0 && appDelegate.long == 0 && appDelegate.locality_id == "") {
            
            alertController(controller: self, title: "", message: "Please select city/location to get offers", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return
        }
        
        // if user select current location
        if (appDelegate.lat == 0 && appDelegate.long == 0) {
            params = [
                "search_for": self.searchBar.text as Any,
                klocality_id : appDelegate.locality_id
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
                        
                        let cardArray = dict[kPayload] as! NSMutableArray
                        
                        let searchViewController = self.storyboard?.instantiateViewController(withIdentifier: ksearchStoryBoardID) as? SearchViewController
                        searchViewController?.searchText = self.searchText
                        searchViewController?.cardArray  = cardArray;
                        self.navigationController?.pushViewController(searchViewController!, animated: true)
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
    
    
    
    func saveLocation(lat : String, lng : String){
        
        let infoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
        infoDictionary.setValue(String(lng), forKey: klongitude)
        infoDictionary.setValue(String(lat), forKey: klatitude)
        
        loginInfoDictionary = infoDictionary
        kUserDefault.set(NSKeyedArchiver.archivedData(withRootObject:loginInfoDictionary), forKey: kloginInfo)
    }
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kselectLocationSegueIdentifier {
            let  citySelection : SelectLocationViewController = (segue.destination as? SelectLocationViewController)!
            citySelection.delegate = self
        }
    }
    
}
