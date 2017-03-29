//
//  ToDoItem+CoreDataProperties.swift
//  appapp_TODOList
//
//  Created by  shawn on 23/03/2017.
//  Copyright © 2017 shawn. All rights reserved.
//

import Foundation
import CoreData


extension ToDoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItem> {
        return NSFetchRequest<ToDoItem>(entityName: "ToDoItem");
    }

    @NSManaged public var createdDate: NSDate?
    @NSManaged public var dueDate: NSDate?
    @NSManaged public var finishedDate: NSDate?
    @NSManaged public var finishedStatus: Bool
    @NSManaged public var itemName: String?
    @NSManaged public var listName: String?
    @NSManaged public var editDate: NSDate?
    @NSManaged public var uuid: String?
    @NSManaged public var itemsInList: ToDoList?

}
