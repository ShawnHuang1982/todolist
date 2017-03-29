//
//  ToDoListAddAndSelectExtensionDelegate.swift
//  appapp_TODOList
//
//  Created by  shawn on 23/03/2017.
//  Copyright © 2017 shawn. All rights reserved.
//

import UIKit

extension ToDoListAddAndSelectViewController:showAlertViewControllerDelegate{
    func type1PressOk(textFieldContent: String) {
        let today = Date()
        self.newTodoList = self.coreDataDB.saveDataOfTodoList(createdDate: today, listName: textFieldContent, unFinishedNumber: "0")
        self.performSegue(withIdentifier: "gotoItemList", sender: 0)
    }
}

extension ToDoListAddAndSelectViewController:SyncLocalDBAndServerDelegate{
    func endSyneNotification() {
        DispatchQueue.main.async {
            print("重整collectionView表格1")
            self.loadTodoLists = self.coreDataDB.loadDataOfAllTodoListFromDB()
            self.collectionViewToDoList.reloadData()
        }
    }
}
