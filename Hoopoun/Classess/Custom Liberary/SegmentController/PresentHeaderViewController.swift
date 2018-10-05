//
//  PresentHeaderViewController.swift
//  SJSegmentedScrollViewDemo
//
//  Created by Subins on 25/11/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit


class PresentHeaderViewController: UIViewController,UIScrollViewDelegate {
   
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var offetTypeHeight: NSLayoutConstraint!
    
    @IBOutlet var discountLabelHeight: NSLayoutConstraint!
    @IBOutlet var ratingView: FloatRatingView?
    @IBOutlet var ratingLabel: UILabel?
    @IBOutlet var distanceLabel: UILabel?
    @IBOutlet var discountLabel: UILabel?
    @IBOutlet var offerTypeLabel: UILabel?
    var offerDictionary : NSMutableDictionary = NSMutableDictionary()
    
    @IBOutlet var favouriteButton: UIButton?
    @IBOutlet var shareButton: UIButton!
    
    var offerDetails :NSMutableDictionary!
    var isFav : String!
    var selectedOfferId : String!

    override  func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        scrollView.frame = CGRect(x: 0, y: 0, width: kIphoneWidth, height: scrollView.frame.size.height)
        
        
        self.view.addSubview(scrollView)
        self.navigationController?.isNavigationBarHidden = true
        setInitialLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
         pageControl.currentPage = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
   
    
    // Set initail layout
    
    func setInitialLayout(){
        
        setHeaderViewImages()
        
        let offerDict : NSMutableDictionary = self.offerDictionary.value(forKey: "offer_detail") as! NSMutableDictionary
        
        let stringTemp = offerDict.value(forKey: "ccount") as? String
            if stringTemp == "1"  && stringTemp != nil {
            
            
            let array : NSArray = (self.offerDictionary.value(forKey: "offers_list") as? NSArray)!
            print(array)
            
            let resultPredicate = NSPredicate(format: "offer_id = %@", self.selectedOfferId)
            let  filterArray : NSArray = array.filtered(using: resultPredicate) as NSArray
            print(filterArray)
            
            if filterArray.count == 1 {
                
                let dict : NSDictionary = filterArray.object(at: 0) as! NSDictionary
                let titleString = dict.value(forKey: kofferTitle) as? String
                offerTypeLabel?.text = titleString
                
                let titleHeight =  titleString?.height(withConstrainedWidth: (kIphoneWidth-130), font: UIFont(name: "SFUIText-Semibold", size: 13)!)
                
                if CGFloat(titleHeight!) > 36 {
                    self.offetTypeHeight.constant = 36
                }
                else {
                    self.offetTypeHeight.constant = CGFloat(titleHeight!)
            }
            
           offerDetails  = self.offerDictionary.value(forKey: "offer_detail") as! NSMutableDictionary
            
         let storeName :String = (offerDetails.value(forKey: kstore_name) as? String)!
           
            
            // discount label
            
            
            let discountString = String(format: "%@, %@",storeName,(offerDetails.value(forKey: kLocality) as? String)!)
             discountLabel?.text = discountString
          
            let height  = discountString.height(withConstrainedWidth: (kIphoneWidth-130), font: UIFont(name: "SFUIText-Regular", size: 13)!)
                
                if CGFloat(height) > 36 {
                    self.discountLabelHeight.constant = 36
                }
                else {
                    self.discountLabelHeight.constant = CGFloat(height)
                }
            
                
        }
            // store address on discount label
            // distance
            let floadDistance = offerDetails.value(forKey: kdistance) as! String
            let distance : Float =  Float(floadDistance)!
            let distanceInDecimal = String(format: "%0.2f km", distance)
            distanceLabel?.text = distanceInDecimal
            
            let rating = offerDetails.value(forKey: "offerrating") as? String
            let ratingInFlot : Float =  Float(rating!)!
            self.ratingView?.rating = Double(ratingInFlot)
            self.ratingLabel?.text = String(format: "%0.1f", ratingInFlot)

            
            isFav =  offerDetails.value(forKey: kislike) as? String
            
            if (isFav == nil) {
                isFav = ""
            }
            
            if  isFav == "1" {
                favouriteButton?.setImage(UIImage(named: "Favourites"), for: UIControlState.normal)
            }
            else{
                favouriteButton?.setImage(UIImage(named: "unFavourites"), for: UIControlState.normal)
            }
        }
      
    }
    
    func setLabesHeight( offetType : String,address :String ){
        
        var height :Float = Float(calculateHeightForlblTextWithFont(offetType, _width: (kIphoneWidth-130), font: UIFont(name: "SFUIText-Semibold", size: 14)!))
            self.offetTypeHeight.constant = CGFloat(height)
        
        
        // offer address
        
        height = Float(calculateHeightForlblTextWithFont(address, _width: (kIphoneWidth-130), font: UIFont(name: "SFUIText-Regular", size: 14)!))
            self.discountLabelHeight.constant = CGFloat(height)
        
    }
    
    func loadList(){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate

        if appDelegate?.selectedOfferId != nil && appDelegate?.offerDictionary != nil {
            self.selectedOfferId = appDelegate?.selectedOfferId
            self.offerDictionary = (appDelegate?.offerDictionary)!

        }
        setInitialLayout()
    }
    
    
    
    // Set header view images in scroll view
    func setHeaderViewImages(){
        
        let galleryArray :NSMutableArray = self.offerDictionary.value(forKey: "offergallery") as! NSMutableArray
        
        for index in 0..<galleryArray.count {
            
            let urlstring : String = ((galleryArray.object(at: index) as? NSMutableDictionary)!.value(forKey: "offerImage") as? String)!
            
            var frame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
            
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size
            
            let imageView = UIImageView(frame: frame)
            imageView.backgroundColor  = UIColor.white
            imageView.contentMode = UIViewContentMode.scaleToFill
            imageView.sd_setImage(with: URL(string: urlstring), placeholderImage: UIImage(named: "cartPlaceHolder"))
            self.scrollView .addSubview(imageView)
        }
        
        let count :Float = Float(galleryArray.count)
        let width1  :Float = Float(self.scrollView.frame.size.width)
        self.scrollView.isPagingEnabled = true
       
        pageControl.numberOfPages = galleryArray.count
        self.scrollView.contentSize = CGSize(width: CGFloat(width1 * count), height: self.scrollView.frame.size.height)
        
        self.view.insertSubview(self.scrollView, belowSubview: pageControl)
        
    }
    
    
    // MARK:- Scroll view delegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    
    
    // MARK: Button Action
    
    @IBAction func cancel(_ sender: AnyObject) {
        
        let window = UIApplication.shared.keyWindow!
        let addReviewButton = window.viewWithTag(2017)
        
        if (addReviewButton != nil) {
            addReviewButton?.isHidden = true
            //            addReviewButton?.removeFromSuperview()

        }
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func favouriteButton_clicked(_ sender: Any) {
        
        // check guest user
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        if appDelegate.userType == kguestUser {
            
            alertController(controller: self, title: "", message: "Please login first to make it favourite", okButtonTitle: "LOGIN", cancelButtonTitle: "CANCEL", completionHandler: {(index) -> Void in
                
                if index == 1 {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let signIn = storyBoard.instantiateViewController(withIdentifier: kSignInStoryBoardID) as? SignInViewController
                    let nav : UINavigationController = UINavigationController(rootViewController: signIn!)
                    appDelegate.window?.rootViewController = nav
                    appDelegate.window?.makeKeyAndVisible()
                    
                }
                
            })
          
        }
        else{
            makeOfferFavourite()
        }
        
        
    }
    @IBAction func shareButton_clicked(_ sender: Any) {
        
        // hide review button
        let window = UIApplication.shared.keyWindow!
        let addReviewButton = window.viewWithTag(2017)
        
        if (addReviewButton != nil) {
            addReviewButton?.isHidden = true
        }
        
        let shareOfferString = offerDetails.value(forKey: kofferTitle) as? String
   
        let shareText = NSString(format: "Hey Checkout this amazing offer on Hoopoun, %@  http://www.hoopoun.com",shareOfferString!)
        
        let activityViewController = UIActivityViewController(activityItems:[shareText], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook, UIActivityType.postToTwitter,UIActivityType.message]
        
        
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    //MARK :- APIS CALL
    
    // Get Category Offer
    func makeOfferFavourite(){
        
        
        var params : NSMutableDictionary = [:]
        
        let  loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
        var likeString : String = ""
        if  isFav == "1" {
            likeString = "0"
        }
        else{
           likeString = "1"
        }
        
        params = [
            "offerid" : offerDetails.value(forKey: koffer_id)!,
            "userId" : loginInfoDictionary.value(forKey: kid)!,
            kstatus : likeString
        ]
        
        
        print(params)
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"offerlike")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            
            if (response != nil) {
                
                DispatchQueue.main.async {
                    print(response![kCode]!)
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "OK" {
                        // set favourite button stautus
                        
                        if  self.isFav == "1" {
                            self.favouriteButton?.setImage(UIImage(named: "unFavourites"), for: UIControlState.normal)
                            self.isFav = "0"
                        }
                        else{
                            self.favouriteButton?.setImage(UIImage(named: "Favourites"), for: UIControlState.normal)
                            self.isFav = "1"
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

}
