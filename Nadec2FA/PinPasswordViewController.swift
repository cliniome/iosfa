//
//  PinPasswordViewController.swift
//  Nadec2FA
//
//  Created by Mohamed Ibrahim on 3/17/1437 AH.
//  Copyright © 1437 Innovative Solutions. All rights reserved.
//

import UIKit


class PinPasswordViewController : UIViewController{
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.OnInit()
        
        
    }
    
    
    func OnInit(){
        
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
