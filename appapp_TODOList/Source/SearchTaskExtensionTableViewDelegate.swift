//
//  SearchTaskExtensionTableViewDelegate.swift
//  appapp_TODOList
//
//  Created by  shawn on 24/03/2017.
//  Copyright © 2017 shawn. All rights reserved.
//

import UIKit

extension SearchTaskViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewTaskList{
            return (allTask?.count)!
        }else{
            return resultArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChecklistTableViewCell
        cell.labelIndicator.isHidden = true
        cell.labelTodoList.isHidden = false
        if tableView == tableViewTaskList{
            cell.labelItemName.text = allTask?[indexPath.row].itemName
            cell.labelDueDate.text = dateTranslate.dateTransShortFormatter(date: allTask?[indexPath.row].dueDate as! Date)
            if let checkBoxStn = (allTask?[indexPath.row].finishedStatus){
                if checkBoxStn{
                    cell.btnCheckBox.setBackgroundImage(UIImage(named: "ic_checked"), for: .normal)
                }else{
                    cell.btnCheckBox.setBackgroundImage(UIImage(named: "ic_empty"), for: .normal)
                }
            }
            cell.labelTodoList.text = allTask?[indexPath.row].listName
            return cell
        }else{
            cell.labelItemName.text = resultArray[indexPath.row].itemName
            cell.labelDueDate.text = dateTranslate.dateTransShortFormatter(date: resultArray[indexPath.row].dueDate as! Date)
            if resultArray[indexPath.row].finishedStatus{
                cell.btnCheckBox.setBackgroundImage(UIImage(named: "ic_checked"), for: .normal)
            }else{
                cell.btnCheckBox.setBackgroundImage(UIImage(named: "ic_empty"), for: .normal)
            }
            cell.labelTodoList.text = resultArray[indexPath.row].listName
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
