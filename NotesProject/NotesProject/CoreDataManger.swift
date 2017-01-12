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

class CoreDataManger: NSObject {
    
    static let sharedManager: CoreDataManger = { // ???
        let sharedInstance = CoreDataManger()
        return sharedInstance
    }()
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func fetchAllNotes() -> [Notes] {
        let moc = self.getContext()
        let fetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest() //as NSFetchRequest<Notes> // ambigious ???
        
        do {
            let fetchResults = try moc.fetch(fetchRequest)
            return fetchResults
        } catch {
            fatalError("Failed to fetch Notes: \(error)")
        }
    }
    
    func fetchSelectedNote(with objectID: NSManagedObjectID) -> Notes {
        let moc = self.getContext()
        return moc.object(with: objectID) as! Notes
//        let fetchRequest : NSFetchRequest<Notes> = Notes.fetchRequest() // ???
//        let predicate = NSPredicate(format: "id = %@", argumentArray: [objectID])
//        fetchRequest.predicate = predicate
//        
//        do {
//            let fetchResults = try moc.fetch(fetchRequest)
//            return fetchResults[0]
//        } catch {
//            fatalError("Failed to fetch Notes: \(error)")
//        }
    }
    
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
