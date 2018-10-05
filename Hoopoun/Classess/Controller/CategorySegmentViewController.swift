//
//  ViewController.swift
//  SJSegmentedScrollView
//
//  Created by Subins Jose on 06/10/2016.
//  Copyright © 2016 Subins Jose. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class CategorySegmentViewController: SJSegmentedViewController,SJSegmentedViewControllerViewSource {
    
    
    var offerDictionary : NSMutableDictionary!
    
	var selectedSegment: SJSegmentTab?
    var selectedOfferId : String = ""
    var selectedStoreId : String = ""

	override func viewDidLoad() {
	
        self.creatSegmentView()
		title = "Segment"

        super.viewDidLoad()
   
	}
    
    
    
    
    func creatSegmentView(){
        
        if let storyboard = self.storyboard {
            
            
            let headerController :PresentHeaderViewController = (storyboard
                .instantiateViewController(withIdentifier: "PresentHeader") as? PresentHeaderViewController)!
            headerController.offerDictionary = self.offerDictionary
            headerController.selectedOfferId = self.selectedOfferId
            
            let offerViewController = storyboard
                .instantiateViewController(withIdentifier: kcategoryDetailsOfferStoryboard) as! CategoryDetailsOfferViewController
            offerViewController.title = "Offers"
            offerViewController.offerDictionary = self.offerDictionary
            offerViewController.selectedOfferId = self.selectedOfferId
            
            let infoViewController = storyboard
                .instantiateViewController(withIdentifier: kcategoryDetailInfoStoryBoard) as! CategoryDetailInfoView
            infoViewController.title = "Info"
            infoViewController.offerDictionary = self.offerDictionary
            infoViewController.selectedStoreId = self.selectedStoreId
            
            
            let reviewViewController = storyboard
                .instantiateViewController(withIdentifier: kcategoryDetailReviewStoryBoard) as! CategoryDetailsReviewViewController
            reviewViewController.title = "Reviews"
            reviewViewController.offerDictionary = self.offerDictionary
            
            
            headerViewController = headerController
            
            
            let segmentController = SJSegmentedViewController()
            segmentController.headerViewController = headerViewController
            segmentController.segmentControllers = [offerViewController,
                                                    infoViewController,reviewViewController]
            segmentController.headerViewHeight = 280.0
            segmentController.headerViewOffsetHeight = 31.0
            segmentController.segmentBackgroundColor = .white
            segmentControllers = [offerViewController,
                                  infoViewController,
                                  reviewViewController]
            headerViewHeight = 280
            selectedSegmentViewHeight = 5.0
            headerViewOffsetHeight = 31.0
            segmentTitleColor = .gray
            selectedSegmentViewColor = kLightBlueColor
            segmentShadow = SJShadow.light()
            showsHorizontalScrollIndicator = false
            showsVerticalScrollIndicator = false
            
            delegate = self
            
        }

    }

    func reloadHeaderViewContain(dict : NSMutableDictionary, selectedOfferId : String){
        
         if let storyboard = self.storyboard {
        let headerController :PresentHeaderViewController = (storyboard
            .instantiateViewController(withIdentifier: "PresentHeader") as? PresentHeaderViewController)!
        headerController.offerDictionary = dict.mutableCopy() as! NSMutableDictionary
//        headerController.selectedOfferId = selectedOfferId
//            headerController.reloadInitialData(dict :dict.mutableCopy() as! NSMutableDictionary)
          
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        let window = UIApplication.shared.keyWindow!
        let addReviewButton = window.viewWithTag(2017)
        
        let appDelegate :AppDelegate = UIApplication.shared.delegate as! AppDelegate
        if selectedSegment?.tag == 102 && addReviewButton != nil {
            appDelegate.addReviewButton = false
        }
        else if addReviewButton != nil{
            appDelegate.addReviewButton = true
        }
    }
    
	func getSegmentTabWithImage(_ imageName: String) -> UIView {

		let view = UIImageView()
		view.frame.size.width = 100
		view.image = UIImage(named: imageName)
		view.contentMode = .scaleAspectFit
		view.backgroundColor = .white
		return view
	}
    
    
    // MARK: get Offer Details
    
    func getOfferDetails( dict: NSMutableDictionary){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let  loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
        var storIdString : String = (dict.value(forKey: kstoreId) as? String)!
        let storeIds : NSArray = storIdString.components(separatedBy: ",") as NSArray
        
        if storeIds.count > 0 {
            storIdString = storeIds[0] as! String
        }
        else{
            
            storIdString = ""
        }
        
        var params : NSMutableDictionary = [:]
        
        
        var userIDString = ""
        if appDelegate.userType == kguestUser {
            userIDString = ""
        }
        else {
            userIDString =  loginInfoDictionary.value(forKey: kid)! as! String
        }
        
        if (appDelegate.lat == 0 && appDelegate.long == 0) {
            
            params = [
                klocality_id : appDelegate.locality_id,
                kstore_id : storIdString,
                koffer_id : dict.value(forKey: koffer_id)!,
                "user_id" : userIDString
            ]
        }
        else{
            params = [
                
                klatitude: String(appDelegate.lat),
                klongitude: String(appDelegate.long),
                kstore_id : storIdString,
                koffer_id : dict.value(forKey: koffer_id)!,
                "user_id" : userIDString
            ]
        }
        selectedOfferId = dict.value(forKey:koffer_id)! as! String
        
        print(params)
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"offerDetails_New")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                
                DispatchQueue.main.async {
                    print(response![kCode]!)
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        
                        print(dict[kPayload] as Any)
                        
                        let payLoadDictionary = (dict[kPayload]) as! NSMutableDictionary
                        
                        self.performSegue(withIdentifier: kcategorySegmentSegueIdentifier, sender: payLoadDictionary)
                        
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
                
                DispatchQueue.main.async {
                    alertController(controller:self, title: "", message:"No Record Found", okButtonTitle: "OK", completionHandler: {(index) -> Void in
                        
                    })
                }
            }
            
            
        }
        
    }
}



extension CategorySegmentViewController: SJSegmentedViewControllerDelegate {

	func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {

		if selectedSegment != nil {
			selectedSegment?.titleColor(.lightGray)
		}
        
        let window = UIApplication.shared.keyWindow!
        let addReviewButton = window.viewWithTag(2017)

		if segments.count > 0 {

			selectedSegment = segments[index]
			selectedSegment?.titleColor(kLightBlueColor)
            
            if index == 2 {
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let reviewViewController = storyBoard
                    .instantiateViewController(withIdentifier: kcategoryDetailReviewStoryBoard) as! CategoryDetailsReviewViewController
                reviewViewController.hideAddButton()
            }
            else{
                addReviewButton?.isHidden = true

            }
		}
	}
}

