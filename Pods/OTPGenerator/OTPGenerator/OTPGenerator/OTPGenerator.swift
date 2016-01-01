//
//  OTPGenerator.swift
//
// Copyright 2015 Codewise sp. z o.o. Sp. K.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

/**
Encapsulates data for actual token generation.
*/
public enum OTPAlgorithm: Int {
    case SHA1, SHA256, SHA512, MD5

    var algorithm: CCHmacAlgorithm {
        switch self {
        case SHA1:   return CCHmacAlgorithm(kCCHmacAlgSHA1)
        case SHA256: return CCHmacAlgorithm(kCCHmacAlgSHA256)
        case SHA512: return CCHmacAlgorithm(kCCHmacAlgSHA512)
        case MD5:    return CCHmacAlgorithm(kCCHmacAlgMD5)
        }
    }

    var hashLength: Int32 {
        switch self {
        case SHA1:   return CC_SHA1_DIGEST_LENGTH
        case SHA256: return CC_SHA256_DIGEST_LENGTH
        case SHA512: return CC_SHA512_DIGEST_LENGTH
        case MD5:    return CC_MD5_DIGEST_LENGTH
        }
    }

}

protocol OTPGeneratorProtocol {
    func generateOTPForCounter(counter: uint_fast64_t) -> String?
    func generateOTP() -> String?
}

extension OTPGeneratorProtocol {
    /**
    Default implementation for method protocol method returns nil
     
    - returns: nil
    */
    func generateOTP() -> String? {
        return nil
    }
}

/**
Base class for generator, this is a place where magic happens
*/
public class OTPGenerator: OTPGeneratorProtocol {

    private var secretKey: NSData
    private var pinModeTable = [0, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000]
    private var pinLength: Int
    private var algorithm: OTPAlgorithm

    /**
    Base initializer for generators. It may fail if requested token length
    is out of bounds (too short or too long).
     
    - parameter secret: key on which generated keys will be based
    - parameter pinLength: Length of generated tokens, must be between 1 and 8 digits
    - parameter algorithm: Algorigthm used for token generation, defaults to SHA1
    */
    internal init?(secret: String, pinLength: Int = 6, algorithm: OTPAlgorithm = OTPAlgorithm.SHA1) {
        self.secretKey = secret.dataUsingEncoding(NSUTF8StringEncoding)!
        self.pinLength = pinLength
        self.algorithm = algorithm

        if pinLength < 1 || pinLength > 8 {
            return nil
        }
    }

    /**
    Token generation for given counter. It uses CommonCrypto module
    to do actual token computing.
     
    - parameter counter: Value for which token is generated
    - returns: Generated token or nil
    */
    

    
    
    
    func generateOTPForCounter(counter: uint_fast64_t) -> String? {
        guard let hash = NSMutableData(length: Int(self.algorithm.hashLength)) else {
            return nil
        }

        //var newCounter = NSSwapHostLongLongToBig(counter)
        var newCounter = counter
        let counterData = NSData(bytes: &newCounter, length: sizeof(uint_fast64_t))
        let algorithm: CCHmacAlgorithm = self.algorithm.algorithm

        var ctx = CCHmacContext()
        CCHmacInit(&ctx, algorithm, self.secretKey.bytes, self.secretKey.length)
        CCHmacUpdate(&ctx, counterData.bytes, counterData.length)
        CCHmacFinal(&ctx, hash.mutableBytes)

        let count = hash.length / sizeof(CChar)
        var array = [CChar](count: count, repeatedValue: 0)
        hash.getBytes(&array, length: count * sizeof(CChar))

        let offset = Int(array[self.algorithm.hashLength - 1] & 0x0f)

        let pinBytes: [CChar] = [array[offset], array[offset + 1], array[offset + 2], array[offset + 3]]
        let u32 = UnsafePointer<UInt32>(pinBytes).memory

        let truncated = NSSwapBigIntToHost(u32) & 0x7fffffff
        let pinValue = Int(truncated) % self.pinModeTable[self.pinLength]

        return String(format: "%0*u", self.pinLength, pinValue)
    }

}