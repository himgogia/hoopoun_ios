//
//  MoreViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 21/08/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var moreTable: UITableView!
    
    var loginInfoDictionary : NSMutableDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItems = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // hide review button
        let window = UIApplication.shared.keyWindow!
        let addReviewButton = window.viewWithTag(2017)
        addReviewButton?.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        
        loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary

        creatTitleView()
    }
    
    // MARK:- Set title View
    
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
            
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
                
                DispatchQueue.main.async {
                    tempImageView.image = UIImage(data: imageData as Data)
                }
            }

        }
        else{
            tempImageView.image = UIImage(named: "userPlaceHolder")
        }
        
        
        titleView.addSubview(profileButton)
        
        
        // title
        let titleLabel = UILabel()
        
        titleLabel.frame = CGRect(x:70, y: 3, width: kIphoneWidth-140, height: 36)
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.text = "More"
        titleView.addSubview(titleLabel)
        
    }
    
    // MARK TableView Deleage ////////////////////////////////////////////
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "cell"
        
        var cell: MoreCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? MoreCell
        
        tableView.register(UINib(nibName: "MoreCell", bundle: nil), forCellReuseIdentifier: identifier)
        
        cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MoreCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.accessoryType = .disclosureIndicator
        
        if indexPath.row == 0 {
            cell.logoImageView.image = UIImage(named: "OfferHistoryGray")
            cell.nameLabel.text = "Offers History"
        }
        else if indexPath.row == 1 {
            cell.logoImageView.image = UIImage(named: "MyFavouritesGray")
            cell.nameLabel.text = "My Favourites"
        }
        else if indexPath.row == 2 {
            cell.logoImageView.image = UIImage(named: "BusinessListingGray")
            cell.nameLabel.text = "Business Listing"
        }
        
      
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;  
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
        self.performSegue(withIdentifier: khistorySegueIdentifier, sender: nil)
        }
       else if indexPath.row == 1 {
            self.performSegue(withIdentifier: kmyFavoriteSegueIdentifier, sender: nil)
        }
        else if indexPath.row == 2 {
            self.performSegue(withIdentifier: kbusinessListSegueIdentifier, sender: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK Button clicked Action
    
    // Set profile image on button and its action
    func profileButton_clicked(sender :UIButton!){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let myProfileViewController = storyBoard.instantiateViewController(withIdentifier: KMyProfileController) as? MyProfileViewController
        
        self.navigationController?.pushViewController(myProfileViewController!, animated: true)
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
