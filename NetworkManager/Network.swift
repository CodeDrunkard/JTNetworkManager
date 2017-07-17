//
//  Network.swift
//  Example
//
//  Created by JT Ma on 17/07/2017.
//  Copyright © 2017 JT Ma. All rights reserved.
//

import Foundation

public class Network {
    public static func request(_ url: String,
                               method: HTTPMethod = .GET,
                               parameters: [String: Any]? = nil,
                               headers: [String: String]? = nil) {
        let httpManager = HTTPManager()
        httpManager.request(url, method: method, parameters: parameters, headers: headers)
    }
    
    public static func update(_ url: String,
                              parameters: [String: Any]? = nil,
                              files: [UpdateFile],
                              boundary: String) {
        let httpManager = HTTPManager()
        httpManager.update(url, parameters: parameters, files: files, boundary: boundary)
    }
    
    public static func pinning(_ url: String,
                               method: HTTPMethod = .GET,
                               parameters: [String: Any]? = nil,
                               headers: [String: String]? = nil,
                               localCerDatas: [Data]){
        let httpManager = HTTPManager()
        httpManager.pinning(url, method: method, parameters: parameters, headers: headers, localCerDatas: localCerDatas)
    }
    
    public static func authorization(_ url: String,
                                     method: HTTPMethod = .GET,
                                     parameters: [String: Any]? = nil,
                                     headers: [String: String]? = nil,
                                     authurization: (String, String)) {
        let httpManager = HTTPManager()
        httpManager.authorization(url, method: method, parameters: parameters, headers: headers, authurization: authurization)
    }
}
