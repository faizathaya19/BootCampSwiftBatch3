//
//  CollectionViewInTableViewViewController.swift
//  StoryBoardSwiftP1
//
//  Created by Phincon on 30/10/23.
//
struct MovieData{
    let sectionType: String
    let Movies: [String]
}

import UIKit

class ALLShoesViewController: UIViewController {

    @IBOutlet weak var ASTV: UITableView!
    
    var dataMovie = [
        MovieData(sectionType: "1", Movies: ["ic_profile_default","ic_profile_default","ic_profile_default","ic_profile_default","ic_profile_default"]),
        MovieData(sectionType: "2", Movies: ["ic_profile_default","ic_profile_default","ic_profile_default","ic_profile_default","ic_profile_default"]),
        MovieData(sectionType: "3", Movies: ["ic_profile_default","ic_profile_default","ic_profile_default","ic_profile_default","ic_profile_default"]),
        MovieData(sectionType: "4", Movies: ["ic_profile_default","ic_profile_default","ic_profile_default","ic_profile_default","ic_profile_default"]),
        MovieData(sectionType: "5", Movies: ["ic_profile_default","ic_profile_default","ic_profile_default","ic_profile_default","ic_profile_default"]),
        MovieData(sectionType: "6", Movies: ["ic_profile_default","ic_profile_default","ic_profile_default","ic_profile_default","ic_profile_default"])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ASTV.register(UINib(nibName: "AllShoesTableViewCell", bundle: nil), forCellReuseIdentifier: "allShoesTableViewCell")
  
      
        ASTV.rowHeight = UITableView.automaticDimension
        ASTV.estimatedRowHeight = 100
        self.ASTV.delegate = self
        self.ASTV.dataSource =  self
    }

}

extension ALLShoesViewController: UITableViewDelegate, UITableViewDataSource{
   
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataMovie.count
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allShoesTableViewCell", for: indexPath) as! AllShoesTableViewCell
            return cell
    }
 
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .green
    }
    
    
} 
