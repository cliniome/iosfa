//
//  TOTPGenerator.swift
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
 Time based OTP generator
 */
public class TOTPGenerator: OTPGenerator {

    /**
    Time period for which token is valid
     */
    private(set) public var period: NSTimeInterval

    /**
    Initializer for the time based generator.
     
    - parameter secret: Secret key on which generated keys will be based
    - parameter period: Time period for which token is valid
    - parameter pinLength: Length of generated tokens, must be between 1 and 8 digits, defaults to 6
    - parameter algorithm: Algorithm used for token generation, defaults to SHA1
    */
    public init?(secret: String, period: NSTimeInterval, pinLength: Int = 6, algorithm: OTPAlgorithm = OTPAlgorithm.SHA1) {
        self.period = period
        super.init(secret: secret, pinLength: pinLength, algorithm: algorithm)

        if period <= 0 || period > 300 {
            return nil
        }
    }

    /**
    Generates next available token
    */
    public func generateOTP() -> String? {
        return self.generateOTPForDate()
    }

    /**
    Generates token for given date, defaults to now
    
    - parameter date: Date for which token is generated
    - returns: Generated token or nil
    */
    public func generateOTPForDate(date: NSDate = NSDate()) -> String? {
        let seconds = currentTimeMillis()
        let counter = uint_fast64_t(seconds)
        return self.generateOTPForCounter(counter)
    }
    
    func currentTimeMillis() -> Int64{
        let nowDouble = NSDate().timeIntervalSince1970
        return Int64(nowDouble*1000)
    }

}