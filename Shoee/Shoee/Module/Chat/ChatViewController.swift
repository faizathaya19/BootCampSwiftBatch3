import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var chatTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(UINib(nibName: "EmptyTableViewCell", bundle: nil), forCellReuseIdentifier: "emptyTableViewCell")
    
    }

    
}


extension ChatViewController: UITableViewDelegate, UITableViewDataSource, EmptyCellDelegate {
    
    func btnAction(inCell cell: EmptyTableViewCell) {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 0
            
            if let navigationController = tabBarController.selectedViewController as? UINavigationController {
                navigationController.popToRootViewController(animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in your data source. For example:
        return 1// Replace with the actual count of your data source
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // This is the first row, use the EmptyTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "emptyTableViewCell", for: indexPath) as! EmptyTableViewCell
        
        cell.configure(withImageNamed: "ic_headset_nil", message: "You have never done a transaction", title: "Opss no message yet?")
        cell.delegate = self
        // Disable scrolling for emptyTableViewCell
        tableView.isScrollEnabled = false
        
        return cell
        
    }
}
