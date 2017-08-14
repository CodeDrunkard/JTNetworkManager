//
//  ViewController.swift
//  Example
//
//  Created by JT Ma on 26/03/2017.
//  Copyright © 2017 JT Ma. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        networkTest()
//        initWebView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func networkTest() {
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
    
    func initWebView() {
        let config = WKWebViewConfiguration()
        config.userContentController.add(self, name: "WKJSMessageHandler")
        webView = WKWebView(frame: view.bounds, configuration: config)
        view.addSubview(webView)
        let request = URLRequest(url: URL(string: "https://www.bing.com/")!)
        addJSPlugin(["Console"])
        webView.load(request)
        webView.navigationDelegate = self
        webView.uiDelegate = self
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
}

extension ViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: webView.title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (aa) -> Void in
            completionHandler()
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "WKJSMessageHandler" {
            if let dic = message.body as? Dictionary<String, Any>,
                let className = dic["className"] as? String,
                let functionName = dic["functionName"] as? String,
                let message = dic["message"] as? String {
                
                if let cls = NSClassFromString((Bundle.main.object(forInfoDictionaryKey: "CFBundleName")! as AnyObject).description + "." + className) as? NSObject.Type{
                    let obj = cls.init()
                    let functionSelector = Selector(functionName + ":")
                    if obj.responds(to: functionSelector) {
                        obj.perform(functionSelector, with: message)
                    } else {
                        print("方法未找到！")
                    }
                } else {
                    print("类未找到！")
                }
            }
        }
    }
}

// MARK: - JS Plugin
extension ViewController {
    func addJSPlugin(_ names: Array<String>) {
        for name in names {
            if let path = Bundle.main.path(forResource: name, ofType: "js", inDirectory: "www/plugins") {
                do {
                    let js = try String(contentsOfFile: path, encoding: .utf8)
                    webView.evaluateJavaScript(js, completionHandler: nil)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

class Callme: NSObject {
    func maybe() {
        print("反射成功！")
    }
}

class Console: NSObject {
    func log(message: String) {
        print(message)
    }
}
