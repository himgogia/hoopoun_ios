//
//  MyFavourieViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 03/11/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class MyFavourieViewController: SJSegmentedViewController,SJSegmentedViewControllerViewSource {
    
    var walletDictionary : NSMutableDictionary!
    var selectedSegment: SJSegmentTab?
    
    override func viewDidLoad() {
        
        if let storyboard = self.storyboard {
            
            let favcardViewController = storyboard
                .instantiateViewController(withIdentifier: kMyFavcardSotoryBoardID) as! MyFavoritescardViewController
            favcardViewController.title = "Loyalty Cards"

            
            let favOfferViewController  = storyboard.instantiateViewController(withIdentifier: kMyFavOfferStoryBoardID) as! MyFavoriteOfferViewController
            favOfferViewController.title = "Offers"

         
            let segmentController = SJSegmentedViewController()
            segmentController.headerViewController = headerViewController
            segmentController.segmentControllers = [favcardViewController,favOfferViewController]
            segmentController.headerViewHeight = 0.0
            segmentController.headerViewOffsetHeight = 0.0
            
            segmentControllers = [favcardViewController,favOfferViewController
            ]
            headerViewHeight = 0
            selectedSegmentViewHeight = 5.0
            headerViewOffsetHeight = 0.0
            segmentTitleColor = .gray
            selectedSegmentViewColor = kLightBlueColor
            segmentShadow = SJShadow.light()
            showsHorizontalScrollIndicator = false
            showsVerticalScrollIndicator = false
            delegate = self as SJSegmentedViewControllerDelegate
            
        }
        
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // MARK :- Button Clicked
    
    @IBAction func backButton_clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    func getSegmentTabWithImage(_ imageName: String) -> UIView {
        
        let view = UIImageView()
        view.frame.size.width = 100
        view.image = UIImage(named: imageName)
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .white
        return view
    }
}

extension MyFavourieViewController: SJSegmentedViewControllerDelegate {
    
    func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        
        if selectedSegment != nil {
            selectedSegment?.titleColor(.lightGray)
        }
        
        let window = UIApplication.shared.keyWindow!
        let addReviewButton = window.viewWithTag(2017)
        
        if (addReviewButton != nil) {
            addReviewButton?.isHidden = true
        }
        if index == 2 {
            addReviewButton?.isHidden = false
        }
        
        if segments.count > 0 {
            
            selectedSegment = segments[index]
            selectedSegment?.titleColor(kLightBlueColor)
            
            if index == 1 {
                
            }
        }
    }
}
