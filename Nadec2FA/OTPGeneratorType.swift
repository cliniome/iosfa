//
//  Common.swift
//  OTPGenerator
//
//  Created by Marcin Zbijowski on 29/09/15.
//  Copyright © 2015 CodeWise sp. z o.o. Sp. k. All rights reserved.
//

import Foundation

public enum OTPGeneratorType: Int, CustomStringConvertible {
    case HOTP, TOTP
    
    var title: String {
        switch self {
        case .HOTP: return NSLocalizedString("Counter based", comment: "Cell title")
        case .TOTP: return NSLocalizedString("Time based", comment: "Cell title")
        }
    }
    
    public var description: String {
        switch self {
        case .HOTP: return "<OTPGeneratorType: HOTP>"
        case .TOTP: return "<OTPGeneratorType: TOTP>"
        }
    }
}

let DEFAULTS_SECRET_KEY     = "DEFAULTS_SECRET_KEY"
let DEFAULTS_COUNTER_KEY    = "DEFAULTS_COUNTER_KEY"