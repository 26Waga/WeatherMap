
//

import Foundation
import CoreData


struct CoreDataService {
    
    static let shared = CoreDataService()
    
    let persistenceContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavouritesModel")
        container.loadPersistentStores { StoreDescription, error in
            if let error = error {
                fatalError("Loading Store failed \(error)")
            }
        }
        return container
    }()
    
    
    func addLocation(name: String, country: String, longitude: Double, latitude: Double) {
        let context = persistenceContainer.viewContext
        
        let location = NSEntityDescription.insertNewObject(forEntityName: "FavouritesModel", into: context)
        
        location.setValue(name, forKey: "name")
        location.setValue(longitude, forKey: "longitude")
        location.setValue(latitude, forKey: "latitude")
        location.setValue(country, forKey: "country")
        
        do {
            try context.save()
        } catch let error {
            print("Failed to save location with context \(error)")
        }
        
    }
    
    func fetchLocations() -> [FavouritesModel] {
        let context = persistenceContainer.viewContext
        
        let fetchRequest = NSFetchRequest<FavouritesModel>(entityName: "FavouritesModel")
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let locationList = try context.fetch(fetchRequest)
            return locationList
        } catch let error {
            print("Failed to fetch: \(error)")
            return []
        }
        
    }
    
    func deleteLocation(latitude: Double, longitude: Double){
        
        let context = persistenceContainer.viewContext
        
        let fetchRequest = NSFetchRequest<FavouritesModel>(entityName: "FavouritesModel")
        
        let predicate = NSPredicate(format: "(latitude == %@) AND (longitude == %@)", latitude as NSNumber, longitude as NSNumber)
        
        fetchRequest.predicate = predicate
        
        
        do {
            let locationToRemove = try context.fetch(fetchRequest) as [NSManagedObject]
            locationToRemove.forEach { locationToRemove in
                context.delete(locationToRemove)
            }
            do {
                try context.save()
            } catch let error {
                print("Failed to save context \(error)")
            }
            
            
        } catch let error {
            print("Failed To Save \(error)")
        }
        
        
    }
    
    
    func locationExists(latitude: Double, longitude: Double) -> Bool {
        let context = persistenceContainer.viewContext
        
        let fetchRequest = NSFetchRequest<FavouritesModel>(entityName: "FavouritesModel")
        
        let predicate = NSPredicate(format: "(latitude == %@) AND (longitude == %@)", latitude as NSNumber, longitude as NSNumber)
        
        fetchRequest.predicate = predicate
        
        
        var results: [NSManagedObject] = []
        
        do {
            results = try context.fetch(fetchRequest) as [NSManagedObject]
            
        } catch let error {
            print("Error executing results \(error)")
        }
        return !results.isEmpty

    }
    }
