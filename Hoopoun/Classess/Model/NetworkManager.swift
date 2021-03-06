
import UIKit

class NetworkManager: NSObject,XMLParserDelegate {

    class var sharedInstance: NetworkManager {
   
        struct Static {
            static let instance = NetworkManager()
        }
        return Static.instance
    }
    
    //MARK: Download Image Method
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    
 //MARK: Post request with json data method
    
    func postRequest(_ url: URL, hude:Bool,showSystemError:Bool,loadingText:Bool, params: NSMutableDictionary, completionHandler:@escaping (_ response: NSDictionary) -> Void) {
        
       // show hude
        if hude == true {
            showHude()
        }
        
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: url)
        let session = URLSession.shared
        urlRequest.httpMethod = "POST"
        print(params)
        
        let httpData = createHttpBody(sharingDictionary: params)
        
        urlRequest.httpBody = httpData
        print(urlRequest.httpBody!)
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        

            let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: {
                
                (data, response, error) -> Void in
                
                // hide hude
                DispatchQueue.main.sync {
                    hideHude()
                }
                
                 let appDelegate :AppDelegate = UIApplication.shared.delegate as! AppDelegate
                
                if error != nil {
                    print("Error occurred: "+(error?.localizedDescription)!)
                    
                    DispatchQueue.main.sync {
                    }
                   
                    alertController(controller:(appDelegate.window?.rootViewController)! , title: "", message: (error?.localizedDescription)!, okButtonTitle: "OK", completionHandler: {(index)-> Void in
                    })
                    return;
                }
                do {

                    
                    let responseObjc = try (JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary) as Dictionary
                    
                    completionHandler(responseObjc as NSDictionary)
                }
                catch {
                    print("Error occurred parsing data: \(error)")
//                    alertController(controller:(appDelegate.window?.rootViewController)! , title: "", message: (error.localizedDescription), okButtonTitle: "OK", completionHandler: {(index)-> Void in
//                        
//                    })
                    return;
                    //completionHandler([:])
                }
                
            }) 
            
            task.resume()
    }
    
    
    //MARK: getRequest request method
    
    func getRequest(_ url: URL, hude:Bool,showSystemError:Bool,loadingText:Bool, params: NSMutableDictionary, completionHandler:@escaping (_ response: Dictionary <String, AnyObject>?) -> Void) {
        
        // show hude
        if hude == true {
            showHude()
        }

        
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: url)
        let session = URLSession.shared
        urlRequest.httpMethod = "GET"
        print(params)
        
        
        urlRequest.httpBody = nil
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: {
            
            (data, response, error) -> Void in
            
            // hide hude
            DispatchQueue.main.sync {
                hideHude()
            }
            
            if error != nil {
                print("Error occurred: "+(error?.localizedDescription)!)
                
                DispatchQueue.main.sync {
                }
                let appDelegate :AppDelegate = UIApplication.shared.delegate as! AppDelegate
                
                alertController(controller:(appDelegate.window?.rootViewController)! , title: "", message: (error?.localizedDescription)!, okButtonTitle: "OK", completionHandler: {(index)-> Void in
                    
                })
                return;
            }
            do {
                let responseObjc = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject]
                completionHandler(responseObjc)
            }
            catch {
                print("Error occurred parsing data: \(error)")
                completionHandler([:])
            }
            
        })
        
        task.resume()
    }
    
    
    
    
    
    //MARK: Post image with Key value request method
    func postRequestWithImage(_ dict:NSMutableDictionary,urlStr:NSString,img:UIImageView) -> NSArray {
        let requestURL: URL = URL(string: urlStr as String)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL)
        let session = URLSession.shared
        urlRequest.httpMethod = "POST"
        let boundary = generateBoundaryString()
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        if img.image==nil {
               return ([])
        }
        
        
        let imageData = UIImageJPEGRepresentation(img.image!, 1)
        
        if(imageData==nil)  {
            return ([])
        
        }
        
        urlRequest.httpBody = postBodyWithParameters(dict, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)

        let responseArr=NSArray()
        DispatchQueue.main.async(execute: {
            
            let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: {
                (data, response, error) -> Void in
                
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200) {
                    print("Everyone is fine.")
                    
                    do{
                        
                        let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)as! NSDictionary
                        // You can print out response object
                        
                        print(json)
                        let paylod = json.value(forKey: "payload") as? NSArray
                        
                        print(paylod!)
                        
                    }catch {
                        print("Error with Json: \(error)")
                    }
                    
                }
            }) 
            
            task.resume()
        })
        return responseArr
    }
    
    
    func postBodyWithParameters(_ dict:NSMutableDictionary?, filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
        let body = NSMutableData();
        
        if dict != nil {
            for (key, value) in dict! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey)
        body.appendString("\r\n")
        
        
        
        body.appendString("--\(boundary)--\r\n")
        
        return body as Data
    }
    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    
    
    //MARK: XML Post dict with Key value request method
    func postXMLRequest(_ dict:NSMutableDictionary,urlStr:NSString)
    {
        
        let url = URL(string: urlStr as String )
      //  var xmlParse:NSString  = ""
       // var data : Data
        let request = NSMutableURLRequest(url: url!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
       // var error: NSError?
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: dict, options: [])
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            if data == nil {
                print("dataTaskWithRequest error: \(String(describing: error))")
                return
            }
            
            let parser = XMLParser(data: data!)
            parser.delegate = self
            parser.parse()
            
            // you can now check the value of the `success` variable here
        }) 
        task.resume()
        
    }
    
    var elementValue: String?
    var success = false
    
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var title1 = NSMutableString()
    var date = NSMutableString()
    
    
    //MARK: parser delegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "item")
        {
            elements = NSMutableDictionary()
            elements = [:]
            title1 = NSMutableString()
            title1 = ""
            date = NSMutableString()
            date = ""
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if element.isEqual(to: "title") {
            title1.append(string)
        } else if element.isEqual(to: "pubDate") {
            date.append(string)
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqual(to: "item") {
            if !title1.isEqual(nil) {
                elements.setObject(title1, forKey: "title" as NSCopying)
            }
            if !date.isEqual(nil) {
                elements.setObject(date, forKey: "date" as NSCopying)
            }
            
            posts.add(elements)
        }
    }
   }
extension NSMutableData {
    
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}


