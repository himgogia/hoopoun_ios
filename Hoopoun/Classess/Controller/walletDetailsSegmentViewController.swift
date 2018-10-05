//
//  walletDetailsSegmentViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 30/10/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class walletDetailsSegmentViewController: SJSegmentedViewController,SJSegmentedViewControllerViewSource {


//    var walletDictionary : NSMutableDictionary!
    var  cardProviderDetailsDictionary : NSMutableDictionary!
    var selectedSegment: SJSegmentTab?
    
    override func viewDidLoad() {
        if let storyboard = self.storyboard {
            
            
            
            let headerController :walletHeaderDetailsViewController = (storyboard
                .instantiateViewController(withIdentifier: "walletdetailHeaderView") as? walletHeaderDetailsViewController)!
//            headerController.walletDictionary = self.walletDictionary
            headerController.cardProviderDetailsDictionary = self.cardProviderDetailsDictionary

            
            let offerViewController = storyboard
                .instantiateViewController(withIdentifier: kcardOfferViewStoryBoardID) as! cardOfferViewController
            offerViewController.title = "Offers"
            offerViewController.cardProviderDetailsDictionary = self.cardProviderDetailsDictionary

//           offerViewController.walletDictionary = self.walletDictionary
            
            let barcodeViewController  = storyboard.instantiateViewController(withIdentifier: kbarCodeViewstoryBoardID) as! cardBarCodeViewController
            barcodeViewController.title = "Barcode"
            barcodeViewController.cardProviderDetailsDictionary = self.cardProviderDetailsDictionary

//            barcodeViewController.walletDictionary = self.walletDictionary
            
            
            headerViewController = headerController
            
            let segmentController = SJSegmentedViewController()
            segmentController.headerViewController = headerViewController
            segmentController.segmentControllers = [offerViewController,
                                                    barcodeViewController]
            segmentController.headerViewHeight = 200.0
            segmentController.headerViewOffsetHeight = 0.0
            
            segmentControllers = [barcodeViewController,
                                  offerViewController
                                  ]
            headerViewHeight = 200
            selectedSegmentViewHeight = 5.0
            headerViewOffsetHeight = 0.0
            segmentTitleColor = .gray
            selectedSegmentViewColor = kLightBlueColor
            segmentShadow = SJShadow.light()
            showsHorizontalScrollIndicator = false
            showsVerticalScrollIndicator = false
            delegate = self as SJSegmentedViewControllerDelegate
            
        }
        
        
        title = "Segment"
        
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        

        let window = UIApplication.shared.keyWindow!
        let addReviewButton = window.viewWithTag(2017)
        
        if (addReviewButton != nil) {
            addReviewButton?.isHidden = true
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
}

extension walletDetailsSegmentViewController: SJSegmentedViewControllerDelegate {
    
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
                // let  categoryInfoViewController: CategoryDetailInfoView = CategoryDetailInfoView()
                //  categoryInfoViewController.getStoreInfo()
                
            }
        }
    }
}

