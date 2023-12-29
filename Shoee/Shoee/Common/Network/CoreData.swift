import UIKit
import CoreData

class CoreDataHelper {

    static let shared = CoreDataHelper()

    let managedContext: NSManagedObjectContext

    private init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not access AppDelegate")
        }
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func fetchFromCoreData(forEntity entityName: String, withPredicate predicate: NSPredicate?) -> [NSManagedObject] {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = predicate

            do {
                let results = try managedContext.fetch(fetchRequest)
                return results
            } catch {
                return []
            }
        }
    
    func fetchAllData(forEntity entityName: String, withPredicate predicate: NSPredicate?) -> [NSManagedObject] {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = predicate

            do {
                let results = try managedContext.fetch(fetchRequest)
                return results
            } catch {
                return []
            }
        }

    func deleteAllData(forEntity entityName: String) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)

        do {
            let results = try managedContext.fetch(fetchRequest)
            for result in results {
                managedContext.delete(result)
            }

            saveContext()
        } catch _ as NSError {
           
        }
    }

    func saveDataToCoreData(entityName: String, data: [String: Any]) {
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        let newObject = NSManagedObject(entity: entity, insertInto: managedContext)

        for (key, value) in data {
            newObject.setValue(value, forKeyPath: key)
        }

        saveContext()
    }
    
    func updateDataInCoreData(forEntity entityName: String, withPredicate predicate: NSPredicate, newData: [String: Any]) {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest.predicate = predicate

            do {
                if let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                    for result in results {
                        for (key, value) in newData {
                            result.setValue(value, forKey: key)
                        }
                    }

                    saveContext()
                }
            } catch _ as NSError {
                
            }
        }
    
    func isDataExistsInCoreData(forEntity entityName: String, withPredicate predicate: NSPredicate) -> Bool {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest.predicate = predicate

            do {
                let count = try managedContext.count(for: fetchRequest)
                return count > 0
            } catch {
                return false
            }
        }
    
    func saveContext() {
        do {
            if managedContext.hasChanges {
                try managedContext.save()
            }
        } catch {
        }
    }
}
