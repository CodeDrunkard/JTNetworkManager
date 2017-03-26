//
//  DownloadManager.swift
//  JTNetworkManager
//
//  Created by JT Ma on 26/03/2017.
//  Copyright © 2017 JT Ma. All rights reserved.
//

import UIKit

public class DownloadManager: NSObject {
    
    public var destinationDirectory: String?
    
    var delegate: DownloadManagerDelegate?
    
    fileprivate var activeDownloads = [String: Download]()
    fileprivate var session: URLSession!
    
    public override init() {
        super.init()
        
        let configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    public init(_ backgroundIdentifier: String) {
        super.init()
        
        let configuration = URLSessionConfiguration.background(withIdentifier: backgroundIdentifier)
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    public func start(_ urlString: String) {
        if let url = URL(string: urlString) {
            let download = Download(url: urlString)
            download.task = session.downloadTask(with: url)
            download.task!.resume()
            download.isDownloading = true
            activeDownloads[urlString] = download
        }
    }
    
    public func suspend(_ urlString: String) {
        if let download = activeDownloads[urlString] {
            if download.isDownloading {
                download.task?.cancel() {
                    data in
                    if data != nil {
                        download.resumeData = data
                    }
                }
            }
            download.isDownloading = false
        }
    }
    
    public func resume(_ urlString: String) {
        if let download = activeDownloads[urlString], let url = URL(string: urlString) {
            if let resumeData = download.resumeData {
                download.task = session.downloadTask(withResumeData: resumeData)
            } else {
                download.task = session.downloadTask(with: url)
            }
            download.task!.resume()
            download.isDownloading = true
        }
    }
    
    public func cancel(_ urlString: String) {
        if let download = activeDownloads[urlString] {
            download.task?.cancel()
            activeDownloads[urlString] = nil
        }
    }
}

// MARK: - Download helper methods

extension DownloadManager {
    public func download(_ urlString: String) -> Download? {
        return activeDownloads[urlString]
    }
    
    public func downloadLocalUrl(_ previewUrl: String) -> URL? {
        if let url = URL(string: previewUrl), let destDir = destinationDirectory as NSString? {
            let lastPathComponent = url.lastPathComponent
            let fullPath = destDir.appendingPathComponent(lastPathComponent)
            return URL(fileURLWithPath:fullPath)
        }
        return nil
    }
    
    func removeLocalDownload(_ localUrl: String) {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: localUrl) {
            do {
                try fileManager.removeItem(atPath: localUrl)
            } catch let error {
                debugPrint("Could not remove file: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - URLSessionDownloadDelegate

extension DownloadManager: URLSessionDownloadDelegate {
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let originalURL = downloadTask.originalRequest?.url?.absoluteString, let destinationURL = downloadLocalUrl(originalURL) {
            debugPrint(destinationURL)
            
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: destinationURL.absoluteString) {
                do {
                    try fileManager.removeItem(at: destinationURL)
                } catch let error {
                    debugPrint("Could not remove file: \(error.localizedDescription)")
                }
            }
            do {
                try fileManager.copyItem(at: location, to: destinationURL)
            } catch let error {
                debugPrint("Could not copy file to disk: \(error.localizedDescription)")
            }
            
            delegate?.downloadDidFinished(downloadTask)
            activeDownloads[originalURL] = nil
        }
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if let downloadUrl = downloadTask.originalRequest?.url?.absoluteString,
            let download = activeDownloads[downloadUrl] {
            download.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
            download.totalSize = totalBytesExpectedToWrite
            
            delegate?.downloadUpdateProgress(download)
        }
    }
}

// MARK: - URLSessionTaskDelegate

extension DownloadManager: URLSessionTaskDelegate {
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let e = error {
            delegate?.downloadWhenError(e)
        }
    }
}

// MARK: - URLSessionDelegate

extension DownloadManager: URLSessionDelegate {
    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                DispatchQueue.main.async {
                    completionHandler()
                }
            }
        }
    }
}

// MARK: - DownloadManagerDelegate

public protocol DownloadManagerDelegate {
    func downloadDidFinished(_ task: URLSessionDownloadTask)
    func downloadUpdateProgress(_ download: Download)
    func downloadWhenError(_ error: Error)
}
