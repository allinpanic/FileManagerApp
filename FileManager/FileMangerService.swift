//
//  FileMangerService.swift
//  FileManager
//
//  Created by Rodianov on 08.08.2020.
//  Copyright © 2020 Rodionova. All rights reserved.
//

import Foundation

struct FileManagerService {
  static let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
  
   func getContentList(at url: URL)-> [String] {
    var contentList: [String] = []
    let folderPath = url.path
    var fileArray: [String] = []
    
    guard let folderContents = try? FileManager.default.contentsOfDirectory(atPath: folderPath)
      else { return [] }
    
    for file in folderContents {
      let fileURL = url.appendingPathComponent(file)
      
      if fileURL.isDirectory {
        contentList.append(file)
      } else {
        fileArray.append(file)
      }
    }
    contentList.sort()
    fileArray.sort()
    contentList.append(contentsOf: fileArray)
    
    return contentList
  }
  
   func createDirectory(name: String, at url: URL) {
    let directoryURL = url.appendingPathComponent(name)
    try? FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: false, attributes: nil)
  }
  
   func createFile(name: String, at url: URL) {
    let filePath = url.path + "/" + name
    let fileData: Data? = "Hello world!".data(using: .utf8)
    FileManager.default.createFile(atPath: filePath, contents: fileData, attributes: nil)
  }
  
   func deleteFile(at url: URL, with name: String) {    
    let itemPath = url.appendingPathComponent(name)
    
    try? FileManager.default.removeItem(at: itemPath)
  }
}
