//
//  FileContentsViewControler.swift
//  FileManager
//
//  Created by Rodianov on 14.09.2020.
//  Copyright © 2020 Rodionova. All rights reserved.
//

import Foundation
import UIKit

class FileContentsViewController: UIViewController {
  
  private let fileURL: URL
  
  private let name: String
  
  private let textView: UITextView = {
    let textView = UITextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.font = .systemFont(ofSize: 18)
    textView.text = "no info passed"
    return textView
  }()
  
  init(fileURL: URL, name: String) {
    self.fileURL = fileURL
    self.name = name
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    self.title = name
    
    readFile(at: fileURL)
    
    view.addSubview(textView)
    
    NSLayoutConstraint.activate([
      textView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
      textView.bottomAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 1),
      textView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 1),
      textView.trailingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.trailingAnchor, multiplier: 1)
    ])
  }  
}

extension FileContentsViewController {
  private func readFile(at path: URL) {
    guard let fileText = try? String(contentsOf: path, encoding: .utf8) else {return}

    textView.text = fileText
  }
}
