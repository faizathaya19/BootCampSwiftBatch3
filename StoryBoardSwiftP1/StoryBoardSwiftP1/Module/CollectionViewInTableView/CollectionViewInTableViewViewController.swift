//
//  CollectionViewInTableViewViewController.swift
//  StoryBoardSwiftP1
//
//  Created by Phincon on 30/10/23.
//

import UIKit

class CollectionViewInTableViewViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataMovie = [
        MovieData(sectionType: "1", Movies: ["1","2","3","4","5"]),
        MovieData(sectionType: "2", Movies: ["1","2","3","4","5"]),
        MovieData(sectionType: "3", Movies: ["1","2","3","4","5"])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        self.tableView.delegate = self
        self.tableView.dataSource =  self
    }

}

extension CollectionViewInTableViewViewController: UITableViewDelegate, UITableViewDataSource{
   
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataMovie.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataMovie[section].sectionType
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
            return cell
    }
 
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .green
    }
    
    
}
