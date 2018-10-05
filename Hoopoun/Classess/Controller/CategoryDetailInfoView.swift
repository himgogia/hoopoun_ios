//
//  CategoryDetailInfoView.swift
//  Hoopoun
//
//  Created by vineet patidar on 13/10/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit
import MapKit

class CategoryDetailInfoView:  UITableViewController,MKMapViewDelegate {
    @IBOutlet var storeAddressLabel: UILabel!
    @IBOutlet var storeRatingView: FloatRatingView!
    @IBOutlet var storeTimmingLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var mapView: MKMapView!

    @IBOutlet var categoryInfoTable: UITableView!
    
    @IBOutlet var callButton: UIButton!
    @IBOutlet var locationButton: UIButton!
    
    var  offerDictionary : NSMutableDictionary!
    var selectedStoreId : String = ""

    var phoneNumberString : String = ""
    // MARK: - Table view data source
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        self.locationButton.isHidden = true

        
        refreshControl?.addTarget(self,
                                  action: #selector(handleRefresh(_:)),
                                  for: UIControlEvents.valueChanged)
        
    }
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        self.perform(#selector(self.endRefresh), with: nil, afterDelay: 1.0)
    }
    
    @objc func endRefresh() {
        refreshControl?.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getStoreInfo()
    }
    
    //MARK:- APIS CALL
    func getStoreInfo(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
        
        let dict : NSMutableDictionary = (offerDictionary.value(forKey: "offer_detail") as? NSMutableDictionary)!
        
//        var storIdString : String = (dict.value(forKey: kstoreId) as? String)!
//        let storeIds : NSArray = storIdString.components(separatedBy: ",") as NSArray
//
//        if storeIds.count > 0 {
//            storIdString = storeIds[0] as! String
//        }
//        else{
//
//            storIdString = ""
//        }
      
        var params : NSMutableDictionary = [:]
        
        
        if (appDelegate.lat != 0 && appDelegate.long != 0) {
            
            params = [
                klatitude: appDelegate.lat,
                klongitude: appDelegate.long,
                kstore_id : self.selectedStoreId,
                koffer_id : dict.value(forKey: koffer_id)!
            ]
        }
        else{
            params = [
                klocality_id : appDelegate.locality_id,
                kstore_id : self.selectedStoreId,
                koffer_id : dict.value(forKey: koffer_id)!]
        }
        
        print(params)
        
       let baseUrl = String(format: "%@%@",kBaseUrl,"storeInfo")

        
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        print(dict[kPayload] as Any)
                        
                        self.setInitialData(infoDict:dict[kPayload] as! NSMutableDictionary)
                    }
                    
                }
            }
            
        }
        

    }
    
    
    func setInitialData(infoDict:NSMutableDictionary){
    
        let  infoDictionary : NSMutableDictionary = infoDict.value(forKey: "store_info") as! NSMutableDictionary
        
        if infoDictionary.isKind(of: NSMutableDictionary.self) {
            // Address
            self.storeAddressLabel.text = infoDictionary.value(forKey: kaddress) as? String
            
            // rating
            let rating = infoDictionary.value(forKey:"store_rating") as? String
            let ratingInFlot : Float =  Float(rating!)!
            storeRatingView.rating = Double(ratingInFlot)
            
            // store timming
            
            var  offersTimmingString  = ""
            if (self.offerDictionary != nil) {
                
                let offers_timming: NSMutableArray = infoDict.value(forKey: "store_timming" ) as! NSMutableArray
                
                let timingArray : NSMutableArray =  NSMutableArray()
                for dict in offers_timming {
                    let tempString = String(format: "%@ - %@",(dict as AnyObject).value(forKey: kdayname) as! CVarArg,(dict as AnyObject).value(forKey: ktimming) as! CVarArg)
                    timingArray.add(tempString)
                }
                
                offersTimmingString = timingArray.componentsJoined(by: ", ")
                    
                }
            
             self.storeTimmingLabel.text = offersTimmingString
            
            // phone Numbe
            
            phoneNumberString = (infoDictionary.value(forKey:"MobileNumber") as? String)!
            
            // show store location on map
            self.showPinOnMap(dictInfo: infoDict)
        }
        
    
    }
    
     //MARK : Table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        
        cell.textLabel?.text = "Row " + String((indexPath as NSIndexPath).row)
        
        return cell
    }
    
    func viewForObserve() -> UIView{
        
        return self.tableView
    }
    
    
    // MARK: Show pin on map
    func showPinOnMap(dictInfo : NSMutableDictionary){
        
        let  infoDictionary : NSMutableDictionary = dictInfo.value(forKey: "store_info") as! NSMutableDictionary

            let latString : NSString = (infoDictionary.value(forKey: klatitude) as? NSString)!
            
            let lngString : NSString = (infoDictionary.value(forKey: klongitude) as? NSString)!
            
            let lat : Double = Double(latString as String)!
            let lng : Double = Double(lngString as String)!
            let title :String = infoDictionary.value(forKey: kstore_name) as! String
            
        
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
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.locationButton.isHidden = true
    }
    
    //MARK:- Button clicked
    
    
    @IBAction func locationButton_clicked(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if offerDictionary.count > 0 {
              let dict : NSMutableDictionary = (offerDictionary.value(forKey: "offer_detail") as? NSMutableDictionary)!
            
            let latitude : String = dict.value(forKey: klatitude) as! String
            let longitude : String = dict.value(forKey: klongitude) as! String
            
            let latitudeDouble : Double =  Double(latitude)!
            let longitudeDouble : Double = Double(longitude)!
            
            let googleURL = NSURL(string: "comgooglemaps://?q=")

            
            if(UIApplication.shared.canOpenURL(googleURL! as URL)) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string:"comgooglemaps://?saddr=\(appDelegate.lat),\(appDelegate.long)&daddr=\(latitudeDouble),\(longitudeDouble)&directionsmode=driving")!, options: [:], completionHandler: nil)
                } else {

                    // Navigate from one coordinate to another
                    let url = "http://maps.apple.com/maps?saddr=\(appDelegate.lat),\(appDelegate.long)&daddr=\( latitudeDouble),\(longitudeDouble)"
                    UIApplication.shared.openURL(URL(string:url)!)
                }
            }else {
                
                // Navigate from one coordinate to another
                let url = "http://maps.apple.com/maps?saddr=\(appDelegate.lat),\(appDelegate.long)&daddr=\( latitudeDouble),\(longitudeDouble)"
                UIApplication.shared.openURL(URL(string:url)!)
            }
            
         
        }
        
        
    }
    @IBAction func callButton_Clicked(_ sender: Any) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumberString)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
}
