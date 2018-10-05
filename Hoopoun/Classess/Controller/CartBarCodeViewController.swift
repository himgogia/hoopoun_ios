//
//  BarCodeViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 30/10/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class cardBarCodeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

//    var walletDictionary : NSMutableDictionary!
    var  cardProviderDetailsDictionary : NSMutableDictionary!


    @IBOutlet var barCodeTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK TableView Deleage ////////////////////////////////////////////
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "cell"
        
        var cell: BarCodeCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? BarCodeCell
        
        tableView.register(UINib(nibName: "BarCodeCell", bundle: nil), forCellReuseIdentifier: identifier)
        cell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? BarCodeCell)!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.setCodeData(dictionary: self.cardProviderDetailsDictionary)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210;
    }
    


}
