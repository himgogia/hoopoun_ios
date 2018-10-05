//
//  Costant.swift
//  Hoopoun
//
//  Created by vineet patidar on 17/08/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

struct ScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let maxLength = max(ScreenSize.width, ScreenSize.height)
    static let minLength = min(ScreenSize.width, ScreenSize.height)
    static let frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
}

struct DeviceType {
    static let iPhone4orLess = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength < 568.0
    static let iPhone5orSE = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 568.0
    static let iPhone678 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 667.0
    static let iPhone678p = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 736.0
    static let iPhoneX = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 812.0
    
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.maxLength == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.maxLength == 1366.0
}

// image folder name

// wallet
let k300x180 = "300x180"
let k600x360 = "600x360"
let k900x540 = "900x540"

// offer large
let k300x120 = "300x120"
let k600x240 = "600x240"
let k900x360 = "900x360"

// offer small
let k145x120 = "145x120"
let k290x240 = "290x240"
let k435x360 = "435x360"

// device



let kSignupSegueIdentifier = "signupSegueIdentifier"
let kVerifySegueIdentifier = "verifySegueIdentifier"
let kProfileSegueIdentifier = "profileSegueIdentifier"
let kForgotPasswordSegueIdentifier = "forgotPasswordSegueIdentifier"
let kChangePasswordSegueIdentifier = "changePasswordSegueIdentifier"
let kTabbarSegueIdentifier = "tabbarSegueIdentifier"
let kCategoryDetailsIdentifier = "categoryDetailsIdentifier"
let kcategoryOfferIdentifier = "categoryOfferIdentifier"
let kselectLocationSegueIdentifier = "selectLocationSegueIdentifier"
let kfiltersegieIdentifier = "filtersegieIdentifier"
let kcategorySegmentSegueIdentifier = "categorySegmentSegueIdentifier"
let kaddStoreReviewSegueIdentifier = "addStoreReviewSegueIdentifier"
let kredeemOfferSegieIdentifier = "redeemOfferSegieIdentifier"
let keditProfileSegueIdentifier = "segueEditProfile"
let khowItWorkSegueIdentifier = "howItWorkSegueIdentifier"
let kphysicalcardSegueIdentifier = "physicalcardSegueIdentifier"
let kmanualInputSegueIdentifier = "manualInputSegueIdentifier"
let kothercardSegueIdentifier = "othercardSegueIdentifier"
let kwalletDetailsSegieIdentifier = "walletDetailsSegieIdentifier"
let kcardScanneSegueIdentifier = "cardScanneSegueIdentifier"
let kecardSegueIdentifier = "ecardSegueIdentifier"
let ksearchcardSegueIdentifier  = "searchcardSegueIdentifier"
let khistorySegueIdentifier = "historySegueIdentifier"
let kmyFavoriteSegueIdentifier = "myFavoriteSegueIdentifier"
let kMyFavcardSotoryBoardID = "MyFavcardSotoryBoardID"
let kMyFavOfferStoryBoardID = "MyFavOfferStoryBoardID"
let kbusinessListSegueIdentifier = "businessListSegueIdentifier"
let ksearchStoryBoardID = "searchStoryBoardID"

//FONTS

let kFontSFUITextRegular  = "SFUIText-Regular"
let kFontSFUITextRegularBold  = "SFUIText-Bold"
let kFontSFUITextSemibold = "SFUIText-Semibold"
let kFontSFUITextLight  = "SFUIText-Light"
let kFontSFUITextMedium  = "SFUIText-Medium"

//let kBaseUrl = "http://staging.hoopoun.com/api/"

// let kProductionBaseUrl = "http://dev.hoopoun.com/admin/api_ios/"
 let kProductionBaseUrl = "http://www.hoopoun.com/admin/api_ios/"
let kStagingBaseUrl = "http://staging.hoopoun.com/api_ios/"

let kBaseUrl = kProductionBaseUrl


// story board id

let krightNowViewController = "rightNowViewController"
let karoundMeViewController  = "aroundMeViewController"
let khotDealViewController  = "hotDealViewController"

let kcategoryFilterViewController  = "categoryFilterViewController"
let klocationFilterViewController = "locationFilterViewController"

let kcategoryDetailsOfferStoryboard = "categoryDetailsOfferStoryboard"
let kcategoryDetailInfoStoryBoard = "categoryDetailInfoStoryBoard"
let kcategoryDetailReviewStoryBoard = "categoryDetailReviewStoryBoard"

let kCategorySegmentStoryBoardID = "CategorySegmentStoryBoardID"
let kWebViewController  = "webViewStoryBoardId"
let KMyProfileController = "myProfileStoryBoardId"
let KeditProfileController = "editProfileStoryBoardId"
let KSignupController = "signUpViewStoryBoardId"
let KHowItWorksController = "howitWorksStoryBoardId"
let kbarCodeViewstoryBoardID = "barCodeViewstoryBoardID"
let kcardOfferViewStoryBoardID = "cardOfferViewStoryBoardID"
let kSignupStoryBoardID = "SignupStoryBoardID"
let kSignInStoryBoardID = "SignInStoryBoardID"

// header
let KAboutus = "About us";



let kUserDefault  =  UserDefaults.standard
let kDefaultColor  = UIColor(red: 50.0/255.0, green:
    191.0/255.0, blue: 204.0/255.0, alpha: 1.0)
let kBlueColor  = UIColor(red: 29.0/255.0, green:
    123.0/255.0, blue: 175.0/255.0, alpha: 1.0)
let kLightBlueColor  = UIColor(red: 49.0/255.0, green:
    201.0/255.0, blue: 207.0/255.0, alpha: 1.0)
let kProfileLightBlueColor  = UIColor(red: 84.0/255.0, green:
    149.0/255.0, blue: 196.0/255.0, alpha: 1.0)
let kappColor  = UIColor(red: 0/255.0, green:
    208.0/255.0, blue: 206.0/255.0, alpha: 1.0)
let kLightGrayColor  = UIColor(red: 95.0/255.0, green:
   95.0/255.0, blue: 95.0/255.0, alpha: 1.0)



//  Device IPHONE
let kIphone_4s : Bool =  (UIScreen.main.bounds.size.height == 480)
let kIphone_5 : Bool =  (UIScreen.main.bounds.size.height == 568)
let kIphone_6 : Bool =  (UIScreen.main.bounds.size.height == 667)
let kIphone_6_Plus : Bool =  (UIScreen.main.bounds.size.height == 736)

let kIphoneWidth = UIScreen.main.bounds.size.width
let kIphoneHeight = UIScreen.main.bounds.size.height


//

let kPayload = "Payload"
let kCode =  "Code"
let kMessage = "Message"



// login

let kloginId  = "loginId"
let kpassword = "password"
let kloginInfo = "loginInfo"
let kGuestUserCart = "guestUserCart"


// signup

let kname = "name"
let kmobileNumber = "mobileNumber"
let kregister_type = "register_type"
let ksocialId  = "socialId"
let kstype = "stype"
let kfbId = "fbId"
let kgpId = "gPlusId"



let kdeviceToken = "deviceToken"
let kdeviceType = "deviceType"
let kdeviceId = "deviceId"
let kSocialLogin = "socialLogin"
let kfirst_name = "first_name"
let klast_name = "last_name"


let kid = "id"
let kIOS = "IOS"
let kimage = "image"
let kverificationId = "verificationId"
let ktransactionId = "transactionId"
let kemailId = "emailId"
let knewPassword = "newPassword"
let kconfirmPassword = "confirmPassword"
let koldPassword = "oldPassword"
let kcity = "city"
let kcountry = "country"
let kstatus = "status"
let kdob = "dob"
let kgender = "gender"
let kEmail = "email"
let kUrl = "url"


//API
let KmyProfile = "myProfile"
let KupdateProfile = "updateUser"
let KupdateProfileImage = "changeUserProfileImage"
let KTermAndConditionURL = "http://www.hoopoun.com/admin/apppage?id=2"
let KAboutUsURL = "http://www.hoopoun.com/admin/apppage?id=1"


// forgot password

let kforgotPassword = "forgotPassword"
let kchangePassword = "changePassword"


// Offer
let klatitude = "latitude"
let klongitude = "longitude"
let kcity_id = "city_id"
let kcategories_name = "categories_name"
let kcategory_id = "category_id"
let kiconFileName = "iconFileName"
let kst_distance = "st_distance"
let kuserid = "userid"

// near  me

let kofferImage = "offerImage"
let kofferTitle = "offerTitle"
let kofferType  = "offerType"
let kcoupon = "coupon"
let kdayId = "dayId"
let kdescription = "description"
let kdistance = "distance"
let kheads_name = "heads_name"
let kloyalityCard = "loyalityCard"
let koffer_id = "offer_id"
let kratting = "ratting"
let kstoreAddress = "storeAddress"
let kstoreId = "storeId"
let kstore_name = "store_name"
let ksubsubcategories_name = "subsubcategories_name"
let ktages = "tages"
let kterms = "terms"

// ccategories offres

let kcategoryOffersArray = "categoryOffersArray"
let ksort_by = "sort_by"
let kfilter_categories = "filter_categories"
let kfilter_location = "filter_location"
let kcat_id = "cat_id"
let kpage_no = "page_no"
let ksearch_city = "search_city"
let kaddress = "address"
let ksubcategoryId = "subcategoryId"
let kcategoryId = "categoryId"
let ksubcategoryName = "subcategoryName"
let ksubsubCatId = "subsubCatId"
let kcityName = "cityName"
let klocalityId = "localityId"
let kexpire_date = "expire_date"
let kimage_path = "image_path"
let kimage_name = "image_name"
let kkeyword = "keyword"
let klocality = "locality"

// location search
let kpopular_status = "popular_status"

// offers details

let kstore_id = "store_id"
//let kstatus = "status"
let kislike =  "islike"

let koffers_timming = "offers_timming"
let koffers_list = "offers_list"
let kdayname = "day"
let ktimming = "time"
let kstore_timming = "store_timming"
let koffer_status = "offer_status"

// Store Review
let kuserName = "userName"
let kreview = "review"
let kcreated_on = "created_on"
let kuserImage = "userImage"
let krating = "rating"


// card Type

let kphysicalcard = "physicalcard"
let kcard_name = "card_name"
let kcard_type_id = "card_type_id"
let kProgramName = "ProgramName"
let kcard_image = "card_image"
let kcard_no = "card_no"
let kcardRelatedToId  = "cardRelatedToId"

let kcardRelatedToName = "cardRelatedToName"
let kcard_back_img = "card_back_img"
let kcard_front_img = "card_front_img"
let kcard_type = "card_type"
let kcreatedon = "createdon"
let kfavorite = "favorite"
let kcardId = "cardId"

let keditcard = "editcard"


// Rewards
let koffer = "offer"
let kLocality = "Locality"
let ktotalOfferNo = "totalOfferNo"
let kusedOfferNo = "usedOfferNo"
let kredeemDay = "redeemDay"
let kguestUser = "guestUser"

let klocality_id = "locality_id"
let klocationLocalData = "locationLocalData"







