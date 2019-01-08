//
//  ViewController.swift
//  JPMC
//
//  Created by B0095764 on 1/7/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = PlanetViewModel()
    
    /**
     View controller's life cycle methods.
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Loading..."

        NotificationCenter.default.addObserver(self, selector: #selector(fetchTableDataAndDisplay(notification:)), name: NSNotification.Name(rawValue: Constants.kCoreDataStackInitialized), object: nil)

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.register(UINib.init(nibName: "PlanetViewCell", bundle: nil), forCellReuseIdentifier: TableConstants.tableViewCellID)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    /**
     UITableView's life cycle methods.
     */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableConstants.tableViewCellID, for: indexPath) as! PlanetViewCell
        let planet = viewModel[indexPath.row]
        cell.updateCell(withData: planet)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//Private Method Extension

extension ViewController {
    
    /**
     This method will be notify the controller once Core Data Stack is initialized.
     - Parameter notification: notification is the NSNotification object which contains the userinfo in which status of stack initialization is present.
     */
    
    @objc private func fetchTableDataAndDisplay(notification : NSNotification) {
        if let userInfo = notification.userInfo {
            if let status = userInfo["status"] as? Bool, status {
                viewModel.getPlanetData { [weak self] (status) in
                    self?.title = "Planet"
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

extension ViewController {
    private struct TableConstants {
        static let tableViewCellID = "PlanetViewCellID"
    }
}

