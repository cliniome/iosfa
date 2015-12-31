//
//  SecureAccountViewController.swift
//  Nadec2FA
//
//  Created by Mohamed Ibrahim on 3/18/1437 AH.
//  Copyright © 1437 Innovative Solutions. All rights reserved.
//

import Foundation
import UIKit

class SecureAccountViewController : UIViewController{
    
    
    @IBOutlet weak var txtPasswordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        var endResult : Bool = false
        
        if let password = txtPasswordText.text {
            
            //initialize the database manager 
            //check from the database manager 
            //if the account is already activated and there is a password
            let databaseManager = DatabaseManager()
            endResult = databaseManager.isAccountActivated() && (databaseManager.ReturnData()!.pin == password)
        }
        
        if(endResult == false){
            
            
            let Alert : UIAlertView = UIAlertView(title: "Error", message: "Pin  Password is incorrect,Please Try again !", delegate: self, cancelButtonTitle: "Ok")
            
            Alert.show()
            
        }
        
        return endResult
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
        
    }
}
