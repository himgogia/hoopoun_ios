//
//  HowItWorksViewController.swift
//  Hoopoun
//
//  Created by Chankit on 10/13/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class HowItWorksViewController: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet var pageController: UIPageControl!
    @IBOutlet var scrollView: UIScrollView!
    let bannerArray = ["CardOffer","CardScan","RedeemOffer"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageController.currentPage = 0
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setImages()
    }
    
    func setImages() -> Void {
        
        var xPOS: CGFloat = 0.0
        
        for i in 0 ..< bannerArray.count {
            
            print (i) //i will increment up one with each iteration of the for loop
            var bannerImage : UIImageView!
            bannerImage = UIImageView(frame: CGRect(x:xPOS, y:0,width:kIphoneWidth, height:self.scrollView.frame.size.height))
            
            bannerImage.image = UIImage(named: bannerArray[i])
            bannerImage.contentMode = UIViewContentMode.scaleAspectFill
            self.scrollView.addSubview(bannerImage)
            
            xPOS = xPOS + kIphoneWidth;
            
            self.scrollView.contentSize = CGSize(width:xPOS, height:self.scrollView.frame.height)
            self.scrollView.delegate = self
        }
        self.view.bringSubview(toFront: self.pageController)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageController.currentPage = Int(currentPage);
    }
    
    @IBAction func backButton_Clicked(_ sender: Any) {
        
        self.navigationController?.isNavigationBarHidden = false
        _ = navigationController?.popViewController(animated: false)
    }
}
