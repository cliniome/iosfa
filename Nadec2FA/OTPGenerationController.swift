//
//  OTPGenerationController.swift
//  Nadec2FA
//
//  Created by Mohamed Ibrahim on 3/18/1437 AH.
//  Copyright © 1437 Innovative Solutions. All rights reserved.
//

import Foundation
import UIKit
import OTPGenerator
import CryptoSwift
import AeroGear_OTP
import JKBigInteger



class OTPGenerationController {
    
    
    
    func generateOTPNormal(key:String,digits:Int)->String?{
        
let generator : TOTPGenerator = GeneratorFactory.generatorWithSecretKey(key, type: OTPGeneratorType.TOTP, digits: digits) as! TOTPGenerator
        
        return generator.generateOTPForDate()

        
        
    }
    
    func currentTimeMillis() -> Int64{
        let nowDouble = NSDate().timeIntervalSince1970
        return Int64(nowDouble*1000)
    }
    
    
    func hex2Bytes(key:String)->[UInt8] {
        
        let keyInteger = JKBigInteger(string:"10" + key, andRadix: 16)
        var keyBuffer : [UInt8] = [UInt8](count:Int(keyInteger.countBytes()),repeatedValue:0)
        keyInteger.toByteArraySigned(UnsafeMutablePointer<UInt8>(keyBuffer))
        keyBuffer.removeFirst()
        return keyBuffer
    }
    
    
    func generateOTP(key:String ,digits:Int,seconds : Int)->String? {
        
        let codeDigits = digits
        let result : NSString?
        //var time = "\(currentTimeMillis())"
        var time = "\(Int64(currentTimeMillis()) / Int64(30 * 1000))"
        
        while time.characters.count < 16 {
            
            time = "0" + (time as String)
        }
        
        print("Time after change : \(time)")
        
        let msg : String = String(time)
        let k : String = key
        
        
        //[0,0,0,0,0,0,0,0,0,0,0,0,0,0,115,110,111,117,116,111]
        let hmac = Authenticator.HMAC(key: Array(k.utf8) , variant: HMAC.Variant.sha1)
        
        //[0,1,69,20,119,81,86,39]
        let hash = try? hmac.authenticate(Array(msg.utf8))
        
        print("HMAC Value : \(hash)\n")
        
        var finalHash = hash!.map{
            
            Int32($0)
        }
        
        print("HMAC 32 : \(finalHash)\n")
        
        let fuckOffset = finalHash[finalHash.count - 1] & 0xf
        let offset = Int(fuckOffset)
        
        let one = ((finalHash[offset] & 0x7f) << 24)
        let two = ((finalHash[offset+1] & 0xff) << 16)
        let three = ((finalHash[offset+2] & 0xff) << 8)
        let four = (finalHash[offset+3] & 0xff)
        
        let binary = one | two | three | four
        
        print("Binary value : \(binary)\n")
        
        print("Pow Function : \(Int32(pow(Double(10), Double(codeDigits))))\n")
        
        let otp : Int32 = Int32(binary) % Int32(pow(Double(10), Double(codeDigits)))
        
        print("OTP Value : \(otp)\n")
        
        var finalOtp : NSString = String(format:"%d",otp) as NSString
        
        while finalOtp.length < codeDigits{
            
            finalOtp = "0" + (finalOtp as String)
        }
        
        return finalOtp as String
        
        
        
    }

}
