
import UIKit

class cardOfferViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var  cardProviderDetailsDictionary : NSMutableDictionary!
    
    @IBOutlet var noRecordFoundLabel: UILabel!
    var offerArray : NSMutableArray = NSMutableArray()
    var selectedOfferId : String = ""
     var storIdString : String = ""
    
    @IBOutlet var offerTable: UITableView!
    var appDelegate : AppDelegate! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if cardProviderDetailsDictionary.value(forKey: "type") as?String == "Other" {
            self.noRecordFoundLabel.isHidden = false
            self.offerTable.isHidden = true
        }
        else {
            getcardOffers()
        }
    }
    
    // MARK TableView Deleage ////////////////////////////////////////////
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return offerArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "cell"
        var cell: RewardsCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? RewardsCell
        
        tableView.register(UINib(nibName: "RewardsCell", bundle: nil), forCellReuseIdentifier: identifier)
        cell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? RewardsCell)!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if offerArray.count>0 {
            cell.setAroundMeCellData(dictionary: offerArray.object(at: indexPath.section) as! NSMutableDictionary, cellType:"cardOffer")
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let dict : NSMutableDictionary =  self.offerArray.object(at: indexPath.section) as! NSMutableDictionary
        let offetType : String = (dict.value(forKey: kofferTitle) as? String)!
        
        let storeName :String = (dict.value(forKey: kstore_name) as? String)!
        let address = String(format: "%@ %@",storeName,(dict.value(forKey: kstoreAddress) as? String)!)
        
        var cellHeight : CGFloat = 0.0
        let width = kIphoneWidth - 125
        
        var height  = offetType.height(withConstrainedWidth: width, font: UIFont(name: "SFUIText-Semibold", size: 12)!)
        
        if height > 30 {
            cellHeight = 30
        }
        else {
            cellHeight = CGFloat(height)
        }
        
        let addressWidth = kIphoneWidth - 135
        height =  address.height(withConstrainedWidth: addressWidth, font: UIFont(name: "SFUIText-Regular", size: 12)!)
        
        if height > 30 {
            cellHeight += 30
        }
        else {
            cellHeight += CGFloat(height)
        }
        
        return CGFloat(220+cellHeight);
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let appDelegate :AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if appDelegate.userType == kguestUser {
            
            alertController(controller: self, title: "", message: "Please Login first for view offer details", okButtonTitle: "LOGIN", cancelButtonTitle: "CANCEL", completionHandler: {(index) -> Void in
                
                if index == 1 {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let signIn = storyBoard.instantiateViewController(withIdentifier: kSignInStoryBoardID) as? SignInViewController
                    let nav : UINavigationController = UINavigationController(rootViewController: signIn!)
                    appDelegate.window?.rootViewController = nav
                    appDelegate.window?.makeKeyAndVisible()                  }
            })
        }
        else{
            self.getOfferDetails(dict: offerArray.object(at: indexPath.section) as! NSMutableDictionary)
        }
    }

    // MARK : APIs call
    
    func getcardOffers(){
        
        var params : NSMutableDictionary = [:]
        
        // if user select current location
        if (appDelegate.lat == 0 && appDelegate.long == 0) {
            
            params = [
                klocality_id : appDelegate.locality_id,
                kcardId : self.cardProviderDetailsDictionary.value(forKey: kid)  as Any
            ]
        }
        else{
            params = [
                
                klatitude: String(appDelegate.lat),
                klongitude: String(appDelegate.long),
                kcardId : self.cardProviderDetailsDictionary.value(forKey: kid)  as Any
            ]
        }
        print(params)
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"loyalityCardOffer")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: false, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    print(response![kCode]!)
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        print(dict[kPayload] as Any)
                        
                        self.offerArray = (dict[kPayload]) as! NSMutableArray
                        
                        if self.offerArray.count>0{
                            self.offerTable.isHidden = false
                            self.offerTable.reloadData()
                        }
                        else{
                            self.noRecordFoundLabel.isHidden = false
                        }
                    }
                    else{
                        self.noRecordFoundLabel.isHidden = false
                    }
                }
            }
        }
    }
    
    func getOfferDetails( dict: NSMutableDictionary){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let  loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
         storIdString  = (dict.value(forKey: kstoreId) as? String)!
        let storeIds : NSArray = storIdString.components(separatedBy: ",") as NSArray
        
        if storeIds.count > 0 {
            storIdString = storeIds[0] as! String
        }
        else{
            storIdString = ""
        }
        
        var params : NSMutableDictionary = [:]

        if (appDelegate.lat == 0 && appDelegate.long == 0) {
            params = [
                klocality_id : appDelegate.locality_id,
                kstore_id : storIdString,
                koffer_id : dict.value(forKey: koffer_id)!,
                "user_id" : loginInfoDictionary.value(forKey: kid)!
            ]
        }
        else{
            params = [
                klatitude: String(appDelegate.lat),
                klongitude: String(appDelegate.long),
                kstore_id : storIdString,
                koffer_id : dict.value(forKey: koffer_id)!,
                "user_id" : loginInfoDictionary.value(forKey: kid)!
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kcategorySegmentSegueIdentifier {
            
            let categorySegmentViewController : CategorySegmentViewController = segue.destination as! CategorySegmentViewController
            categorySegmentViewController.offerDictionary = sender as! NSMutableDictionary
            categorySegmentViewController.selectedOfferId = self.selectedOfferId
            categorySegmentViewController.selectedStoreId = storIdString

        }
    }
}
