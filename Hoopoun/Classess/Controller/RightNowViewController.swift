//
//  RightNowViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 21/08/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit
import SDWebImage
import  CoreLocation

protocol showhotDealDelegate {
    
    func showHotDeal()
}

class RightNowViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    let messageLabel = UILabel ()
    var isShowHotDeal : Bool! = nil
    var delegateHotDeal :showhotDealDelegate!
    
    
    var categoryArray : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.categoryArray.count % 2 == 0 {
            isShowHotDeal = false
        }
        else{
            isShowHotDeal = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        creatMessageLabel()
    }
    
    func creatMessageLabel(){
        messageLabel.frame = CGRect(x:0, y:(kIphoneHeight-100)/2, width: kIphoneWidth, height: 36)
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.backgroundColor = UIColor.clear
        messageLabel.textAlignment = .center
        messageLabel.isHidden = true
        messageLabel.textColor = UIColor.lightGray
        messageLabel.text = "No Offers Found"
        self.view.addSubview(messageLabel)
        
        if self.categoryArray.count == 0 {
            messageLabel.isHidden = false
        }
    }
    
    
    // MARK:- Collection view Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isShowHotDeal == true {
            return self.categoryArray.count+1
        }
        return self.categoryArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RightNowCollectionCell
        
        if self.categoryArray.count>0 && indexPath.row != self.categoryArray.count {
            let dict:NSMutableDictionary = self.categoryArray.object(at: indexPath.row) as! NSMutableDictionary
            cell.setDataForRightNowLocation(dictionary:dict)
        }
        else if indexPath.row == self.categoryArray.count{
            
            cell.nameLabel.text = "Check out our HOT DEALS"
            var imgUrl  =  "http://hoopoun.com/admin/assets/upload/hot_deal.png"
            
            imgUrl = (imgUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)! as NSString) as String
            
            if UIApplication.shared.canOpenURL(NSURL(string: imgUrl as String)! as URL) {
                let imageUrl : NSURL = NSURL(string: imgUrl as String)!
                
                cell.imageview.sd_setImage(with: imageUrl as URL, placeholderImage: UIImage(named: "cartPlaceHolder"),options: [], completed: { (image, error, cacheType, imageURL) in
                    // Perform operation.
                    print(error as Any)
                    
                })
            }
            
        }
        cell.contentView.backgroundColor = UIColor.lightGray
        
        return cell
    }
    
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (kIphoneWidth-30)/2, height: 120) // The size of one cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 0, 10) // margin between cells
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == self.categoryArray.count && isShowHotDeal == true{
            
            self.delegateHotDeal.showHotDeal()
        }
        else{
            
            self.performSegue(withIdentifier: kcategoryOfferIdentifier, sender:self.categoryArray.object(at: indexPath.row))
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == kcategoryOfferIdentifier {
            
            let categoryOfferViewController : CategoryOfferViewController = segue.destination as! CategoryOfferViewController
            categoryOfferViewController.selectedCategorieDictionary = sender as! NSMutableDictionary
        }
    }
}
