//
//  BarcodeScanningViewController.swift
//  Nadec2FA
//
//  Created by Mohamed Ibrahim on 3/17/1437 AH.
//  Copyright © 1437 Innovative Solutions. All rights reserved.
//

import UIKit
import KINBarCodeScanner
import SwiftyJSON
import RestEssentials


class BarcodeScanningViewController : UIViewController , KINBarCodeScannerDelegate{
    
    
    @IBOutlet weak var barcodeView: UIWebView!
    
    
    
    
    @IBOutlet weak var launchScannerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.onInit()
    }
    
    @IBAction func onLaunchScanner(sender: AnyObject) {
        
        
        let barCodeScannerViewController: KINBarCodeScannerViewController = KINBarCodeScannerViewController(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
        barCodeScannerViewController.delegate = self
        self.presentViewController(barCodeScannerViewController, animated: true, completion: { _ in })
        
    }
    func onInit(){
        
        
        let htmlFile = NSBundle.mainBundle().pathForResource("BarcodeScanning", ofType: "html")
        
        
        let htmlData : NSData? = NSData(contentsOfFile: htmlFile!)
        
        let contentsUrl : NSURL = NSURL(fileURLWithPath: htmlFile!)
        
        self.barcodeView.loadData(htmlData!
            , MIMEType: "text/html", textEncodingName: "UTF-8", baseURL: contentsUrl)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
    Called when a valid code string is detected
    */
     func barCodeScanner(barCodeScanner: KINBarCodeScannerViewController!, didDetectCodeString codeString: String!)
    {
         barCodeScanner.dismissViewControllerAnimated(true, completion: {_ in})
        
        NSLog("Code Detected :  \(codeString)")
        
        var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.frame = CGRectMake(0.0, 0.0, 80.0, 80.0)
        indicator.center = self.view.center
        self.view!.addSubview(indicator)
        indicator.bringSubviewToFront(self.view!)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        
        indicator.startAnimating()
        
        self.connectAndGetData(codeString,activityIndicator: &indicator)
    
        
        
        
    
    }
    
    
    func connectAndGetData(url : String ,inout activityIndicator : UIActivityIndicatorView)-> JSONResult? {
        
        guard let rest = RestController.createFromURLString(url) else {
            print("Bad URL")
            return nil
        }
        
        
        let data : JSONResult = JSONResult()
        
        
        
        rest.get(){ result in
            do {
                let json = try result.value()
                print(json)
                
                data.accountName = json["accountName"]?.stringValue
                data.numDigits = json["numDigits"]?.integerValue
                data.seconds = json["seconds"]?.integerValue
                data.secretKey = json["key"]?.stringValue
                data.seed = json["actualSeed"]?.stringValue
                
                
                
                //now take this data and save it , then , work on it
                
                if self.workOnData(data){
                    
                    activityIndicator.stopAnimating()
                    
                    activityIndicator.removeFromSuperview()
                    
                    
                    //now move to the secure account page
                    //get the main Storyboard by name 
                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                    //afterwards please access the navigation controller
                    let navigationController : UINavigationController = mainStoryBoard.instantiateViewControllerWithIdentifier("PROGRAMENTRY") as! UINavigationController
                    
                    self.presentViewController(navigationController, animated: true, completion: {_ in})
                
                }
                
               
                
            } catch {
                print("Error performing GET: \(error)")
            }
        }
        
        
        
        return data
    }
    
    /*

    let decodedData = NSData(base64EncodedString: base64String, options:NSDataBase64DecodingOptions.fromRaw(0)!)
    let decodedString = NSString(data: decodedData, encoding: NSUTF8StringEncoding)
    println(decodedString) // my plain data

*/
    
    func workOnData(jsonResult : JSONResult) -> Bool {
        
        
        
        //let decodedString = NSString(data:decodedData!,encoding:NSUTF8StringEncoding)
        let decodedSeed = NSData(base64EncodedString: jsonResult.seed! as String, options: NSDataBase64DecodingOptions(rawValue: 0))
        
        let decodedString = NSString(data:decodedSeed!,encoding:NSUTF8StringEncoding)
        
        jsonResult.seed = decodedString
        
       //now save the data
        let databaseManager : DatabaseManager = DatabaseManager()
        
        databaseManager.WriteValueForKey("seedValue", value: decodedString)
        databaseManager.WriteValueForKey("seconds", value: jsonResult.seconds)
        databaseManager.WriteValueForKey("numDigits", value: jsonResult.numDigits)
        databaseManager.WriteValueForKey("accountName", value: jsonResult.accountName)
        databaseManager.WriteValueForKey("active", value: true)
        
        return true;
    }
    
    /*
    Called when the user presses the cancel button before a code is detected
    */
     func didCancelBarCodeScanner(codeScanner: KINBarCodeScannerViewController!)
    {
        
    }
    
    /*
    Called on the delegate to determine if codeString is detectable
    
    If not implemented, all code strings will be detectable
    
    This method may be called frequently, so it must be efficient to prevent capture performance problems
    */
    
}
