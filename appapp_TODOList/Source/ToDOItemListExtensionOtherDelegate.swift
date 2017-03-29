//
//  ToDOItemListExtensionOtherDelegate.swift
//  appapp_TODOList
//
//  Created by  shawn on 23/03/2017.
//  Copyright © 2017 shawn. All rights reserved.
//

import UIKit

extension ToDoItemListViewController:ChecklistTableViewCellDelegate{
    func pressCheckBox(cell: ChecklistTableViewCell) {
        print("checkBox被按下")
        let indexPath = tableViewToDoList.indexPathForRow(at: cell.center)
        print("checkBox被按下\(indexPath?.row)")
        if let checkBoxStn = itemDataFromDB?[(indexPath?.row)!].finishedStatus{
            print("checkBox改變前狀態\(checkBoxStn)")
            if checkBoxStn{
                print("checkBox改變後false")
                coreDataDB.updateDataOfTodoItem(seletedItem: (itemDataFromDB?[(indexPath?.row)!])!, finishedStatus: false)
                updateDBAndTableView()
            }else{
                print("checkBox改變後true")
                coreDataDB.updateDataOfTodoItem(seletedItem: (itemDataFromDB?[(indexPath?.row)!])!, finishedStatus: true)
                updateDBAndTableView()
            }
        }
    }
}


extension ToDoItemListViewController:TodoItemInputViewDelegate{
    func pressItemAddSave() {
        let today = Date()
        var itemName = ""
        if addToDoItemView?.textViewItemName.text == ""{
            itemName = "No named"
        }else{
            itemName = (addToDoItemView?.textViewItemName.text)!
        }
        let dueDate = addToDoItemView?.datePickerDueDate.date
        coreDataDB.saveDataOfTodoItem(createdDate: today, itemName: itemName, finishedStatus: false, dueDate: dueDate!, listObj: listSelected!, listName:(listSelected?.listName)!)
        //更新資料
        updateDBAndTableView()
        addToDoItemView?.removeFromSuperview()
    }
    
    func pressItemAddCancel() {
        addToDoItemView?.removeFromSuperview()
    }
    
    func pressItemEditSave() {
        var itemName = ""
        if addToDoItemView?.textViewItemName.text == ""{
            itemName = "No named"
        }else{
            itemName = (addToDoItemView?.textViewItemName.text)!
        }
        let dueDate = addToDoItemView?.datePickerDueDate.date
        coreDataDB.updateDataOfTodoItem(seletedItem: selectedItemData!, itemName: itemName, dueDate: dueDate!)
        updateDBAndTableView()
        addToDoItemView?.removeFromSuperview()
    }
}
