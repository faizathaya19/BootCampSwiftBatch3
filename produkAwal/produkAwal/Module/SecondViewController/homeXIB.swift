//
//  homeXIB.swift
//  ProdukAwal
//
//  Created by Phincon on 26/10/23.
//

import UIKit

class homeXIB: UIViewController {

    @IBOutlet weak var tableviewuser: UITableView!
    
    let data = ["1","2","3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableviewuser.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        self.tableviewuser.delegate = self
        self.tableviewuser.dataSource =  self
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension homeXIB: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableviewuser.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell {
            cell.titleLabel.text = self.data[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}
