//
//  FilterSliderViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 11/10/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

protocol offerFilterDelegate {
     func filterOfferByCategoryAndLocation()
}

class FilterSliderViewController: UIViewController,SlidingContainerViewControllerDelegate {
    var resetButton: UIBarButtonItem!
     var doneButton: UIBarButtonItem!
    
    var delegate: offerFilterDelegate!

    
    var  selectedSubCategoryArray :NSMutableArray!
    var  selectedSubLocationArray :NSMutableArray!

    var selectedCategorieDictionary : NSMutableDictionary = NSMutableDictionary()

    var slidingContainerViewController :SlidingContainerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // reset Button
        
        let resetButton = UIButton()
        resetButton.setTitle("Reset", for: UIControlState.normal)
        resetButton.titleLabel?.font = UIFont(name: "SFUIText-Bold", size: 16)
        resetButton.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        resetButton.addTarget(self, action: #selector(resetButton_clicked), for: UIControlEvents.touchUpInside);       self.navigationItem.setRightBarButton(UIBarButtonItem(customView: resetButton), animated: true);
        
        // Done
        let doneButton = UIButton()
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.titleLabel?.font = UIFont(name: "SFUIText-Bold", size: 16)
        doneButton.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        doneButton.addTarget(self, action: #selector(doneButton_clicked), for: UIControlEvents.touchUpInside);       self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: doneButton), animated: true);
        
        self.setViewControlers()
    }
    
    func setViewControlers(){
        
        
         let locationView = self.storyboard?.instantiateViewController(withIdentifier: klocationFilterViewController) as? LocationFilterController
             locationView?.selectedSubLocationArray = self.selectedSubLocationArray!
        
        let categoryFilterView = self.storyboard?.instantiateViewController(withIdentifier: kcategoryFilterViewController) as? CategoryFilterController
        categoryFilterView?.selectedCategorieDictionary = self.selectedCategorieDictionary
        categoryFilterView?.selectedSubCategoryArray = self.selectedSubCategoryArray!
        
        
        slidingContainerViewController = SlidingContainerViewController (
            parent: self,
            contentViewControllers: [categoryFilterView!,locationView!],
            titles: ["Categories","Locations"])
        
        
        view.addSubview(slidingContainerViewController.view)
        slidingContainerViewController.view.frame = CGRect(x: 0, y: 64, width: kIphoneWidth, height: kIphoneHeight-64)

        
        slidingContainerViewController.sliderView.appearance.outerPadding = 0
        slidingContainerViewController.sliderView.appearance.innerPadding = 0
        slidingContainerViewController.sliderView.appearance.fixedWidth = true

        
        slidingContainerViewController.delegate = self
        slidingContainerViewController.setCurrentViewControllerAtIndex(0)
        
    }

    // MARK: Button Action
    
     func resetButton_clicked(_ sender: Any) {
        
       print(self.selectedSubCategoryArray)
        self.selectedSubCategoryArray.removeAllObjects()
        self.selectedSubLocationArray.removeAllObjects()
        
        self.delegate.filterOfferByCategoryAndLocation()
        
        self.navigationController?.popViewController(animated: true)
    }
     func doneButton_clicked(_ sender: Any) {
        
        self.delegate.filterOfferByCategoryAndLocation()
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: SlidingContainerViewControllerDelegate
    
    func slidingContainerViewControllerDidMoveToViewController(_ slidingContainerViewController: SlidingContainerViewController, viewController: UIViewController, atIndex: Int) {
        print(atIndex)
        
        
    }
    
    func slidingContainerViewControllerDidShowSliderView(_ slidingContainerViewController: SlidingContainerViewController) {
        
    }
    
    func slidingContainerViewControllerDidHideSliderView(_ slidingContainerViewController: SlidingContainerViewController) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
