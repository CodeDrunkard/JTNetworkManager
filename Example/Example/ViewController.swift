//
//  ViewController.swift
//  Example
//
//  Created by JT Ma on 26/03/2017.
//  Copyright © 2017 JT Ma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Network.request("https://httpbin.org/post",
                        method: .POST,
                        parameters: ["key": "parameters"],
                        headers: nil)
        
        Network.request("https://httpbin.org/get",
                        method: .GET,
                        parameters: ["key": "parameters"],
                        headers: nil)
        
        Network.request("https://httpbin.org/headers",
                        method: .GET,
                        parameters: nil,
                        headers: ["Accept-Language": "Pitaya Language", "parameters": "ya"])
        
        let fileURL = Bundle(for: ViewController.self).url(forResource: "Info", withExtension: "plist")!
        let file = UpdateFile(name: "file", url: fileURL)
        Network.update("https://updateurl",
                       files: [file],
                       boundary: "boundary")
        
        let certURL = Bundle(for: ViewController.self).url(forResource: "lvwenhancom", withExtension: "cer")!
        let certData = try! Data(contentsOf: certURL)
        Network.pinning("https://lvwenhan.com/",
                        method: .GET,
                        localCerDatas: [certData])
        Network.pinning("https://lvwenhan.com/get",
                        method: .GET,
                        localCerDatas: [certData])
        
        Network.authorization("https://httpbin.org/basic-auth/user/passwd", authurization: ("user", "passwd"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

