//
//  HTTPManager.swift
//  Example
//
//  Created by JT Ma on 27/03/2017.
//  Copyright © 2017 JT Ma. All rights reserved.
//

import Foundation

public class HTTPManager: NSObject {
    
    fileprivate var localCerDatas = [Data]()
    fileprivate var localPKCSData = Data()
    fileprivate var localPKCSPassword = ""
    
    public func request(_ url: String,
                        method: HTTPMethod = .GET,
                        parameters: [String: Any]? = nil,
                        headers: [String: String]? = nil) {
        var newURL = url;
        
        if method == .GET {
            newURL += "?" + buildParams(parameters ?? [:])
        }
        var request = URLRequest(url: URL(string: newURL)!)
        request.httpMethod = method.rawValue
        
        if method == .POST {
            if let headers = headers {
                for (headerField, headerValue) in headers {
                    request.setValue(headerValue, forHTTPHeaderField: headerField)
                }
            }
            request.httpBody = buildParams(parameters ?? [:]).data(using: .utf8)
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if (data != nil) && (error == nil) {
                let string = String(data: data!, encoding: .utf8)
                print("Request")
                print(string ?? "value_is_nil")
            } else {
                print(error.debugDescription)
            }
        }
        task.resume()
    }
    
    public func update(_ url: String,
                       parameters: [String: Any]? = nil,
                       files: [UpdateFile],
                       boundary: String) {
        guard files.count > 0 else {
            return
        }
        
        var data = Data()
        if let parameters = parameters {
            for (key, value) in parameters {
                data.append("--\(boundary)\r\n".dataOfUTF8)
                data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".dataOfUTF8)
                data.append("\(value)\r\n".dataOfUTF8)
            }
        }
        for file in files {
            data.append("--\(boundary)\r\n".dataOfUTF8)
            data.append("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.url.lastPathComponent)\"\r\n\r\n".dataOfUTF8)
            if let content = NSData(contentsOf: file.url) {
                data.append(content as Data)
                data.append("\r\n".dataOfUTF8)
            }
        }
        data.append("--\(boundary)\r\n".dataOfUTF8)
        
        let newURL = url;
        var request = URLRequest(url: URL(string: newURL)!)
        request.httpMethod = HTTPMethod.POST.rawValue
        request.setValue("multipart/form-data; boundary=" + boundary, forHTTPHeaderField: "Content-Type")
        request.httpBody = data

        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if (data != nil) && (error == nil) {
                let string = String(data: data!, encoding: .utf8)
                print("Update")
                print(string ?? "value_is_nil")
            } else {
                print(error.debugDescription)
            }
        }
        task.resume()
    }
    
    public func authorization(_ url: String,
                              method: HTTPMethod = .GET,
                              parameters: [String: Any]? = nil,
                              headers: [String: String]? = nil,
                              authurization: (String, String)) {
        var newURL = url;
        
        if method == .GET {
            newURL += "?" + buildParams(parameters ?? [:])
        }
        var request = URLRequest(url: URL(string: newURL)!)
        request.httpMethod = method.rawValue
        
        if method == .POST {
            if let headers = headers {
                for (headerField, headerValue) in headers {
                    request.setValue(headerValue, forHTTPHeaderField: headerField)
                }
            }
            request.httpBody = buildParams(parameters ?? [:]).data(using: .utf8)
        }
        
        let authString = "Basic " + (authurization.0 + ":" + authurization.1).base64
        request.addValue(authString, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if (data != nil) && (error == nil) {
                let string = String(data: data!, encoding: .utf8)
                print("Authorization")
                print(string ?? "value_is_nil")
            } else {
                print(error.debugDescription)
            }
        }
        task.resume()
    }
    
    public func pinning(_ url: String,
                        method: HTTPMethod = .GET,
                        parameters: [String: Any]? = nil,
                        headers: [String: String]? = nil,
                        localCerDatas: [Data]) {
        var newURL = url;
        self.localCerDatas = localCerDatas;
        
        if method == .GET {
            newURL += "?" + buildParams(parameters ?? [:])
        }
        var request = URLRequest(url: URL(string: newURL)!)
        request.httpMethod = method.rawValue
        
        if method == .POST {
            if let headers = headers {
                for (headerField, headerValue) in headers {
                    request.setValue(headerValue, forHTTPHeaderField: headerField)
                }
            }
            request.httpBody = buildParams(parameters ?? [:]).data(using: .utf8)
        }
        
        let sessionConfiguration = URLSession.shared.configuration
        let session = URLSession(configuration: sessionConfiguration,
                                 delegate: self,
                                 delegateQueue: URLSession.shared.delegateQueue)
        let task = session.dataTask(with: request) { (data, response, error) in
            if (data != nil) && (error == nil) {
                let _ = String(data: data!, encoding: .utf8)
                print("Pinning Success")
            } else {
                print(error.debugDescription)
            }
        }
        task.resume()
    }
    
    public func pinning(_ url: String,
                        method: HTTPMethod = .GET,
                        parameters: [String: Any]? = nil,
                        headers: [String: String]? = nil,
                        localCerDatas: [Data],
                        localPKCSData: Data,
                        localPKCSPassword: String) {
        var newURL = url;
        self.localCerDatas = localCerDatas;
        self.localPKCSData = localPKCSData
        self.localPKCSPassword = localPKCSPassword
        
        if method == .GET {
            newURL += "?" + buildParams(parameters ?? [:])
        }
        var request = URLRequest(url: URL(string: newURL)!)
        request.httpMethod = method.rawValue
        
        if method == .POST {
            if let headers = headers {
                for (headerField, headerValue) in headers {
                    request.setValue(headerValue, forHTTPHeaderField: headerField)
                }
            }
            request.httpBody = buildParams(parameters ?? [:]).data(using: .utf8)
        }
        
        let sessionConfiguration = URLSession.shared.configuration
        let session = URLSession(configuration: sessionConfiguration,
                                 delegate: self,
                                 delegateQueue: URLSession.shared.delegateQueue)
        let task = session.dataTask(with: request) { (data, response, error) in
            if (data != nil) && (error == nil) {
                let _ = String(data: data!, encoding: .utf8)
                print("Pinning Success")
            } else {
                print(error.debugDescription)
            }
        }
        task.resume()
    }
}

extension HTTPManager: URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if localCerDatas.count == 0 {
            completionHandler(.useCredential, nil)
            return
        }
        
        switch challenge.protectionSpace.authenticationMethod {
        case NSURLAuthenticationMethodServerTrust:
            if let serverTrust = challenge.protectionSpace.serverTrust,
                let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
                let remoteCertificateData: Data = SecCertificateCopyData(certificate) as Data
                
                var checked = false
                
                for localCertificateData in localCerDatas {
                    if localCertificateData as Data == remoteCertificateData {
                        if !checked {
                            checked = true
                        }
                    }
                }
                
                if checked {
                    let credential = URLCredential(trust: serverTrust)
                    challenge.sender?.use(credential, for: challenge)
                    completionHandler(.useCredential, credential)
                } else {
                    challenge.sender?.cancel(challenge)
                    completionHandler(.cancelAuthenticationChallenge, nil)
                    DispatchQueue.main.async {
                        print("Pinning Error")
                    }
                    return
                }
            } else {
                print("Get RemoteCertificateData error!")
            }
            break
        case NSURLAuthenticationMethodClientCertificate:
            let localPKCSOptions = [kSecImportExportPassphrase as String: localPKCSPassword]
            var localPKCSItems: CFArray?

            let secState = SecPKCS12Import(localPKCSData as CFData, localPKCSOptions as CFDictionary, &localPKCSItems)
            if secState == errSecSuccess, let certItems = localPKCSItems {
                let dict = (certItems as Array).first;
                if let certEntry = dict as? Dictionary<String, AnyObject> {
                    let secIdentity = certEntry["identity"] as! SecIdentity
                    let _ = certEntry["trust"] as! SecTrust
                    let secChain = certEntry["chain"]
                    
                    let credential = URLCredential(identity: secIdentity, certificates: secChain as? [Any], persistence: .forSession)
                    completionHandler(.useCredential, credential)
                } else {
                    completionHandler(.cancelAuthenticationChallenge, nil)
                }
            } else {
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
            break
        default:
            completionHandler(.cancelAuthenticationChallenge, nil)
            break
        }
    }
}

extension HTTPManager {

    func buildParams(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        for key in Array(parameters.keys).sorted(by: <) {
            let value = parameters[key]
            components += queryComponents(key, value ?? "value_is_nil")
        }
        
        return components.map{"\($0)=\($1)"}.joined(separator: "&")
    }

    func queryComponents(_ key: String, _ value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        var valueString = ""
        
        switch value {
        case _ as String:
            valueString = value as! String
        case _ as Bool:
            valueString = (value as! Bool).description
        case _ as Double:
            valueString = (value as! Double).description
        case _ as Int:
            valueString = (value as! Int).description
        default:
            break
        }
        
        components.append(contentsOf: [(escape(key), escape(valueString))])
        return components
    }

    func escape(_ string: String) -> String {
        let legalURLCharactersToBeEscaped: CFString = ":&=;+!@#$()',*" as CFString
        return CFURLCreateStringByAddingPercentEscapes(nil, string as CFString!, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
}

extension String {
    var dataOfUTF8: Data {
        return self.data(using: .utf8)!
    }
    
    var base64: String {
        let utf8EncodeData: Data! = self.data(using: String.Encoding.utf8, allowLossyConversion: true)
        let base64EncodingData = utf8EncodeData.base64EncodedString(options: [])
        return base64EncodingData
    }
}
