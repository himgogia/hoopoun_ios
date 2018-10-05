//
//  Utility.swift
//  Hoopoun
//
//  Created by vineet patidar on 16/08/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit


class Utility: NSObject {

    var dict : NSMutableDictionary! = [:]
    
    class var sharedInstance: Utility {
        
        struct Static {
            static let instance = Utility()
        }
        return Static.instance
    }
}



// Show Hude
func showHude (){
    
    let windowArray : NSArray  = UIApplication.shared.windows as NSArray
    var window :UIWindow =  (windowArray[0] as? UIWindow)!
    
    if window.isHidden == true {
        window = UIApplication.shared.windows.last!
    }
  
    let hude = MBProgressHUD.showAdded(to:window, animated: true)
    hude.mode = MBProgressHUDMode.indeterminate
}

// hide Hude
func hideHude () {
    
    let windowArray : NSArray  = UIApplication.shared.windows as NSArray
    var window :UIWindow =  (windowArray[0] as? UIWindow)!
    
    if window.isHidden == true {
        window = UIApplication.shared.windows.last!
    }
    MBProgressHUD.hide(for: window, animated: true)
    
}


func calculateHeightForString(_ inString:String,_width :CGFloat) -> CGFloat
{
    let messageString = inString
    let attrString:NSAttributedString? = NSAttributedString(string: messageString, attributes: nil)
    let rect:CGRect = attrString!.boundingRect(with: CGSize(width: _width,height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, context:nil )//hear u will get nearer height not the exact value
    let requredSize:CGRect = rect
    return requredSize.height  //to include button's in your tableview
    
}


func calculateHeightForlblText(_ inString:String,  _width :CGFloat) -> CGFloat
{
    
    let constraintRect = CGSize(width: _width, height: CGFloat.greatestFiniteMagnitude)
    
    let boundingBox = inString.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [ NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 14.2)! ], context: nil)
    
    return boundingBox.height
    
}

func calculateHeightForlblTextWithFont(_ inString:String,  _width :CGFloat, font : UIFont) -> CGFloat
{
    let constraintRect = CGSize(width: _width, height: CGFloat.greatestFiniteMagnitude)
    
    let boundingBox = inString.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [ NSFontAttributeName: font], context: nil)
    return boundingBox.height
}

func getVersion() -> String {
    let dictionary = Bundle.main.infoDictionary!
    let version = dictionary["CFBundleShortVersionString"] as! String
    let build = dictionary["CFBundleVersion"] as! String
    return "\(version) build \(build)"
}

func getQueryStringParameter(_ url: String, param: String) -> String? {
    
    let url = URLComponents(string: url)!
    
    return
        (((url.queryItems)! as [URLQueryItem]))
            .filter({ (item) in item.name == param }).first?
            .value!
}

var localTimeZoneName: String {
    return (NSTimeZone.local as NSTimeZone).name
}



func createHttpBody(sharingDictionary : NSMutableDictionary) -> Data
{
    let parameterArray : NSMutableArray = []
    
    for keyValue in sharingDictionary.allKeys
    {
        let keyString = "\(keyValue)=\(sharingDictionary[keyValue]!)"
        parameterArray.add(keyString)
    }
    var postString = String()
    
    postString = parameterArray.componentsJoined(by: "&")
    print(postString)
    
    return postString.data(using: .utf8)!
}

func convertString(string: String) -> String {
    let data = string.data(using: String.Encoding.ascii, allowLossyConversion: true)
    return NSString(data: data!, encoding: String.Encoding.ascii.rawValue)! as String
}

func isValidEmail(testStr:String) -> Bool {
    // print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

func checkSpecialCharacter(string : String)-> Bool {
   
  var isSpecialCharacter = false
    let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
    if string.rangeOfCharacter(from: characterset.inverted) != nil {
        isSpecialCharacter = true
    }
    
    return isSpecialCharacter
}


// MARK Alert View

func alertController(controller:UIViewController,title:String, message:String,okButtonTitle:String,completionHandler:@escaping (_ index: NSInteger) -> ()){
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: okButtonTitle, style: UIAlertActionStyle.default, handler:{ (action: UIAlertAction!) in
        completionHandler(0)
}))
   controller.present(alert, animated: true, completion: nil)

}

// MARK Alert for show 2 button action


func alertController(controller:UIViewController,title:String, message:String,okButtonTitle:String,cancelButtonTitle: String,completionHandler:@escaping (_ index: NSInteger) -> ()){
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
     alert.addAction(UIAlertAction(title: cancelButtonTitle, style: UIAlertActionStyle.default, handler:{ (action: UIAlertAction!) in
        completionHandler(0)
    }))
    alert.addAction(UIAlertAction(title: okButtonTitle, style: UIAlertActionStyle.default, handler:{ (action: UIAlertAction!) in
        completionHandler(1)
    }))
    controller.present(alert, animated: true, completion: nil)
    
}

// MARK: Phone Number validation

extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.characters.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}


func isDigits(value: String) -> Bool{
    
    if !value.isEmpty {
        
        let numberCharacters = NSCharacterSet.decimalDigits.inverted
        return !value.isEmpty && value.rangeOfCharacter(from: numberCharacters) == nil
    }
    return false
}

//MARK: Archive And Unarchive

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

func archive(filename :String, dict:NSDictionary){

    let data = NSKeyedArchiver.archivedData(withRootObject: dict)
    let fullPath = getDocumentsDirectory().appendingPathComponent(filename)
    
    do {
        try data.write(to: fullPath)
    } catch {
        print("Couldn't write file")
    }
}

func unArchive(fileName :String)-> NSDictionary{

    let fullPath = getDocumentsDirectory().appendingPathComponent(fileName)

    let loadedStrings = NSKeyedUnarchiver.unarchiveObject(withFile: fullPath.absoluteString) as? [String]
    
    return loadedStrings as Any as! NSDictionary
}



func convertArrayIntoJsonString(from object: Any) -> String? {
    if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
        let objectString = String(data: objectData, encoding: .utf8)
        return objectString
    }
    return nil
}

func convetDateIntoString(date :String)-> String{
    
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = "dd/MM/yyyy"
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM,yyyy"
    
    let date: Date? = dateFormatterGet.date(from: date)
    print(dateFormatter.string(from: date!))
    
    return (dateFormatter.string(from: date!))
}


