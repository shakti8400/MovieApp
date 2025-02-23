//
//  CoreDataHelper.swift
//  MovieApp
//
//  Created by Shakti Singh on 22/02/25.
//

import Foundation
import CoreData

class CoreDataHelper {
    
    private init(){}
    static let sharedIns = CoreDataHelper()
    var context:NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext (completion:@escaping(_ status:Bool)->Void) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion(true)
            } catch {
                completion(false)
            }
        }
    }
    
    func deleteRecord(_ entity:String, id: Int, completion: @escaping (_ success: Bool) -> Void) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.fetchLimit = 1

        do {
            if let result = try context.fetch(fetchRequest).first as? NSManagedObject {
                context.delete(result)
                try context.save()
                completion(true)
            } else {
                completion(false)
            }
        } catch {
            print("Error deleting movie: \(error)")
            completion(false)
        }
    }

    
    func deleteAllData(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        let context = persistentContainer.viewContext
        let deleteBatchReq = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteBatchReq)
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
}
