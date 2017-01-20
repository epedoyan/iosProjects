//
//  CoreDataManger.swift
//  NotesProject
//
//  Created by Codefights on 1/10/17.
//  Copyright © 2017 Codefights. All rights reserved.
//

import UIKit
import CoreData

//what need to be added via import ???

class CoreDataManager: NSObject {
    
    static let shared: CoreDataManager = { // ???
        let sharedInstance = CoreDataManager()
        return sharedInstance
    }()

    func fetchAllNotes() -> [Notes] {
        let moc = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest() //as NSFetchRequest<Notes> // ambigious ???
        
        do {
            let fetchResults = try moc.fetch(fetchRequest)
            return fetchResults
        } catch {
            fatalError("Failed to fetch Notes: \(error)")
        }
    }

    func insertNewNote(with info: String, dateTime: String) {
        //Notes(entity: Notes.entity(), insertInto: moc)
        //let newNote = NSEntityDescription.insertNewObject(forEntityName: "Notes", into: context) as! Notes
        let moc = persistentContainer.viewContext
        let newNote = Notes(context: moc)
        newNote.noteInfo = info
        newNote.dateTime = dateTime
        self.saveContext()
    }
    
    func delete(note: Notes) {
        let moc = persistentContainer.viewContext
        moc.delete(note)
        self.saveContext() // ??? will I need to save here ??? 
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "NotesProject")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    ////////******
    
//    func fetchSelectedNote(with objectID: NSManagedObjectID) -> Notes {
//        let moc = persistentContainer.viewContext
//        return moc.object(with: objectID) as! Notes
//        //        let fetchRequest : NSFetchRequest<Notes> = Notes.fetchRequest() // ???
//        //        let predicate = NSPredicate(format: "id = %@", argumentArray: [objectID])
//        //        fetchRequest.predicate = predicate
//        //
//        //        do {
//        //            let fetchResults = try moc.fetch(fetchRequest)
//        //            return fetchResults[0]
//        //        } catch {
//        //            fatalError("Failed to fetch Notes: \(error)")
//        //        }
//    }
    
//    func fetchNoteInfoAttribute() -> [String] {
//        let moc = self.getContext()
//        let fetchRequest : NSFetchRequest<Notes> = Notes.fetchRequest()
//        let entityDescription = NSEntityDescription.entity(forEntityName: "Notes", in: moc)
//        fetchRequest.entity = entityDescription
//        fetchRequest.propertiesToFetch = ["noteInfo"]
//        
//        do {
//            let fetchResults = try moc.fetch(fetchRequest)
//            return fetchResults
//        } catch {
//            fatalError("Failed to fetch Notes: \(error)")
//        }
//    }
    
}
