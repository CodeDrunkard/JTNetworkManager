//
//  HTTPCookie.swift
//  Example
//
//  Created by JT Ma on 28/07/2017.
//  Copyright © 2017 JT Ma. All rights reserved.
//

import Foundation

public class HTTPCookieManager {
    let cookieStorage = HTTPCookieStorage.shared
    
    public func save(cookie: HTTPCookie) {
        cookieStorage.setCookie(cookie)
    }
    
    public func save(property: Dictionary<HTTPCookiePropertyKey, Any>) {
        if let cookie = HTTPCookie(properties: property) {
            save(cookie: cookie)
        }
    }
    
    public func save(property: CookieProperty) {
        if let cookie = HTTPCookie(properties: property.properties()) {
            save(cookie: cookie)
        }
    }
    
    public func clear(url: URL) {
        if let cookies = cookieStorage.cookies(for: url) {
            for cookie in cookies {
                cookieStorage.deleteCookie(cookie)
            }
        }
    }
    
    public func persistent(second: TimeInterval) {
        var props = Dictionary<HTTPCookiePropertyKey, Any>()
        props[HTTPCookiePropertyKey.expires] = Date().addingTimeInterval(second)
        if let cookie = HTTPCookie(properties: props) {
            save(cookie: cookie)
        }
    }
}
    
public struct CookieProperty {
    let version: Int
    let name: String
    let value: String
    let domain: String
    let path: String
    let port: Int
    let url: String
    let isSessionOnly: Bool
    
    func properties() -> Dictionary<HTTPCookiePropertyKey, Any> {
        var cookieProperties =  [HTTPCookiePropertyKey : Any]()
        cookieProperties[HTTPCookiePropertyKey.name] = name
        cookieProperties[HTTPCookiePropertyKey.value] = value
        cookieProperties[HTTPCookiePropertyKey.domain] = domain
        cookieProperties[HTTPCookiePropertyKey.originURL] = url
        cookieProperties[HTTPCookiePropertyKey.path] = path
        cookieProperties[HTTPCookiePropertyKey.version] = version
        cookieProperties[HTTPCookiePropertyKey.port] = port
        return cookieProperties
    }
}
