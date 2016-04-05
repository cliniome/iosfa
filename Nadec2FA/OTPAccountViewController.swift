//
//  OTPAccountViewController.swift
//  Nadec2FA
//
//  Created by Mohamed Ibrahim on 3/18/1437 AH.
//  Copyright © 1437 Innovative Solutions. All rights reserved.
//

import Foundation

import UIKit
import MBCircularProgressBar

class OTPAccountViewController : UIViewController{
    
    @IBOutlet weak var OtpClock: MBCircularProgressBarView!
    
    @IBOutlet weak var OtpValue: UILabel!
    
    var MaxValue : CGFloat?
    var currentValue : CGFloat?
    var currentOTP : String?
    var timer : NSTimer?
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.onInit()
    }
    
    
    func onInit(){
        
        //clear the values first
        self.clearValues()
        //then start a new Timer
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "generateOTPAndUpdate", userInfo: nil, repeats: true)

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        if(abs(self.currentValue! - self.MaxValue!) >= 30){
            
            self.onInit()
        }
        
    }
    
    override func shouldAutorotate() -> Bool {
        
        if(UIDevice.currentDevice().orientation == .Portrait ||
        UIDevice.currentDevice().orientation == .PortraitUpsideDown)
        {
            return true
        }else{
            return false
        }
    }
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        
        return (UIInterfaceOrientation.Portrait)
    }

    
   
    
    func clearValues(){
        
        if (self.timer != nil){
            
            self.timer?.invalidate()
        }
        
        //Database Manager
        let db : DatabaseManager = DatabaseManager()
        if let data = db.ReturnData(){
            
            self.MaxValue = CGFloat(data.seconds!)
            self.currentValue = self.MaxValue
            
            //generate the otp
            let otpGenerator : OTPGenerationController = OTPGenerationController()
            if let otpValue = otpGenerator.generateOTP(data.seed! as String, digits: data.numDigits!,seconds: data.seconds!){
                
                 self.currentOTP = otpValue
            }
            //now view that onto the Circular Progress View
            self.OtpClock.maxValue=self.MaxValue!
            self.OtpClock.value=self.currentValue!
            self.OtpValue.text=self.currentOTP
            
        }
        
       
    }
    
    
    
    
    func generateOTPAndUpdate(){
        
        
        
        
        //initialize the database Manager
        self.currentValue = self.currentValue! - 1
        
        self.OtpClock.value=self.currentValue!
        
        if self.currentValue == 0 {
            
            if (self.timer != nil){
                
                self.timer?.invalidate()
                self.timer = nil
            }
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
}
