//
//  Download.swift
//  JTNetworkManager
//
//  Created by JT Ma on 26/03/2017.
//  Copyright © 2017 JT Ma. All rights reserved.
//


import Foundation
import QuartzCore

public class Download: NSObject {
    var url: String
    var isDownloading = false
    var task: URLSessionDownloadTask?
    var resumeData: Data?
    var localPath: String? //
    
    var progress: Float = 0
    var totalSize: Int64 = 0
    var totalSizeString: String {
        return byteFormatterString(totalSize)
    }
    var date: CFTimeInterval!
    private var _speed: Int64 = 0
    var speed: Int64 {
        if date == nil {
            date = CACurrentMediaTime()
        } else {
            let current = CACurrentMediaTime()
            let duration = Int64(current - date)
            if duration > 0 {
                _speed = totalSize / duration
                date = current
            }
        }
        return _speed
    }
    var speedString: String {
        return byteFormatterString(speed)
    }
    
    init(url: String) {
        self.url = url
    }
    
    func byteFormatterString(_ byte: Int64) -> String {
        return ByteCountFormatter.string(fromByteCount: byte, countStyle: .binary)
    }
}
