//
//  PinPasswordViewController.swift
//  Nadec2FA
//
//  Created by Mohamed Ibrahim on 3/17/1437 AH.
//  Copyright © 1437 Innovative Solutions. All rights reserved.
//

import UIKit


class PinPasswordViewController : UIViewController {
    
    
    @IBOutlet weak var txtPinPassword: UITextField!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        var endResult : Bool = false
        
        let chosenPin : NSString = txtPinPassword.text!
        
        if(chosenPin.length < 4)
        {
            //should show an alert view instead
            let alertView : UIAlertView = UIAlertView(title: "Error", message: "You have To choose at least 4 AlphaNumeric Characters as a Pin Password", delegate: self, cancelButtonTitle: "Cancel")
            
            alertView.show()
            
            
        }else{
            
            endResult = true
        }
        
        
        return endResult
    }
    
    
    
    
   
    @IBAction func onNextClick(sender: AnyObject) {
        
        
        let databaseManager : DatabaseManager = DatabaseManager()
        
        
        if let Pin :String? = txtPinPassword.text!{
            
            databaseManager.saveDataFromDictionary("pin", value: Pin)
            
            NSLog("PinPassword Was Written Successfully")
        }
        
        
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
