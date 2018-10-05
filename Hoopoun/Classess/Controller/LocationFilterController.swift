//
//  LocationFilterController.swift
//  Hoopoun
//
//  Created by vineet patidar on 11/10/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class LocationFilterController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var selectedCategorieDictionary : NSMutableDictionary = NSMutableDictionary()
    var appDelegate:AppDelegate! = nil
    var  selectedIndex : NSInteger!
    var  selectedSubLocationArray :NSMutableArray!
    var  selectedHeaderArray : NSMutableArray = NSMutableArray()
    
    
    
    @IBOutlet var locationFilterTable: UITableView!
    // Array
    var locationArray : NSMutableArray = NSMutableArray()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getLocationFilterData()
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK TableView Deleage ////////////////////////////////////////////
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.locationArray.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let dict : NSMutableDictionary = (self.locationArray.object(at: section) as! NSMutableDictionary)
        
        if selectedHeaderArray.contains(dict) {
            if (self.locationArray.count>0)  {
                
                let tempArray : NSMutableArray = (self.locationArray.object(at: section) as? NSMutableDictionary)?.value(forKey: klocality) as! NSMutableArray
                return tempArray.count
            }
        }
        
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // header view
        let headerView: UIView =  UIView.init(frame: CGRect(x: 0, y: 0, width: kIphoneWidth, height: 40))
        headerView.backgroundColor = UIColor.white
        
        
        let checkMarkImageView : UIImageView = UIImageView.init(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        headerView.addSubview(checkMarkImageView)
        
        // Location name label
        let labelView: UILabel = UILabel.init(frame: CGRect(x: 40, y: 0, width: kIphoneWidth-100, height: 40))
        labelView.font = UIFont.boldSystemFont(ofSize: 14)
        headerView.addSubview(labelView);
        
        // Arrow image
        let arrowImage : UIImageView = UIImageView.init(frame: CGRect(x: kIphoneWidth-40, y: 10, width: 20, height: 20))
        headerView.addSubview(arrowImage)
        
        let dict : NSMutableDictionary = (self.locationArray.object(at: section) as! NSMutableDictionary)
        
        if selectedHeaderArray.contains(dict) {
            arrowImage.image = UIImage(named: "downBlue")
        }
        else{
            arrowImage.image = UIImage(named: "")
        }
        
        if self.locationArray.count>0 {
            
            let tempArray : NSMutableArray = (self.locationArray.object(at: section) as? NSMutableDictionary)?.value(forKey: klocality) as! NSMutableArray

            
            let cityName : String = (self.locationArray.object(at: section) as? NSMutableDictionary)?.value(forKey: kcityName) as! String
            
            labelView.text =  NSString(format: "%@(%d)",cityName,tempArray.count) as String
            
        }
        
        
        // top button
        let buttonHeader :UIButton = UIButton.init(frame:headerView.frame)
        buttonHeader.addTarget(self, action:#selector(headerButton_Clicked), for: UIControlEvents.touchUpInside)
        buttonHeader.tag = section
        headerView.addSubview(buttonHeader)
        
        
        // set header image
        if self.selectedSubLocationArray.count>0 {
            checkMarkImageView.image = UIImage(named: "check")
        }
        else{
            checkMarkImageView.image = UIImage(named: "")
        }
        
        
        // line view
        let lineView : UIView =  UIView.init(frame: CGRect(x: 30, y: 39, width: kIphoneWidth-30, height: 1))
        lineView.backgroundColor = UIColor(red: 237.0/255.0, green: 237.0/255.0, blue: 237.0/255.0, alpha: 1)
        headerView.addSubview(lineView)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "cell"
        
        
        var cell: LocationFilterCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? LocationFilterCell
        
        tableView.register(UINib(nibName: "LocationFilterCell", bundle: nil), forCellReuseIdentifier: identifier)
        cell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? LocationFilterCell)!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        // set image selection
        
        if (self.locationArray.count>0)  {
            
            let tempArray : NSMutableArray = (self.locationArray.object(at: indexPath.section) as? NSMutableDictionary)?.value(forKey: klocality) as! NSMutableArray
            
            let dict : NSMutableDictionary = (tempArray.object(at: indexPath.row) as! NSMutableDictionary)
            
            
            cell.nameLabel?.text = dict.value(forKey: "Locality") as? String
            cell.nameLabel?.textColor = UIColor.darkGray
            
            if self.selectedSubLocationArray .contains(tempArray.object(at: indexPath.row) as! NSMutableDictionary) {
                cell.checkMarkImage?.image = UIImage(named: "check")
                
            }
            else{
                cell.checkMarkImage?.image = UIImage(named: "")
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40;
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tempArray : NSMutableArray = (self.locationArray.object(at: indexPath.section) as? NSMutableDictionary)?.value(forKey: klocality) as! NSMutableArray
        
        let dict : NSMutableDictionary = (tempArray.object(at: indexPath.row) as! NSMutableDictionary)
        
        if self.selectedSubLocationArray.contains(dict) {
            self.selectedSubLocationArray.remove(dict )
        }
        else{
            self.selectedSubLocationArray.add(dict)
        }
        
        locationFilterTable.reloadData()
        
    }
    
    
    // MARK: - Button Clicked
    
    func headerButton_Clicked(sender : UIButton){
        
                 selectedIndex = sender.tag
                let dict : NSMutableDictionary = (self.locationArray.object(at: sender.tag) as! NSMutableDictionary)
        
        if selectedHeaderArray.contains(dict) {
            selectedHeaderArray.remove(dict)
        }
        else{
            selectedHeaderArray.add(dict)
        }
        locationFilterTable.reloadData()
    }
    
    
    // MARK: APIs call
    
    func getLocationFilterData(){
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        var params : NSMutableDictionary = [:]
        
        
        if (appDelegate.lat == 0 && appDelegate.long == 0) {
            
            params = [
                kid : appDelegate.locality_id
            ]
        }
        else{
            params = [
                klatitude: String(appDelegate.lat),
                klongitude: String(appDelegate.long),
            ]
        }
        
        print(params)
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"categoryLocation")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: false, showSystemError: false, loadingText: false, params: params) { (response: NSDictionary?) in
            
            if (response != nil) {
                
                DispatchQueue.main.async {
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        print(dict[kPayload] as Any)
                        
                        self.locationArray = dict.value(forKey: kPayload) as! NSMutableArray
                        print(self.locationArray)
                        
                        let dict : NSMutableDictionary = (self.locationArray.object(at:0) as! NSMutableDictionary)
                            self.selectedHeaderArray.add(dict)
                        
                        
                        self.locationFilterTable.reloadData()                        
                    }
                    
                }
            }
            
        }
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
