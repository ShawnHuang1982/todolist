//
//  ToDoItemListViewController.swift
//  appapp_TODOList
//
//  Created by  shawn on 22/03/2017.
//  Copyright © 2017 shawn. All rights reserved.
//

import UIKit

class ToDoItemListViewController: UIViewController {
    
    @IBOutlet weak var tableViewToDoList: UITableView!
    var listSelected:ToDoList?
    let coreDataDB = CoreDataDB()
    let connectSheetSu = ConnectSheetSu()
    let dateTranslte = DateTranslate()
    let showViewController = ShowAlertViewController()
    var addToDoItemView:TodoItemInputView?
    var itemDataFromDB:[ToDoItem]?
    var selectedItemData:ToDoItem?
    let syncLocalDBAndServer = SyncLocalDBAndServer()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //================================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = listSelected?.listName
        itemDataFromDB = coreDataDB.loadDataOfTodoItmeSelectedListFromDB(list: listSelected!)
        tableViewToDoList.dataSource = self
        tableViewToDoList.delegate = self
        
        let nib = UINib(nibName: "ChecklistTableViewCell", bundle: nil)
        tableViewToDoList.register(nib, forCellReuseIdentifier: "Cell")
        
        let nib2 = UINib(nibName: "TodoItemInputView", bundle: nil)
        let nibArray = nib2.instantiate(withOwner: nil, options: nil)
        addToDoItemView = nibArray[0] as? TodoItemInputView
        addToDoItemView?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableViewToDoList.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonAddToDoItem(_ sender: Any) {
        callItemAddView()
    }
        
    func callItemAddView(){
        print("[buttonAddToDoItem]")
        addToDoItemView?.removeFromSuperview()
        addToDoItemView?.source = "Add"
        addToDoItemView?.datePickerDueDate.date = Date()
        addToDoItemView?.textViewItemName.text = ""
        addToDoItemView?.frame = self.view.frame
        self.view.addSubview(addToDoItemView!)
    }
    
    func callItemEditView(selectedItem:ToDoItem){
        print("[buttonAddToDoItem]")
        addToDoItemView?.removeFromSuperview()
        addToDoItemView?.source = "Edit"
        addToDoItemView?.frame = self.view.frame
        self.view.addSubview(addToDoItemView!)
        addToDoItemView?.textViewItemName.text = selectedItem.itemName
        addToDoItemView?.datePickerDueDate.date = selectedItem.dueDate as! Date
        selectedItemData = selectedItem
    }
    
    func updateDBAndTableView(){
        //更新資料
        itemDataFromDB = coreDataDB.loadDataOfTodoItmeSelectedListFromDB(list: listSelected!)
        tableViewToDoList.reloadData()
        //同步網路DB
        if appDelegate.canSync{
            print("可以同步1")
            syncLocalDBAndServer.startSync()
        }else{
            print("等待同步")
        }
    }
}



