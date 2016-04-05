//
//  PasswordVerificationStep.swift
//  Nadec2FA
//
//  Created by Mohamed Ibrahim on 5/15/1437 AH.
//  Copyright © 1437 Innovative Solutions. All rights reserved.
//

import Foundation
import UIKit

class PasswordVerificationStep : UIViewController
{
    
    @IBOutlet weak var passwordConfirmText: UITextField!
    
    var endResult : Bool = false
    
   
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        return endResult
    }
    
   
    @IBAction func onNextBtnClick(sender: AnyObject) {
        
        
        let databaseManager : DatabaseManager = DatabaseManager()
        let jsonResults : JSONResult = databaseManager.ReturnData()!
        
        if jsonResults.pin == passwordConfirmText.text! {
            
            endResult = true
            
        }else
        {
            //clear the password 
            passwordConfirmText.text = ""
            //Perform a conditional segue in here  MAINPROGRAMENTRY
            
            let Alert : UIAlertView = UIAlertView(title: "Error", message: "Pin Password does not match , Please return back and modify it", delegate: self, cancelButtonTitle: "Ok")
            
            Alert.show()
        }

        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
}