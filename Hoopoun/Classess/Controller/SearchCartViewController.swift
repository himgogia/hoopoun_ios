//
//  SearchcardViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 31/10/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class SearchcardViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var cardSearchTable: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    var appDelegate : AppDelegate! = nil

    var cardArray : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate

        // change search bar text and place holder color
        if let txfSearchField = searchBar.value(forKey: "_searchField") as? UITextField {
            txfSearchField.borderStyle = .none
            txfSearchField.layer.cornerRadius = 5.0
            txfSearchField.layer.masksToBounds = true
            txfSearchField.backgroundColor = .white
        }
    }

   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK TableView Deleage ////////////////////////////////////////////
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return  0.001
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if appDelegate.userType == kguestUser {
             return cardArray.count
        }
        
        if section == 1 {
            return cardArray.count
        }
        else{
        return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        if appDelegate.userType == kguestUser {
            let cardDict : NSMutableDictionary = cardArray[indexPath.row] as! NSMutableDictionary
            cell.textLabel?.text = cardDict.value(forKey: kProgramName) as? String
        }
        else {
            if indexPath.section == 1 {
                let cardDict : NSMutableDictionary = cardArray[indexPath.row] as! NSMutableDictionary
                cell.textLabel?.text = cardDict.value(forKey: kProgramName) as? String
            }
            else{
                cell.textLabel?.text = "Other"
            }
        }
        
       
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if appDelegate.userType == kguestUser {
            self.performSegue(withIdentifier: kphysicalcardSegueIdentifier, sender: self.cardArray[indexPath.row])
        }
        else{
            if indexPath.section == 1 {
                self.performSegue(withIdentifier: kphysicalcardSegueIdentifier, sender: self.cardArray[indexPath.row])
            }
            else{
                self.performSegue(withIdentifier: kothercardSegueIdentifier, sender: "Other")
            }
        }
       
    }
    
    // MARK: - Search bar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text != "" {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.getSearchText), object: nil)
            self.perform(#selector(self.getSearchText), with: nil, afterDelay: 3.0)
        }
        else{
        
          //  cardSearchTable.isHidden = true
            cardArray.removeAllObjects()
            cardSearchTable.reloadData()
        }
    }
    
    // APIs call for search text
    func getSearchText() {
        
     self.searchBar.resignFirstResponder()
     self.searchcardAPI()
    }
    
    
    // Search API
    func searchcardAPI(){
        
        var params : NSMutableDictionary = [:]
        
        params = [
            "searchstr": self.searchBar.text as Any,
        ]
        
        print(params)
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"searchCard")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    print(response![kCode]!)
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {

                        print(dict[kPayload] as Any)
                        
                        self.cardArray = dict[kPayload] as! NSMutableArray
                        
                        if self.cardArray.count>0{
                        self.cardSearchTable.isHidden = false
                        self.cardSearchTable.reloadData()

                        }
                        else{
                            self.cardArray.removeAllObjects()
                            self.cardSearchTable.isHidden = false
                            self.cardSearchTable.reloadData()


                        }
                    }
                    else
                    {
                        let message = dict[kMessage]
                        self.cardSearchTable.isHidden = false
                        self.cardArray.removeAllObjects()
                        self.cardSearchTable.reloadData()


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

    // MARK:- Button clicked
    @IBAction func backButton_clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == kphysicalcardSegueIdentifier {
            let physicalcardViewController = segue.destination as? PhysicalcardViewController
            physicalcardViewController?.selectedcardDictionary = sender as? NSMutableDictionary
        }
    }
    
    
}
