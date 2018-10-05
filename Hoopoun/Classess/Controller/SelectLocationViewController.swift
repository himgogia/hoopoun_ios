//
//  SelectLocationViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 10/10/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

protocol  cityDelegate {
    func passSelectedCityData( dict : NSDictionary, isNearBy: Bool)
}
class SelectLocationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    @IBOutlet var nearMeViewHeight: NSLayoutConstraint!
    
   
    @IBOutlet var searchbar: UISearchBar!
    var pageNumber : NSString!
    var delegate: cityDelegate!
    var loading : Bool = false
    var fromViewController : NSString = ""
    var selectedLocalityDictionary : NSMutableDictionary!
    var isSearing : Bool = false
    
    
    var popularCityArray : NSMutableArray = NSMutableArray()
    var cityArray : NSMutableArray = NSMutableArray()
    var locationLocalArray : NSMutableArray!
    var appDelegate : AppDelegate! = nil
    
    
    
    @IBOutlet var locationTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        isSearing = false
        
        if kUserDefault.value(forKey: klocationLocalData) != nil {
            let array : NSArray  =  (kUserDefault.value(forKey: klocationLocalData) as? NSArray)!
            locationLocalArray  = NSMutableArray(array: array)
        }
        else{
            locationLocalArray = NSMutableArray()
        }
      
        
        

        self.navigationItem.title = "Select Location"
        
        if self.fromViewController  == "MyProfile" {
            nearMeViewHeight.constant = 0
        }
        
        // change search bar text and place holder color
        if let txfSearchField = searchbar.value(forKey: "_searchField") as? UITextField {
            txfSearchField.borderStyle = .none
            txfSearchField.layer.cornerRadius = 5.0
            txfSearchField.layer.masksToBounds = true
            txfSearchField.backgroundColor = .white
        }

        
        pageNumber = "1"
        // get city list
        self.getCityList()
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        searchbar.resignFirstResponder()
            locationTable.frame.size.height = kIphoneHeight-110
    }
    
    func keyboardWillChange(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if searchbar.isFirstResponder {
                locationTable.frame.size.height = kIphoneHeight-(keyboardSize.height+110)
            }
        }
    }
    
    // MARK TableView Deleage ////////////////////////////////////////////
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if isSearing == false {
            return 1
        }
        return self.cityArray.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        if isSearing == false {
            return locationLocalArray.count
        }
        let dict : NSDictionary = self.cityArray.object(at: section ) as! NSDictionary
        return (dict.value(forKey: klocality) as AnyObject).count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView: UIView =  UIView.init(frame: CGRect(x: 0, y: 0, width: kIphoneWidth, height: 45))
        headerView.backgroundColor = UIColor(red: 237.0/255.0, green: 237.0/255.0, blue: 237.0/255.0, alpha: 1)
        let labelView: UILabel = UILabel.init(frame: CGRect(x: 10, y: 0, width: kIphoneWidth-20, height: 44))
        labelView.font = UIFont.boldSystemFont(ofSize: 14)
        headerView.addSubview(labelView);

        if isSearing == false {
            labelView.text = "SEARCH HISTORY"
        }
        else
        {
            let dict : NSDictionary = (self.cityArray.object(at: section ) as! NSDictionary).value(forKey: kcity) as! NSDictionary
            labelView.text = dict.value(forKey: kcityName) as? String
   
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "cell"
        
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: identifier)
        cell.textLabel?.textColor = UIColor.lightGray
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        // set city name and locality
        
        
        if isSearing == false {
           
            let localityDict : NSDictionary = locationLocalArray.object(at: indexPath.row) as! NSDictionary
            cell.textLabel?.text = (localityDict.value(forKey: kLocality) as! String)
        }
        else{
            let dict : NSDictionary = self.cityArray.object(at: indexPath.section ) as! NSDictionary
            let localityArray : NSArray =  dict.value(forKey: klocality) as! NSArray
            let localityDict : NSDictionary = localityArray.object(at: indexPath.row) as! NSDictionary
            cell.textLabel?.text = (localityDict.value(forKey: kLocality) as! String)
            
            if selectedLocalityDictionary == localityDict {
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryType.none
            }
        }
    
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45;
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isSearing == false {
            
            selectedLocalityDictionary = locationLocalArray.object(at: indexPath.row) as! NSMutableDictionary
            self.delegate.passSelectedCityData(dict:selectedLocalityDictionary, isNearBy: false)
            self.navigationController?.popViewController(animated: true)
           
        }
        else {
        
            let dict : NSDictionary = self.cityArray.object(at: indexPath.section ) as! NSDictionary
            let localityArray : NSArray =  dict.value(forKey: klocality) as! NSArray
            selectedLocalityDictionary = localityArray.object(at: indexPath.row) as! NSMutableDictionary
            
            if  !locationLocalArray.contains(selectedLocalityDictionary) {
                locationLocalArray.add(selectedLocalityDictionary)
                kUserDefault.setValue(locationLocalArray, forKey: klocationLocalData)
                
            }
            
            self.delegate.passSelectedCityData(dict:selectedLocalityDictionary, isNearBy: false)
            self.navigationController?.popViewController(animated: true)
        }
       
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let endScrolling:CGFloat = scrollView.contentOffset.y +   scrollView.frame.size.height
        
        if(endScrolling >= scrollView.contentSize.height-5){
            
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            self.perform(#selector(self.getCityList), with: nil, afterDelay: 3.0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nearMeButton_clicked(_ sender: Any) {
        self.delegate.passSelectedCityData(dict:self.cityArray.object(at:0) as! NSDictionary, isNearBy: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backButton_clicked(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    /// MARK :// SearchBar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print(searchText)
        
        pageNumber = "1"
        isSearing = true
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.perform(#selector(self.getCityList), with: nil, afterDelay: 0.5)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchbar.resignFirstResponder()
    }
    
    // MARK - APIs Call
    
    func getCityList(){
        
        var params : NSMutableDictionary = [:]
        
        
        params = [
            kpage_no : pageNumber,
            kkeyword : self.searchbar.text as Any
        ]
        
        print(params)
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"get_city_locality_list")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        
                        if (self.pageNumber).integerValue == 1 {
                            self.cityArray.removeAllObjects()
                            self.cityArray = (dict[kPayload] as? NSMutableArray)!
                        }
                            
                        else{
                            let filterArray  = (dict[kPayload] as? NSMutableArray)!
                            self.cityArray.addObjects(from: filterArray as! [Any])
                        }
                        
                        let myInt = (self.pageNumber).integerValue
                        self.pageNumber = String (myInt+1) as NSString
                        
                        self.locationTable.reloadData()
                    }
                    else
                    {
                        
                        self.cityArray.removeAllObjects()
                        self.locationTable.reloadData()


                        
                    }
                }
            }
                
            else {
                
                // show alert
            }
            
        }
        
    }
    
    func archiveLocationData(filename :String, array:NSArray){
        
        let data = NSKeyedArchiver.archivedData(withRootObject: array)
        let fullPath = getDocumentsDirectory().appendingPathComponent(filename)
        
        do {
            try data.write(to: fullPath)
        } catch {
            print("Couldn't write file")
        }
    }
    
    func unArchiveLocationData(fileName :String)-> NSArray{
        
        let fullPath = getDocumentsDirectory().appendingPathComponent(fileName)
        
        let loadedStrings = NSKeyedUnarchiver.unarchiveObject(withFile: fullPath.absoluteString) as? [String]
        
        return loadedStrings as Any as! NSArray
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
