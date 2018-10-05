//
//  walletHeaderDetailsViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 30/10/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class walletHeaderDetailsViewController: UIViewController {
    
    
    @IBOutlet var favouriteButton: UIButton!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var bannerImage: UIImageView!
    
//    var walletDictionary : NSMutableDictionary!
    var  cardProviderDetailsDictionary : NSMutableDictionary!
    
    
    var isFav : String!
    
    
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        
        if (cardProviderDetailsDictionary.value(forKey: kcard_image) != nil) {
            
            
            let appdelegate = UIApplication.shared.delegate as? AppDelegate
            
            let imagePath = cardProviderDetailsDictionary.value(forKey: kimage_path) as? String
            let imgName  = cardProviderDetailsDictionary.value(forKey: kimage_name) as? String
            
            var imgUrl : NSString = String(format:"%@%@/%@",imagePath!,(appdelegate?.walletImgFolderName)!,imgName!) as NSString
            
            imgUrl = imgUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)! as NSString
            
            if UIApplication.shared.canOpenURL(NSURL(string: imgUrl as String)! as URL) {
                let imageUrl : NSURL = NSURL(string: imgUrl as String)!
                
                self.bannerImage.sd_setImage(with: imageUrl as URL, placeholderImage: UIImage(named: "cartPlaceHolder"),options: [], completed: { (image, error, cacheType, imageURL) in
                    // Perform operation.
                    print(error as Any)
                    
                })
            }
        }
        
        isFav =  cardProviderDetailsDictionary.value(forKey: kfavorite) as? String
        
        if  isFav == "1" {
            favouriteButton.setImage(UIImage(named: "Favourites"), for: UIControlState.normal)
        }
        else{
               favouriteButton.setImage(UIImage(named: "unFavourites"), for: UIControlState.normal)
            
        }
    }
    
    
    // MARK: Button Action
    
    @IBAction func cancel(_ sender: AnyObject) {
        
        let window = UIApplication.shared.keyWindow!
        let addReviewButton = window.viewWithTag(2017)
        
        if (addReviewButton != nil) {
            addReviewButton?.isHidden = true
           // addReviewButton?.removeFromSuperview()
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func favouriteButton_clicked(_ sender: Any) {
        
      let  appDelegate = UIApplication.shared.delegate as! AppDelegate

        if appDelegate.userType == kguestUser {
        alertController(controller: self, title: "", message: "Please  SIGNUP/LOGIN for like Loyalty card", okButtonTitle: "LOGIN", cancelButtonTitle: "CANCEL", completionHandler: {(index) -> Void in
            
            if index == 1 {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let signIn = storyBoard.instantiateViewController(withIdentifier: kSignInStoryBoardID) as? SignInViewController
                let nav : UINavigationController = UINavigationController(rootViewController: signIn!)
                appDelegate.window?.rootViewController = nav
                appDelegate.window?.makeKeyAndVisible()
            }
        })
        }
            
        else {
        makeOfferFavourite()
    }
    }
    @IBAction func editButton_clicked(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let manualcardView = storyBoard.instantiateViewController(withIdentifier: "manualcardStoryBoardID") as! AddManualcardViewController
        manualcardView.selectedcardDictionary = self.cardProviderDetailsDictionary
        manualcardView.fromViewType = keditcard
        manualcardView.cardProviderDetailsDictionary = self.cardProviderDetailsDictionary
        self.navigationController?.pushViewController(manualcardView, animated: true)
    }
    
    
    
    // Get  Like/Unlike
    func makeOfferFavourite(){
        
        var params : NSMutableDictionary = [:]
        
        let  loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
        var status = ""
        if  self.isFav == "1" {
            status = "0"
        }
        else{
            status = "1"
        }
        
        params = [
            "card_id" : cardProviderDetailsDictionary.value(forKey: kid)!,
            "user_id" : loginInfoDictionary.value(forKey: kid)!,
            "type" : cardProviderDetailsDictionary.value(forKey: "type")!,
            kfavorite : status
        ]
        
        
        print(params)
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"FavoriteUnfavoriteCard")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            
            if (response != nil) {
                
                DispatchQueue.main.async {
                    print(response![kCode]!)
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        // set favourite button stautus
                        
                        self.isFav = status
                        
                        if  status == "1" {
                            self.favouriteButton.setImage(UIImage(named: "Favourites"), for: UIControlState.normal)
                        }
                        else{
                            self.favouriteButton.setImage(UIImage(named: "unFavourites"), for: UIControlState.normal)
                            
                        }
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
        if segue.identifier == kmanualInputSegueIdentifier {
            
            let addManualcardViewController : AddManualcardViewController = segue.destination as! AddManualcardViewController
            addManualcardViewController.selectedcardDictionary = sender as! NSMutableDictionary
            addManualcardViewController.fromViewType = keditcard
        }
    }
    
}
