import CoreData

class CoreDataHelper {
    static let shared = CoreDataHelper()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "YourDataModelName") // Ganti dengan nama data model Anda
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func deleteAllData() {
        let context = persistentContainer.viewContext

        // Nama entitas yang ingin Anda hapus
        let entityNames = ["FavoriteProduct", "CheckOut", "Items"]

        for entityName in entityNames {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try context.execute(batchDeleteRequest)
                try context.save()
            } catch {
                print("Error deleting \(entityName): \(error)")
            }
        }
    }
}
