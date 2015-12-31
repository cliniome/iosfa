//
//  JSONResult.swift
//  Nadec2FA
//
//  Created by Mohamed Ibrahim on 3/17/1437 AH.
//  Copyright © 1437 Innovative Solutions. All rights reserved.
//

import Foundation
import UIKit


/*
http://192.168.1.7:8080/imapp/rest/account/activate?id=c54a8f40-8909-467e-af42-dd549933d176

*/
class JSONResult {
    
    var accountName : NSString?
    var secretKey : NSString?
    var numDigits : Int?
    var seconds : Int?
    var seed : NSString?
    var active : Bool?
    var pin : String?
    
    
    init(){}
    
    init(account:NSString,key:NSString,digits:Int,seconds:Int,seed:NSString){
        
        self.accountName = account
        self.secretKey = key
        self.numDigits = digits
        self.seconds = seconds
        self.seed = seed
    }
    
}
