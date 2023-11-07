//
//  ViewController.swift
//  PhoneBook
//
//  Created by Phincon on 07/11/23.
//

import UIKit

class ViewController: UIViewController {
    
    var apiResult = [Model]()

    @IBOutlet weak var apiDataTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        APIHandler.shareInstance.fetchingAPIData { apiData in
            self.apiResult = apiData
            
            DispatchQueue.main.async {
                self.apiDataTableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiResult.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell()}
        cell.textLabel?.text = apiResult[indexPath.row].first_name
        return cell
    }
}
