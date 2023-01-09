public class CoreDataManager {
    
    public static let shared = CoreDataManager()
    
    public lazy var container: NSPersistentCloudKitContainer = {
        self.SetupCoreData()
    }()
    
    func SetupCoreData() -> NSPersistentCloudKitContainer {
        let container = NSPersistentCloudKitContainer(name: "Model")
        let cloudKitEnabled = widgetUserDefaults.bool(forKey: "iCloudSync")
        let storeURL = URL.storeURL(for: "AppGroupID", databaseName: "Model")
        let description = NSPersistentStoreDescription(url: storeURL)
        
        
        if cloudKitEnabled {
            description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "ContainerID")
            description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
            container.viewContext.automaticallyMergesChangesFromParent = true
            container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(type(of: self).iCloudUpdateRecieved), name: .NSPersistentStoreRemoteChange, object: container.persistentStoreCoordinator)
        
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { (description, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }
}
    
