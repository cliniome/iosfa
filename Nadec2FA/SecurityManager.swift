//
//  SecurityManager.swift
//  Nadec2FA
//
//  Created by Mohamed Ibrahim on 3/18/1437 AH.
//  Copyright © 1437 Innovative Solutions. All rights reserved.
//

import Foundation
import UIKit

class SecurityManager {
    
    
    
    func DecryptTripleDes(secretKey : String , decryptData : NSData) -> NSString?{
        
        let mydata_len : Int = decryptData.length
        let keyData : NSData = (secretKey as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
        
        let buffer_size : size_t = mydata_len+kCCBlockSizeAES128
        let buffer = UnsafeMutablePointer<NSData>.alloc(buffer_size)
        var num_bytes_encrypted : size_t = 0
        
        //_ : [UInt8] = [56, 101, 63, 23, 96, 182, 209, 205]  // I didn't use
        
        let operation: CCOperation = UInt32(kCCDecrypt)
        let algoritm:  CCAlgorithm = UInt32(kCCAlgorithm3DES)
        let options:   CCOptions   = UInt32(kCCOptionECBMode + kCCOptionPKCS7Padding)
        let keyLength        = size_t(kCCKeySize3DES)
        
        let decrypt_status : CCCryptorStatus = CCCrypt(operation, algoritm, options, keyData.bytes, keyLength, nil, decryptData.bytes, mydata_len, buffer, buffer_size, &num_bytes_encrypted)
        
        if UInt32(decrypt_status) == UInt32(kCCSuccess){
            
            let myResult : NSData = NSData(bytes: buffer, length: num_bytes_encrypted)
            free(buffer)
            print("decrypt \(myResult)")
            
            let stringResult = NSString(data: myResult, encoding:NSUTF8StringEncoding)
            print("my decrypt string \(stringResult)")
            
            return stringResult
        }else{
            free(buffer)
            return nil
            
        }
    }
    
    
}
