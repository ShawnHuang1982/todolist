//
//  ToDOItemListExtensionTableViewDelegate.swift.swift
//  appapp_TODOList
//
//  Created by  shawn on 23/03/2017.
//  Copyright © 2017 shawn. All rights reserved.
//

import UIKit

extension ToDoItemListViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("資料有幾列\(itemDataFromDB!.count)")
        return itemDataFromDB!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewToDoList.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChecklistTableViewCell
        cell.delegate = self
        cell.labelItemName.text = itemDataFromDB?[indexPath.row].itemName
        cell.labelDueDate?.text = dateTranslte.dateTransShortFormatter(date: itemDataFromDB?[indexPath.row].dueDate as! Date)
        if let checkBoxStn = (itemDataFromDB?[indexPath.row].finishedStatus){
            print("第\(indexPath.row),checkBox狀態\(checkBoxStn)")
            if checkBoxStn{
                cell.btnCheckBox.setBackgroundImage(UIImage(named: "ic_checked"), for: .normal)
            }else{
                cell.btnCheckBox.setBackgroundImage(UIImage(named: "ic_empty"), for: .normal)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        callItemEditView(selectedItem: itemDataFromDB![indexPath.row])
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            //將要刪除的item排進待刪除名單,網路連線後即進行刪除
            var toRemoveListArray = [String]()
            if let existToRemoveList = UserDefaults.standard.array(forKey: "DeleteList"){
                toRemoveListArray = existToRemoveList as! [String]
            }
            toRemoveListArray.append((itemDataFromDB?[indexPath.row].uuid)!)
            UserDefaults.standard.set(toRemoveListArray, forKey: "DeleteList")
            UserDefaults.standard.synchronize()
            //刪除本地端資料及重整
            coreDataDB.deleteTodoItem(seletedItem: (itemDataFromDB?[indexPath.row])!)
            updateDBAndTableView()
        }
    }
}
