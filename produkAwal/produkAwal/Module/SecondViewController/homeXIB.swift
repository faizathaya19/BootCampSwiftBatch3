import UIKit

class homeXIB: UIViewController {

    @IBOutlet weak var tableviewuser: UITableView!
    
    // Populate your data array with some sample values
    let data: [UserData] = [
        UserData(user: "JohnDoe", password: "password123", pelajaran: [
            Pelajaran(namaMatkul: MataPelajaran(nilai: 90, guru: "Mr. Smith")),
            Pelajaran(namaMatkul: MataPelajaran(nilai: 85, guru: "Ms. Johnson")),
            Pelajaran(namaMatkul: MataPelajaran(nilai: 92, guru: "Mr. Davis"))
        ]),
        UserData(user: "JaneDoe", password: "pass456", pelajaran: [
            Pelajaran(namaMatkul: MataPelajaran(nilai: 88, guru: "Mrs. Anderson")),
            Pelajaran(namaMatkul: MataPelajaran(nilai: 91, guru: "Mr. Brown")),
            Pelajaran(namaMatkul: MataPelajaran(nilai: 89, guru: "Ms. White"))
        ]),
        // Add more data as needed
    ]
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableviewuser.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        self.tableviewuser.delegate = self
        self.tableviewuser.dataSource =  self
    }
}

extension homeXIB: UITableViewDelegate, UITableViewDataSource {

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].pelajaran.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableviewuser.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell {
            // Access the user property of the UserData
            let userData = data[indexPath.section]
            cell.titleLabel.text = userData.user
            
            // Access the nested array properties within pelajaran
            let pelajaran = userData.pelajaran[indexPath.row].namaMatkul
            cell.subtitleLabel.text = "Pelajaran: \(pelajaran.guru), Nilai: \(pelajaran.nilai)"
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[section].user
    }
}
