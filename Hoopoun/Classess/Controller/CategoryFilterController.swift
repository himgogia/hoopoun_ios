
//  CategoryFilterController.swift
//  Hoopoun
//
//  Created by vineet patidar on 11/10/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class CategoryFilterController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var selectedCategorieDictionary : NSMutableDictionary = NSMutableDictionary()
    var subCategoryArray : NSMutableArray = NSMutableArray()
    var appDelegate:AppDelegate! = nil
    var  selectedIndex : NSInteger!
    var  selectedSubCategoryArray :NSMutableArray!
    var  selectedArray : NSMutableArray = NSMutableArray()
    
    var isCaregorySelected : Bool? = nil
    
    @IBOutlet var headerArrowImage: UIImageView!
    @IBOutlet var categoryHeaderImage: UIImageView!
    @IBOutlet var categoryNameLabel: UILabel!
    @IBOutlet var categoryFilterTable: UITableView!
    
    // Array
    var categoryArray : NSMutableArray = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.getCategoryFilterData()
    }
    
    
    
    // MARK TableView Deleage ////////////////////////////////////////////
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.categoryArray.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let key : String = (self.categoryArray.object(at: section) as? NSMutableDictionary)?.value(forKey: ksubcategoryName) as! String
        
        let sectionDict : NSMutableDictionary = (self.categoryArray.object(at: section) as? NSMutableDictionary)!
        
        var array : NSMutableArray = NSMutableArray()
        if (sectionDict.value(forKey: key) != nil) {
            array = sectionDict.value(forKey: key) as! NSMutableArray
            print(array)
        }
        
        if selectedArray .contains(sectionDict) {
            return array.count
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // header view
        let headerView: UIView =  UIView.init(frame: CGRect(x: 0, y: 0, width: kIphoneWidth, height: 40))
        headerView.backgroundColor = UIColor.white
        
        
        let checkMarkImageView : UIImageView = UIImageView.init(frame: CGRect(x: 30, y: 10, width: 20, height: 20))
        headerView.addSubview(checkMarkImageView)
        
        // Caregory name label
        let labelView: UILabel = UILabel.init(frame: CGRect(x: 60, y: 0, width: kIphoneWidth-120, height: 40))
        labelView.font = UIFont(name: "SFUIText-Regular", size: 14)
        
        headerView.addSubview(labelView);
        
        let dict:NSDictionary  = self.categoryArray.object(at: section) as! NSDictionary
        labelView.text = dict.value(forKey: "subcategoryName") as? String
        
        
        // top button
        let buttonHeader :UIButton = UIButton.init(frame:headerView.frame)
        buttonHeader.addTarget(self, action:#selector(headerButton_Clicked), for: UIControlEvents.touchUpInside)
        buttonHeader.tag = section
        headerView.addSubview(buttonHeader)
        
        // set image selection
        
        if (((self.categoryArray.object(at: section) as? NSMutableDictionary)?.value(forKey: dict.value(forKey: ksubcategoryName) as! String) as? NSMutableArray) != nil)  {
            
            let subArray :NSMutableArray = ((self.categoryArray.object(at: section) as? NSMutableDictionary)?.value(forKey: dict.value(forKey: ksubcategoryName) as! String) as? NSMutableArray)!
            
            print(subArray)
            labelView.text =  NSString(format: "%@(%d)",(dict.value(forKey: "subcategoryName") as? String)!,subArray.count) as String
            
            var setCheckMark : Bool = false
            for var i in (0..<subArray.count){
                
                let dict : NSMutableDictionary = subArray.object(at: i) as! NSMutableDictionary
                if self.selectedSubCategoryArray .contains(dict) {
                    setCheckMark = true
                }
                
            }
            if setCheckMark == true {
                checkMarkImageView.image = UIImage(named: "check")
            }
            else{
                checkMarkImageView.image = UIImage(named: "")
            }
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
        let dict : NSMutableDictionary = (self.categoryArray.object(at: indexPath.section) as! NSMutableDictionary)
        
        let subArray :NSMutableArray = ((self.categoryArray.object(at: indexPath.section) as? NSMutableDictionary)?.value(forKey: dict.value(forKey: ksubcategoryName) as! String) as? NSMutableArray)!
        
        cell.nameLabel?.text = (subArray.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: ksubsubcategories_name) as? String
        cell.nameLabel?.textColor = UIColor.darkGray
        
        if self.selectedSubCategoryArray .contains(subArray.object(at: indexPath.row) as! NSMutableDictionary) {
            cell.checkMarkImage?.image = UIImage(named: "check")
            
        }
        else{
            cell.checkMarkImage?.image = UIImage(named: "")
        }
        
        // set header image
        if self.selectedSubCategoryArray.count>0 {
            categoryHeaderImage?.image = UIImage(named: "check")
        }
        else{
            categoryHeaderImage?.image = UIImage(named: "")
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict : NSMutableDictionary = (self.categoryArray.object(at: indexPath.section) as! NSMutableDictionary)
        
        let subArray :NSMutableArray = ((self.categoryArray.object(at: indexPath.section) as? NSMutableDictionary)?.value(forKey: dict.value(forKey: ksubcategoryName) as! String) as? NSMutableArray)!
        
        
        if self.selectedSubCategoryArray.contains(subArray.object(at: indexPath.row) as! NSMutableDictionary) {
            self.selectedSubCategoryArray.remove(subArray.object(at: indexPath.row) as! NSMutableDictionary)
        }
        else{
            self.selectedSubCategoryArray.add(subArray.object(at: indexPath.row) as! NSMutableDictionary)
        }
        
        categoryFilterTable.reloadData()
        
    }
    
    // MARK: Button Clicked
    @IBAction func categoryButton_clicked(_ sender: Any) {
        
        if isCaregorySelected == true {
            categoryFilterTable.isHidden = true
            isCaregorySelected = false
            headerArrowImage.image = UIImage(named: "")
            
            
        }
        else{
            categoryFilterTable.isHidden = false
            isCaregorySelected = true
            headerArrowImage.image = UIImage(named: "downBlue")
            
        }
    }
    
    
    func headerButton_Clicked(sender : UIButton){
        
        selectedIndex = sender.tag
        let dict : NSMutableDictionary = (self.categoryArray.object(at: sender.tag) as! NSMutableDictionary)
        
        if (((self.categoryArray.object(at: selectedIndex) as? NSMutableDictionary)?.value(forKey: dict.value(forKey: ksubcategoryName) as! String) as? NSMutableArray) != nil)  {
            
            if selectedArray .contains(dict) {
                selectedArray.remove(dict)
                
            }
            else{
                selectedArray.add(dict)
                
                
            }
            categoryFilterTable.reloadData()
            
        }else{
            
            self.getSubCategory(subcategoryId:dict.value(forKey: ksubcategoryId) as! String,categoryKey:dict.value(forKey: ksubcategoryName) as! String )
            
        }
        
    }
    
    
    // MARK: APIs call
    
    func getCategoryFilterData(){
        
        if (appDelegate.lat == 0 && appDelegate.long == 0 && appDelegate.locality_id == "") {
            
            alertController(controller: self, title: "", message: "Please select city/location to get offers", okButtonTitle: "OK", completionHandler: {(index) -> Void in
                
            })
            
            return
        }
        
        
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
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"categoryFilterList")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    print(response![kCode]!)
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        print(dict[kPayload] as Any)
                        
                        let dataArray = dict.value(forKey: kPayload) as! NSMutableArray
                        
                        let filterCategoryId : String = (self.selectedCategorieDictionary.value(forKey: kcategory_id) as? String)!
                        
                        let predicateCity : NSPredicate = NSPredicate(format: "categoryId = %@",filterCategoryId)
                        
                        let filterArray  = dataArray.filtered(using: predicateCity) as NSArray
                        
                        if filterArray.count>0{
                            
                            self.categoryArray = (filterArray.object(at: 0) as! NSMutableDictionary).value(forKey: "subcategory") as! NSMutableArray
                            
                            self.categoryNameLabel.text = self.selectedCategorieDictionary.value(forKey: kcategories_name) as? String
                            
                            
                            self.categoryFilterTable.reloadData()
                            
                        }
                        
                        print(self.categoryArray)
                        
                    }
                    
                }
            }
            
        }
        
    }
    
    
    // get sub category
    
    func getSubCategory(subcategoryId : String, categoryKey:String){
        
        var params : NSMutableDictionary = [:]
        params = [
            ksubcategoryId : subcategoryId
        ]
        
        print(params)
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"subsubCategoryFilter")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    print(response![kCode]!)
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        print(dict[kPayload] as Any)
                        
                        
                        let dataArray = dict.value(forKey: kPayload) as! NSMutableArray
                        
                        
                        (((self.categoryArray.object(at: Int(self.selectedIndex))) as? NSMutableDictionary)!).setValue(dataArray, forKey: categoryKey)
                        
                        print(self.subCategoryArray)
                        print(self.categoryArray)
                        
                        self.selectedArray = NSMutableArray(array: self.categoryArray)
                        
                        self.categoryFilterTable.reloadData()
                        
                    }
                    else{
                        
                        let message = dict[kMessage]
                        
                        alertController(controller: self, title: "", message:message! as! String, okButtonTitle: "OK", completionHandler: {(index) -> Void in
                            
                        })
                    }
                }
                
            }
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
