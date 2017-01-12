//
//  Notes+CoreDataProperties.swift
//  NotesProject
//
//  Created by Codefights on 12/18/16.
//  Copyright © 2016 Codefights. All rights reserved.
//

import Foundation
import CoreData


extension Notes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notes> {
        return NSFetchRequest<Notes>(entityName: "Notes");
    }

    @NSManaged public var noteInfo: String?
    @NSManaged public var dateTime: String?

}
