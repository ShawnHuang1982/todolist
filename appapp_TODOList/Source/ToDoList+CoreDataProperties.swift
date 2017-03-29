//
//  ToDoList+CoreDataProperties.swift
//  appapp_TODOList
//
//  Created by  shawn on 23/03/2017.
//  Copyright © 2017 shawn. All rights reserved.
//

import Foundation
import CoreData


extension ToDoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoList> {
        return NSFetchRequest<ToDoList>(entityName: "ToDoList");
    }

    @NSManaged public var createdDate: NSDate?
    @NSManaged public var listName: String?
    @NSManaged public var unFinishedNumber: String?
    @NSManaged public var uuid: String?
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension ToDoList {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: ToDoItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: ToDoItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}
