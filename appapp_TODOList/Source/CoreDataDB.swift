//
//  CoreDataDB.swift
//  appapp_TODOList
//
//  Created by  shawn on 22/03/2017.
//  Copyright © 2017 shawn. All rights reserved.
//

import  UIKit
import CoreData

class CoreDataDB {
    var appDelegate:AppDelegate? //使用AppDelegate的CoreData Function
    var context:NSManagedObjectContext!
    let dateTranslate = DateTranslate()
    
    func generatUUID()->String{
        let uuid = UUID().uuidString
        print(uuid)
        return uuid
    }
    
    func coreDataPreSetting(){
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        context = appDelegate?.persistentContainer.viewContext
    }

    func loadDataOfAllTodoListFromDB()->[ToDoList]{
        coreDataPreSetting()
        let fetchRequest:NSFetchRequest<ToDoList> = ToDoList.fetchRequest()
        do{
            let loadListDataFromDB:[ToDoList]  = try context.fetch(fetchRequest)
            //print("資料是\(loadListDataFromDB)")
            return loadListDataFromDB
        }catch{
            print("載入發生Error\(error)")
        return [ToDoList]()
        }
    }
    
    func loadDataOfTodoItmeSelectedListFromDB(list:ToDoList)->[ToDoItem]{
        coreDataPreSetting()
        let fetchRequest:NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ANY itemsInList.uuid = %@", (list.uuid)!)
        do{
            let loadItemDataFromDB:[ToDoItem]  = try context.fetch(fetchRequest)
                //print("資料是\(loadItemDataFromDB)")
                return loadItemDataFromDB
            }catch{
                print("載入發生Error\(error)")
                return [ToDoItem]()
            }
     }

    func loadDataOfAllTaskFromDB()->[ToDoItem]{
        coreDataPreSetting()
        let fetchRequest:NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        do{
            let loadItemDataFromDB:[ToDoItem]  = try context.fetch(fetchRequest)
            //print("資料是\(loadItemDataFromDB)")
            return loadItemDataFromDB
        }catch{
            print("載入發生Error\(error)")
            return [ToDoItem]()
        }
    }

    //edit task
    func saveDataOfTodoItem(createdDate:Date,itemName:String,finishedStatus:Bool,finishedDate:Date,dueDate:Date,listObj:ToDoList){
        coreDataPreSetting()
        let itemForSave = ToDoItem(context: context!)
        //儲存名稱,建立日期,修改日期,img
        itemForSave.itemName = itemName
        itemForSave.finishedStatus = finishedStatus
        itemForSave.createdDate = createdDate as NSDate?
        itemForSave.finishedDate = finishedDate as NSDate?
        itemForSave.dueDate = dueDate as NSDate?
        itemForSave.editDate = Date() as NSDate?
        listObj.addToItems(itemForSave)
        appDelegate?.saveContext()
    }

    //add new task
    func saveDataOfTodoItem(createdDate:Date,itemName:String,finishedStatus:Bool,dueDate:Date,listObj:ToDoList,listName:String){
        coreDataPreSetting()
        let itemForSave = ToDoItem(context: context!)
        //儲存名稱,建立日期,修改日期,img
        itemForSave.itemName = itemName
        itemForSave.finishedStatus = finishedStatus
        itemForSave.createdDate = createdDate as NSDate?
        itemForSave.dueDate = dueDate as NSDate?
        itemForSave.listName = listName
        itemForSave.editDate = Date() as NSDate?
        itemForSave.uuid = generatUUID()
        listObj.addToItems(itemForSave)
        appDelegate?.saveContext()
    }
    
    //add new task by sync with Server
    func saveDataOfTodoItem(createdDate:Date,itemName:String,finishedStatus:Bool,dueDate:Date,listObj:ToDoList,listName:String,uuid:String,editDate:Date){
        coreDataPreSetting()
        let itemForSave = ToDoItem(context: context!)
        //儲存名稱,建立日期,修改日期,img
        itemForSave.itemName = itemName
        itemForSave.finishedStatus = finishedStatus
        itemForSave.createdDate = createdDate as NSDate?
        itemForSave.dueDate = dueDate as NSDate?
        itemForSave.listName = listName
        itemForSave.editDate = editDate as NSDate?
        itemForSave.uuid = uuid
        listObj.addToItems(itemForSave)
        appDelegate?.saveContext()
    }
    
    //add new todo list
    func saveDataOfTodoList(createdDate:Date,listName:String,unFinishedNumber:String)->ToDoList{
        coreDataPreSetting()
        let listForSave = ToDoList(context: context!)
        //儲存名稱,建立日期,修改日期,img
        listForSave.listName = listName
        listForSave.createdDate = createdDate as NSDate?
        listForSave.unFinishedNumber = unFinishedNumber
        listForSave.uuid = generatUUID()
        appDelegate?.saveContext()
        return listForSave
    }
    
    func saveDataOfTodoList()->ToDoList{
        coreDataPreSetting()
        let listForSave = ToDoList(context: context!)
        //儲存名稱,建立日期,修改日期,img
        listForSave.listName = "downloadFromServer"
        listForSave.createdDate = Date() as NSDate?
        listForSave.uuid = generatUUID()
        appDelegate?.saveContext()
        return listForSave
    }
    
    //edit task: check/unchecked
    func updateDataOfTodoItem(seletedItem:ToDoItem,finishedStatus:Bool){
        coreDataPreSetting()
        seletedItem.finishedStatus = finishedStatus
        if finishedStatus{
            seletedItem.finishedDate = Date() as NSDate?
            seletedItem.editDate = Date() as NSDate?
        }else{
            seletedItem.finishedDate = nil
            seletedItem.editDate = Date() as NSDate?
        }
        appDelegate?.saveContext()
    }
    
    //更新todoItem
    func updateDataOfTodoItem(seletedItem:ToDoItem,itemName:String,dueDate:Date){
        coreDataPreSetting()
        seletedItem.dueDate = dueDate as NSDate
        seletedItem.itemName = itemName
        seletedItem.finishedStatus = false
        seletedItem.finishedDate = nil
        appDelegate?.saveContext()
    }
    
    func deleteTodoItem(seletedItem:ToDoItem){
        coreDataPreSetting()
        context.delete(seletedItem)
        appDelegate?.saveContext()
    }

}
