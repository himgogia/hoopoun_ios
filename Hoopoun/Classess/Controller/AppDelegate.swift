//
//  AppDelegate.swift
//  Hoopoun
//
//  Created by vineet patidar on 16/08/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import TwitterKit
import IQKeyboardManagerSwift
import Firebase
import UserNotifications

extension UIColor {
 
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate{
    
    var lat : Double = Double()
    var long : Double = Double()
    var locality_id : String = ""
    var cityName : String = String()
    var profileLocation : String = String()
    var  userType : String = String()
    var walletImgFolderName : String = String()
    var offerImgFolderName : String = String()
    var offerSmallImgFolderName : String = String()
    var localiryHistoryArray : NSMutableArray  = NSMutableArray()
    var selectedTabbarItem : String = String()
    var deviceToken  : String = String()


    var addReviewButton : Bool = true
    
    var consumer_key: String = ""
    var consumer_secret: String = ""
       var selectedOfferId : String = ""
    var offerDictionary : NSMutableDictionary!

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12)], for: .normal)
        
        let selectedColor   = kLightGrayColor
        let unselectedColor = kLightBlueColor
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: unselectedColor], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: selectedColor], for: .normal)
        
   
        IQKeyboardManager.sharedManager().enable = true
        
        // fb login
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // google login
        
        GIDSignIn.sharedInstance().clientID = "567101789046-9vepm5ereg463c8blmemduj70mev5eud.apps.googleusercontent.com"
        
        // twitter  login
        TWTRTwitter.sharedInstance().start(withConsumerKey:"1uSRtzubVoARJVhOjZFp3pHXN", consumerSecret:"krCMz6fWU6jYRgSf5wzdHdrTG7SfFG3jilzLqB8TDrWbWxE901")
        
        // fire baseconsumerSecret
        FirebaseApp.configure()
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
       UINavigationBar.appearance().shadowImage = UIImage()

        UISearchBar.appearance().tintColor = UIColor.lightGray
        
        let navBackgroundImage:UIImage! = UIImage(named: "header")
        UINavigationBar.appearance().setBackgroundImage(navBackgroundImage, for: .default)
        
        // check device type
        
        if DeviceType.iPhone4orLess {
            walletImgFolderName = k300x180
            offerImgFolderName = k300x120
            offerSmallImgFolderName = k145x120
        }
        else  if DeviceType.iPhone678 || DeviceType.iPhone5orSE{
            walletImgFolderName = k600x360
            offerImgFolderName = k600x240
            offerSmallImgFolderName = k290x240
        }
        else if DeviceType.iPhone678p || DeviceType.iPhoneX{
            walletImgFolderName = k900x540
            offerImgFolderName = k900x360
            offerSmallImgFolderName = k435x360
        }
     //   registerForPushNotifications(application: application)
        
        // set Auto login
        if (kUserDefault.value(forKey: kloginInfo) != nil) {
            self.autoLogin()
        }
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self


        return true
    }
    
    func registerForPushNotifications(application: UIApplication) {
        
        let notificationSettings = UIUserNotificationSettings.init(types: [.badge, .sound, .alert], categories: nil  )
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    
    func autoLogin(){
        
        // set auto login data
        let loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
        if (loginInfoDictionary.value(forKey: kid) != nil) {
            
            
            if (loginInfoDictionary.value(forKey: klatitude) != nil && loginInfoDictionary.value(forKey: klongitude) != nil) {
                
                
                let lat  :String = String(format: "%@",loginInfoDictionary.value(forKey: klatitude) as! CVarArg)
                let lng  :String = String(format: "%@",loginInfoDictionary.value(forKey: klongitude) as! CVarArg)
                
                self.lat = Double(lat)!
                self.long = Double(lng)!
            }
            else if (loginInfoDictionary.value(forKey: klocality_id) != nil) {
                
                self.locality_id = loginInfoDictionary.value(forKey: klocality_id) as! String
                self.cityName = loginInfoDictionary.value(forKey: kcityName) as! String
            }
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyBoard.instantiateViewController(withIdentifier: "tabbarControllerID")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
    }
    
//    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
//        if notificationSettings.types != .none {
//            application.registerForRemoteNotifications()
//        }
//    }
//
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//    let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
//        print("==== didRegisterForRemoteNotificationsWithDeviceToken ====")
//        print("===== deviceTokenString =====")
//        print(deviceTokenString)
//        print("Ram001")
//    }
//
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Failed to register:", error)
//    }
//
//    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
//
//        print(userInfo)
//
//    }
    func applicationWillResignActive(_ application: UIApplication) {

    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
     
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
      
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
       
        self.locality_id = ""
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
       self.locality_id = ""
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        GIDSignIn.sharedInstance().handle(url as URL?,
                                          sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        
        var _: [String: AnyObject] = [UIApplicationOpenURLOptionsKey.sourceApplication.rawValue: sourceApplication as AnyObject,
                                      UIApplicationOpenURLOptionsKey.annotation.rawValue: annotation as AnyObject]
        
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    func getDeviceID()-> String{
        let deviceId :String = UIDevice.current.identifierForVendor!.uuidString
    return deviceId
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        self.deviceToken = String(fcmToken)

        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
       
    }
    private func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    
    
}

