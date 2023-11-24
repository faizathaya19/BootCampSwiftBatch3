import UIKit

struct CartItem {
    var name: String
    var price: String
    var quantity: Int = 1 // Default quantity is 1
}


class CartViewController: UIViewController {
    
    var cartItems: [CartItem] = [
            CartItem(name: "Product 1", price: "$10.00"),
            // Add more items as needed
        ]

    @IBOutlet weak var cartTableView: UITableView!
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cartTableView.delegate = self
        cartTableView.dataSource = self
        cartTableView.register(UINib(nibName: "EmptyTableViewCell", bundle: nil), forCellReuseIdentifier: "emptyTableViewCell")
        
        cartTableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "cartTableViewCell")
    }



}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartTableViewCell", for: indexPath) as! CartTableViewCell
        cartTableView.contentInset.top = 20
               
        let item = cartItems[indexPath.row]
    
               
               // Assuming you have a property in your CartItem model for quantity
               cell.quantity = item.quantity
//       
//        let cell = tableView.dequeueReusableCell(withIdentifier: "emptyTableViewCell", for: indexPath) as! EmptyTableViewCell
//        
//        cell.configure(withImageNamed: "ic_cart_nil", message: "Let's find your favorite shoes", title: "Opss! Your Cart is Empty")
//       
//        tableView.isScrollEnabled = false
//        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 151.0
    }
}
