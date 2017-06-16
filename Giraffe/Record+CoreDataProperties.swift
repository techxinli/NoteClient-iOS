//
//  Record+CoreDataProperties.swift
//  Giraffe
//
//  Created by 李鑫 on 16/4/24.
//  Copyright © 2016年 Miracle Lee. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Record {

    @nonobjc class func fetchRequest() -> NSFetchRequest<Record> {
        return NSFetchRequest<Record>(entityName: "Record");
    }
    
    @NSManaged var timeStamp: NSDate?
    @NSManaged var color: NSNumber?
    @NSManaged var notification: NSNumber?
    @NSManaged var time: Date?
    @NSManaged var type: String?
    @NSManaged var word: String?
    @NSManaged var alert: Date?

}
