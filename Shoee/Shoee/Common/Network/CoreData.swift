import UIKit
import CoreData

class CoreDataHelper {

    static let shared = CoreDataHelper()

    let managedContext: NSManagedObjectContext

    init() {
        // Mengambil managed context dari AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not access AppDelegate")
        }
        managedContext = appDelegate.persistentContainer.viewContext
    }

    // MARK: - Helper methods

    func deleteAllData(forEntity entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

        do {
            if let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                for result in results {
                    managedContext.delete(result)
                }

                // Save changes
                saveContext()

                print("All data for entity \(entityName) deleted successfully.")
            }
        } catch {
            print("Error deleting all data for entity \(entityName): \(error.localizedDescription)")
        }
    }

    func saveContext() {
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

