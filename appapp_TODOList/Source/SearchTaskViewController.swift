//
//  SearchTaskViewController.swift
//  appapp_TODOList
//
//  Created by  shawn on 24/03/2017.
//  Copyright © 2017 shawn. All rights reserved.
//

import UIKit

class SearchTaskViewController: UIViewController {

    @IBOutlet weak var refView: UIView!
    @IBOutlet weak var tableViewTaskList: UITableView!
    var search1Controller:UISearchController! //等下要存要我們收尋資料的 SearchController
    var resultTableViewController = UITableViewController() //等下準備顯示搜尋結果的tableViewController
    var allTask:[ToDoItem]?
    var resultArray = [ToDoItem]() //等下來存搜尋的結果
    let coreDataDB = CoreDataDB()
    let dateTranslate = DateTranslate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load LocalDB
        allTask = coreDataDB.loadDataOfAllTaskFromDB()
        
        //產生 UISearchController，指定顯示搜尋結果的controller，是resultController
        search1Controller = UISearchController(searchResultsController: resultTableViewController)
        search1Controller.searchResultsUpdater = self
        tableViewTaskList.tableHeaderView = search1Controller.searchBar
        resultTableViewController.automaticallyAdjustsScrollViewInsets = false
        resultTableViewController.tableView.contentInset = UIEdgeInsetsMake(search1Controller.searchBar.frame.height + 20,0, 0, 0)
        resultTableViewController.tableView.backgroundColor = UIColor.white
        resultTableViewController.tableView.tableHeaderView?.backgroundColor = UIColor.red
        search1Controller.dimsBackgroundDuringPresentation = false
        
        //tableview setting
        tableViewTaskList.dataSource = self
        tableViewTaskList.delegate = self
        let nib = UINib(nibName: "ChecklistTableViewCell", bundle: nil)
        tableViewTaskList.register(nib, forCellReuseIdentifier: "Cell")

        //resultTableView setting
        resultTableViewController.tableView.dataSource = self
        resultTableViewController.tableView.delegate = self
        resultTableViewController.tableView.register(nib, forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
