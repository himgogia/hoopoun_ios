//
//  CategoryOfferViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 09/10/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}

class CategoryOfferViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate,offerFilterDelegate {
    
    var selectedCategorieDictionary : NSMutableDictionary = NSMutableDictionary()
    var  selectedSubCategoryArray :NSMutableArray = NSMutableArray()
    var  selectedSubLocationArray :NSMutableArray = NSMutableArray()
    var categoryOffersArray : NSMutableArray = NSMutableArray()
    
    @IBOutlet var locationButton: UIButton!
    var offersShortBy : String!
    var searchText : NSString = ""
    
    var listSelected : Bool = true
    var showhude : Bool = true

    var selectedAnnonationIndex : NSInteger = 0
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var categoryDetailsTable: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
         self.locationButton.isHidden = true
        
        self.offersShortBy = ""
        mapView.isHidden = true
        showhude = true
        categoryDetailsTable.isHidden = false
        
        // set title
        self.navigationItem.title = selectedCategorieDictionary.value(forKey: kcategories_name) as? String
        
        // change search bar text and place holder color
        if let txfSearchField = searchBar.value(forKey: "_searchField") as? UITextField {
            txfSearchField.borderStyle = .none
            txfSearchField.layer.cornerRadius = 5.0
            txfSearchField.layer.masksToBounds = true
            txfSearchField.backgroundColor = .white
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.searchBar.text = ""
        self.segment.selectedSegmentIndex = UISegmentedControlNoSegment
        
        self.getCategoryOffers()
    }
    
    // MARK TableView Deleage ////////////////////////////////////////////
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.categoryOffersArray.count
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
        
        var cell: CategoryDetailCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? CategoryDetailCell
        
        tableView.register(UINib(nibName: "CategoryDetailCell", bundle: nil), forCellReuseIdentifier: identifier)
        cell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? CategoryDetailCell)!
        cell.selectionStyle = UITableViewCellSelectionStyle.none

        cell.backgroundColor = UIColor.clear
        if (self.navigationController != nil) {
            cell.nav = self.navigationController
        }
        cell.collectionView.reloadData()
        print((self.categoryOffersArray.object(at: indexPath.section) as! NSDictionary).value(forKey: "store") as! NSMutableArray)
        cell.storeArray = (self.categoryOffersArray.object(at: indexPath.section) as! NSDictionary).value(forKey: "store") as! NSMutableArray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let catArray : NSArray = (self.categoryOffersArray.object(at: indexPath.section) as! NSDictionary).value(forKey: "store") as! NSArray
        let dict : NSMutableDictionary =  catArray.object(at: indexPath.row) as! NSMutableDictionary
        let offetType : String = (dict.value(forKey: kofferTitle) as? String)!
        
        let storeName :String = (dict.value(forKey: kstore_name) as? String)!
        let address = String(format: "%@ %@",storeName,(dict.value(forKey: kaddress) as? String)!)
        
        var height :Float = Float(calculateHeightForlblTextWithFont(offetType, _width: (kIphoneWidth-125), font: UIFont(name: "SFUIText-Semibold", size: 12)!))
        
        height = Float(calculateHeightForlblTextWithFont(address, _width: (kIphoneWidth-135), font: UIFont(name: "SFUIText-Regular", size: 12)!)) + height
        
        return 265;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }     
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Button Action
    
    @IBAction func backButton_clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func segmentValueChanged(_ sender: Any) {
        
        if segment.selectedSegmentIndex == 0 {
            self.performSegue(withIdentifier: kfiltersegieIdentifier, sender: self.selectedCategorieDictionary)
        }
        else  if segment.selectedSegmentIndex == 1 {
            addFilterOption()
        }
        else  if segment.selectedSegmentIndex == 2 {
            
            if  mapView.isHidden == false {
                mapView.isHidden = true
                categoryDetailsTable.isHidden = false
                segment.setImage(UIImage(named : "mapimg"), forSegmentAt: 2)
                self.locationButton.isHidden = true

            }
            else{
                mapView.isHidden = false
                categoryDetailsTable.isHidden = true
              segment.setImage(UIImage(named : "list"), forSegmentAt: 2)
                let allAnnotations = self.mapView.annotations
                self.mapView.removeAnnotations(allAnnotations)
                self.locationButton.isHidden = true

                showPinOnMap()
            }
            self.segment.selectedSegmentIndex = UISegmentedControlNoSegment
        }
    }
    
    // MARK-: Search button clicked
    @IBAction func searchButton_Clicked(_ sender: Any) {
        
        let searchViewController = self.storyboard?.instantiateViewController(withIdentifier: ksearchStoryBoardID) as? SearchViewController
        self.navigationController?.pushViewController(searchViewController!, animated: true)
    }
    
    // MARK :- Offer filter delegate by Category and Location
    
    func filterOfferByCategoryAndLocation(){
        self.getCategoryOffers()
    }
    
    // MARK:- Show Filter Option
    
    func addFilterOption(){
        
    let alert = UIAlertController(title:"Sort By", message:"", preferredStyle: UIAlertControllerStyle.actionSheet)
        
     let sortByPopular =  UIAlertAction(title:"Popular", style: UIAlertActionStyle.default, handler:{ (action: UIAlertAction!) in
            
            self.offersShortBy = "1"
            self.getCategoryOffers()
            self.segment.selectedSegmentIndex = UISegmentedControlNoSegment
            
        })
        
    let sortByNearMe = UIAlertAction(title:"Near Me", style: UIAlertActionStyle.default, handler:{ (action: UIAlertAction!) in
            self.offersShortBy = "2"
            self.segment.selectedSegmentIndex = UISegmentedControlNoSegment
            self.getCategoryOffers()
            
        })
        
       let sortByHotDeal =  UIAlertAction(title:"Hot Deal", style: UIAlertActionStyle.default, handler:{ (action: UIAlertAction!) in
            
            self.segment.selectedSegmentIndex = UISegmentedControlNoSegment
            self.offersShortBy = "3"
            self.getCategoryOffers()
            
        })
        
    let sortByCancel =  UIAlertAction(title:"Cancel", style: UIAlertActionStyle.cancel, handler:{ (action: UIAlertAction!) in
            self.segment.selectedSegmentIndex = UISegmentedControlNoSegment
            
        })
        
        sortByPopular.setValue(UIImage(named: "Popular"), forKey: "image")
        sortByNearMe.setValue(UIImage(named: "NearMe"), forKey: "image")
        sortByHotDeal.setValue(UIImage(named: "HotDeals"), forKey: "image")

        alert.addAction(sortByPopular)
        alert.addAction(sortByNearMe)
        alert.addAction(sortByHotDeal)
        alert.addAction(sortByCancel)
        
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = kLightBlueColor

        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: Show pin on map
    func showPinOnMap(){
        
        for dict in self.categoryOffersArray {
            
            let dictFilter : NSMutableDictionary = (dict as? NSMutableDictionary)!
            
            let storeDictionary : NSMutableDictionary = ((dictFilter.value(forKey: "store") as? NSMutableArray)!.object(at: 0) as? NSMutableDictionary)!
            
            
            let latString : NSString = (storeDictionary.value(forKey: klatitude) as? NSString)!
            
            let lngString : NSString = (storeDictionary.value(forKey: klongitude) as? NSString)!
            
            let lat : Double = Double(latString as String)!
            let lng : Double = Double(lngString as String)!
            let title :String = storeDictionary.value(forKey: kstore_name) as! String
            
            let objectAnnotation = CustomPointAnnotation()
            
            let latDelta:CLLocationDegrees = 0.250
            let longDelta:CLLocationDegrees = 0.250
            
            let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
            let pointLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat,lng)
            
            let region:MKCoordinateRegion = MKCoordinateRegionMake(pointLocation, theSpan)
            mapView.setRegion(region, animated: true)
            
            let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat,lng)
            
            
            objectAnnotation.coordinate = pinLocation
            objectAnnotation.title = title
            objectAnnotation.imageName = "mapPercent"
            self.mapView.addAnnotation(objectAnnotation)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "annonation"
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView?.canShowCallout = true
        }
        else {
            anView?.annotation = annotation
        }
        
        let cpa = annotation as! CustomPointAnnotation
        anView?.image = UIImage(named:cpa.imageName)
        
        return anView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.locationButton.isHidden = false
        let annotation = view.annotation
         selectedAnnonationIndex = (self.mapView.annotations as NSArray).index(of: annotation!)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.locationButton.isHidden = true
    }
    
    // MARK: - Search bar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text != "" {
            
            self.searchText = searchBar.text! as NSString
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.searchcardAPI), object: nil)
            self.perform(#selector(self.searchcardAPI), with: nil, afterDelay: 3.0)
        }
        else{
            
            
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    @IBAction func locationButton_clicked(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        
        let storeArray : NSArray = ((self.categoryOffersArray.object(at: selectedAnnonationIndex)) as AnyObject).value(forKey: "store") as! NSArray
        var storeDictionary = NSMutableDictionary()
        
        if storeArray.count > 0 {
            storeDictionary = storeArray.object(at: 0) as! NSMutableDictionary
            
            let latitude : String = storeDictionary.value(forKey: klatitude) as! String
            let longitude : String = storeDictionary.value(forKey: klongitude) as! String
            
            let latitudeDouble : Double =  Double(latitude)!
            let longitudeDouble : Double = Double(longitude)!


            // Navigate from one coordinate to another
            let url = "http://maps.apple.com/maps?saddr=\(appDelegate.lat),\(appDelegate.long)&daddr=\( latitudeDouble),\(longitudeDouble)"
            UIApplication.shared.openURL(URL(string:url)!)
        }
        

    }
    
    // MARK: APIS Call
    
    // Get Category Offer
    func getCategoryOffers(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // get filter category ids
        var filterCategoryIds : String = "[]"
        
        if self.selectedSubCategoryArray.count>0 {
            let catArray :NSArray = self.selectedSubCategoryArray.value(forKey: "subsubCatId") as! NSArray
            
            
            do {
                
                let jsonData = try JSONSerialization.data(withJSONObject: catArray, options: JSONSerialization.WritingOptions.prettyPrinted)
                if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                    filterCategoryIds = JSONString
                }
            }
            catch {
            }
            
        }
        
        // get filter location ids
        var filterLocationIds : String = "[]"
        
        if self.selectedSubLocationArray.count>0 {
            let locArray :NSArray = self.selectedSubLocationArray.value(forKey: klocalityId) as! NSArray
            
            do {
                
                let jsonData = try JSONSerialization.data(withJSONObject: locArray, options: JSONSerialization.WritingOptions.prettyPrinted)
                if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                    filterLocationIds = JSONString
                }
            }
            catch {
            }
        }
        
        var params : NSMutableDictionary = [:]
        
        
        if (appDelegate.lat == 0 && appDelegate.long == 0) {
            
            params = [
                klocality_id : appDelegate.locality_id,
                kfilter_categories : filterCategoryIds,
                kfilter_location : filterLocationIds,
                ksort_by : self.offersShortBy,
                kcat_id :self.selectedCategorieDictionary.value(forKey:"category_id") as Any
            ]
        }
        else{
            params = [
                
                klatitude: String(appDelegate.lat),
                klongitude: String(appDelegate.long),
                kfilter_categories : filterCategoryIds,
                kfilter_location : filterLocationIds,
                ksort_by : self.offersShortBy,
                kcat_id :self.selectedCategorieDictionary.value(forKey:"category_id") as Any
                
            ]
        }
        
        print(params)
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"categoryOffer_new")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: showhude, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    print(response![kCode]!)
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    
                    if index == "200"{
                        print(dict[kPayload] as Any)
                        
                        let payLoadDictionary = (dict[kPayload]) as! NSMutableDictionary
                        self.showhude = false
                        self.categoryOffersArray = payLoadDictionary.value(forKey: "merchant") as! NSMutableArray
                        
                        if self.mapView.isHidden == false {
                            let allAnnotations = self.mapView.annotations
                            self.mapView.removeAnnotations(allAnnotations)
                            self.showPinOnMap()
                        }
                        
                        self.categoryDetailsTable.reloadData()
                    }
                    else
                    {
                        let message = dict[kMessage]
                        
                        alertController(controller: self, title: "", message:message! as! String, okButtonTitle: "OK", completionHandler: {(index) -> Void in
                            
                            self.categoryOffersArray.removeAllObjects()
                            self.categoryDetailsTable.reloadData()
                        })
                        
                    }
                }
            }
            else {
                
                // show alert
            }
        }
        
    }
    
    
    // Search offer
    func searchcardAPI(){
        
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
                klocality_id : appDelegate.locality_id,
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
                        searchViewController?.cardArray  = cardArray;
                        searchViewController?.searchText = self.searchText
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == kfiltersegieIdentifier {
            
            let filterSliderViewController : FilterSliderViewController = segue.destination as! FilterSliderViewController
            filterSliderViewController.selectedCategorieDictionary = sender as! NSMutableDictionary
            filterSliderViewController.selectedSubCategoryArray = self.selectedSubCategoryArray
            filterSliderViewController.selectedSubLocationArray = self.selectedSubLocationArray
            filterSliderViewController.delegate = self
        }
    }
    
    
}
