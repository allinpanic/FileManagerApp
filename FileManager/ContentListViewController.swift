//
//  ViewController.swift
//  FileManager
//
//  Created by Rodianov on 08.08.2020.
//  Copyright © 2020 Rodionova. All rights reserved.
//

import UIKit

class ContentListViewController: UIViewController {
  // MARK: - Private properties
  private let directory: String
  private let currentPath: URL?
  private var contents: [String]?
  private let fileManagerService = FileManagerService()
  
  private lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = .white
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
    tableView.dataSource = self
    tableView.delegate = self
    return tableView
  }()
  
  private lazy var addDirectoryButton: UIBarButtonItem = {
    let barButton = UIBarButtonItem(image: UIImage(named: "addDirectory"),
                                    style: .plain,
                                    target: self,
                                    action: #selector(addDirectoryButtonHadler))
    return barButton
  }()
  
  private lazy var addFileButton: UIBarButtonItem = {
    let barButton = UIBarButtonItem(image: UIImage(named: "addFile"),
                                    style: .plain,
                                    target: self,
                                    action: #selector(addFileButtonHadler))
    return barButton
  }()
  // MARK: - Inits
  
  init(directory: String, currentPath: URL) {
    self.directory = directory
    self.currentPath = currentPath
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - ViewDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    self.title = directory
    self.navigationItem.setRightBarButtonItems([addFileButton, addDirectoryButton], animated: true)
    
    guard let currentPath = currentPath else {return}
    contents = fileManagerService.getContentList(at: currentPath)
    
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
      tableView.bottomAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 1),
      tableView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 1),
      tableView.trailingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.trailingAnchor, multiplier: 1)
    ])
  }
}
// MARK: - TableViewDelegate, TableViewDataSource

extension ContentListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let contents = contents else {return 1}
    return contents.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
    
    guard let contents = contents,
      let url = currentPath?.appendingPathComponent(contents[indexPath.row])
      else {return UITableViewCell()}
    
    if url.isDirectory {
      cell.imageView?.image = UIImage(named: "directory")
    } else {
      cell.imageView?.image = UIImage(named: "file")
    }
    
    cell.textLabel?.text = "\(contents[indexPath.row])"
    return cell
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {      
      guard let currentPath = currentPath,
        let name = contents?[indexPath.row]
        else {return}
      
      fileManagerService.deleteFile(at: currentPath, with: name)
      contents?.remove(at: indexPath.row)
      tableView.reloadData()
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let contents = contents,
      let currentPath = currentPath
      else {return}
    
    let url = currentPath.appendingPathComponent(contents[indexPath.row])
    
    if url.isDirectory {
      navigationController?.pushViewController(ContentListViewController(directory: contents[indexPath.row],
                                                                         currentPath: url),
                                               animated: true)
    } else {
      navigationController?.pushViewController(FileContentsViewController(fileURL: url,
                                                                          name: contents[indexPath.row]),
                                               animated: true)
    }
  }
}
// MARK: - Button Handlers

extension ContentListViewController {
  @objc private func addDirectoryButtonHadler () {
    
    let alert = UIAlertController(title: "Directory name", message: nil, preferredStyle: .alert)
    alert.addTextField(configurationHandler: nil)
    
    let createAction = UIAlertAction(title: "Create", style: .default, handler: { [weak alert, weak self] _ in
      
      guard let newDirectoryName = alert?.textFields![0].text,
        let currentPath = self?.currentPath
        else {return}
      
      self?.fileManagerService.createDirectory(name: newDirectoryName, at: currentPath)
      self?.contents?.append(newDirectoryName)
      self?.tableView.reloadData()
    })
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
      self?.dismiss(animated: true, completion: nil)
    })
    
    alert.addAction(cancelAction)
    alert.addAction(createAction)
    self.present(alert, animated: true, completion: nil)
  }
  
  @objc private func addFileButtonHadler () {
    
    let alert = UIAlertController(title: "File name", message: nil, preferredStyle: .alert)
    alert.addTextField(configurationHandler: nil)
    
    let createAction = UIAlertAction(title: "Create", style: .default, handler: { [weak alert, weak self] _ in
      guard let newFileName = alert?.textFields![0].text,
        let currentPath = self?.currentPath
        else {return}
      
      self?.fileManagerService.createFile(name: newFileName, at: currentPath)
      self?.contents?.append(newFileName)
      self?.tableView.reloadData()
    })
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
      self?.dismiss(animated: true, completion: nil)
    })
    
    alert.addAction(cancelAction)
    alert.addAction(createAction)
    self.present(alert, animated: true, completion: nil)
  }
}
