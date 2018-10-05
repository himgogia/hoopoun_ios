//
//  CategoryDetailsViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 23/08/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class CategoryDetailsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var categoryDetailsTable: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    // MARK TableView Deleage ////////////////////////////////////////////
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200;
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: - Button Action

    @IBAction func segmentValueChanged(_ sender: Any) {
        
        if segment.selectedSegmentIndex == 1 {
            addFilterOption()
        }
        
    }
    
    // MARK:- Show Filter Option
    
    func addFilterOption(){
    
        
        let alert = UIAlertController(title:"Sort By", message:"", preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title:"Popular", style: UIAlertActionStyle.default, handler:{ (action: UIAlertAction!) in
        }))
        
        alert.addAction(UIAlertAction(title:"Near Me", style: UIAlertActionStyle.default, handler:{ (action: UIAlertAction!) in
        }))
        
        alert.addAction(UIAlertAction(title:"Hot Deal", style: UIAlertActionStyle.default, handler:{ (action: UIAlertAction!) in
        }))
        alert.addAction(UIAlertAction(title:"Cancel", style: UIAlertActionStyle.cancel, handler:{ (action: UIAlertAction!) in
        }))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
