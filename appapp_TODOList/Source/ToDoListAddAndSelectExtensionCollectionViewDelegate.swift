//
//  ToDoListAddAndSelectExtensionCollectionViewDelegate.swift
//  appapp_TODOList
//
//  Created by  shawn on 23/03/2017.
//  Copyright © 2017 shawn. All rights reserved.
//

import UIKit

extension ToDoListAddAndSelectViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (loadTodoLists!.count + 1)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ToDoListCollectionViewCell
        if indexPath.row == 0{
            cell.imageViewShowAddIcon.image = UIImage(named: "ic_addList")
            cell.labelListName.text = ""
        }else{
            cell.labelListName.text = loadTodoLists?[indexPath.row-1].listName
            cell.imageViewShowAddIcon.image = nil
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let alertController = showViewController.type1(title: "AddNewToDoList", message: "Please  ToDoList's Name")
            present(alertController, animated: true, completion: nil)
        }else{
            self.performSegue(withIdentifier: "gotoItemList", sender: indexPath.row)
        }
    }
}

