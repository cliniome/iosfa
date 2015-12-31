//
//  DatabaseManager.swift
//  Nadec2FA
//
//  Created by Mohamed Ibrahim on 3/18/1437 AH.
//  Copyright © 1437 Innovative Solutions. All rights reserved.
//

import Foundation
import UIKit


class DatabaseManager {
    
    var data : JSONResult?
    
    init(){
        
        self.doInit()
        
    }
    
    
    func isAccountActivated() -> Bool {
        
        var endResult : Bool = false
        
        if let data = self.ReturnData() {
            
            if let active = data.active{
                
                if active == true{
                    
                    endResult = true
                }
            }
        }
        
        return endResult
        
        
    }
    
    
    func WriteValueForKey(key: String , value : AnyObject?)->Bool{
       
        
        return self.saveDataFromDictionary(key, value: value)
        
    }
    
    func saveDataFromDictionary(key:String , value : AnyObject?) -> Bool{
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as? NSString
        let path = documentsDirectory!.stringByAppendingPathComponent("db.plist")
       
        //saving values
        let dict :NSMutableDictionary = NSMutableDictionary(contentsOfFile: path)!
        dict.setValue(value, forKey: key)
        //...
        //writing to db.plist
        dict.writeToFile(path, atomically: false)
        
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        print("Saved db.plist file is --> \(resultDictionary?.description)")
        
        return true
        
    }
    
    
    func ReturnData()-> JSONResult? {
        
        self.doInit()
        
        if(data != nil){
            
            return data
            
        }else{
            
            return nil
        }
    }
    
    func doInit() {
        // getting path to GameData.plist
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("db.plist")
        let fileManager = NSFileManager.defaultManager()
        //check if file exists
        if(!fileManager.fileExistsAtPath(path)) {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource("db", ofType: "plist") {
                _ = NSMutableDictionary(contentsOfFile: bundlePath)
                
                do{
                    
                     try fileManager.copyItemAtPath(bundlePath, toPath: path)
                    
                }catch {
                    
                    print("An Exception was thrown")
                    
                }
                
            } else {
                print("db.plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
            print("db.plist already exits at path.")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        print("Loaded db.plist file is --> \(resultDictionary?.description)")
        
        if let valuesDict = NSDictionary(contentsOfFile: path) {
            //loading values
            data = JSONResult()
            data?.accountName = valuesDict.valueForKey("accountName") as! String
            data?.numDigits = valuesDict.valueForKey("numDigits") as? Int
            data?.seconds = valuesDict.valueForKey("seconds") as? Int
            data?.seed = valuesDict.valueForKey("seedValue") as! String
            data?.active = valuesDict.valueForKey("active") as! Bool
            data?.pin = valuesDict.valueForKey("pin") as! String

            
            
        } else {
            print("WARNING: Couldn't create dictionary from db.plist! Default values will be used!")
        }
    }

    
    
}
