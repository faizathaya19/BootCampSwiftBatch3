import UIKit
import CoreData

class CoreDataCleanup {

    static func deleteAllData() {
        deleteAllItems()
        deleteAllCheckOuts()
        deleteAllFavoriteProducts()
    }

    private static func deleteAllItems() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Items")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
            print("All items deleted from Core Data.")
        } catch {
            print("Error deleting items from Core Data: \(error)")
        }
    }

    private static func deleteAllCheckOuts() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CheckOut")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
            print("All checkouts deleted from Core Data.")
        } catch {
            print("Error deleting checkouts from Core Data: \(error)")
        }
    }

    private static func deleteAllFavoriteProducts() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteProduct")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
            print("All favorite products deleted from Core Data.")
        } catch {
            print("Error deleting favorite products from Core Data: \(error)")
        }
    }
}
