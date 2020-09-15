//
//  extension URL.swift
//  FileManager
//
//  Created by Rodianov on 08.09.2020.
//  Copyright © 2020 Rodionova. All rights reserved.
//

import Foundation

extension URL {
  var isDirectory: Bool {
    let values = try? resourceValues(forKeys: [.isDirectoryKey])
    return values?.isDirectory ?? false
  }
}
