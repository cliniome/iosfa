//
//  WelcomeViewController.swift
//  Nadec2FA
//
//  Created by Mohamed Ibrahim on 3/17/1437 AH.
//  Copyright © 1437 Innovative Solutions. All rights reserved.
//

import UIKit



class WelcomeViewController: UIViewController{
    
    
    
    //Bindings to the UI Controls
    //on the screen
    @IBOutlet weak var WelcomeView: UIWebView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.onInit()
    }
    
    
    func onInit(){
        
        //Load the File
        let htmlFile = NSBundle.mainBundle().pathForResource("welcomePage", ofType: "html")
       let htmlData: NSData? = NSData(contentsOfFile: htmlFile!)!
        let baseUrl : NSURL? = NSURL(fileURLWithPath: htmlFile!)
        WelcomeView.loadData(htmlData!, MIMEType: "text/html", textEncodingName: "UTF-8", baseURL: baseUrl!)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
