//
//  ToDoListAddAndSelectViewController.swift
//  appapp_TODOList
//
//  Created by  shawn on 22/03/2017.
//  Copyright © 2017 shawn. All rights reserved.
//

import UIKit
import CoreData

class ToDoListAddAndSelectViewController: UIViewController {
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionViewToDoList: UICollectionView!
    let coreDataDB = CoreDataDB()
    let connectSheetSu = ConnectSheetSu()
    let dateTranslte = DateTranslate()
    let syncLocalDBAndServer = SyncLocalDBAndServer()
    var loadTodoLists:[ToDoList]?
    var newTodoList:ToDoList?
    let showViewController = ShowAlertViewController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var myTimer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Home:\(NSHomeDirectory())")
        
        collectionViewToDoList.dataSource = self
        collectionViewToDoList.delegate = self
        
        let nib = UINib(nibName: "ToDoListCollectionViewCell", bundle: nil)
        collectionViewToDoList.register(nib, forCellWithReuseIdentifier: "Cell")
        
        showViewController.delegate = self
        syncLocalDBAndServer.delegate = self
        
        
        loadDBAndUpdateView()
        
        syncDataFromServer()
        
        //定時去sync
        //myTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.syncDataFromServer), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDBAndUpdateView()
        syncDataFromServer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print(#function)
        //myTimer?.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadDBAndUpdateView(){
        loadTodoLists = coreDataDB.loadDataOfAllTodoListFromDB()
        collectionViewToDoList.reloadData()
    }
    
    func syncDataFromServer(){
        //定時更新
        //print("定時問")
        if appDelegate.canSync{
            print("check後,可以同步")
            syncLocalDBAndServer.startSync()
        }else{
            print("正在同步中")
        }
    }
    
    
    @IBAction func buttonSearch(_ sender: Any) {
        performSegue(withIdentifier: "gotoSearch", sender: nil)
    }
    
    //-------------------------------------------- prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("[載入prepare for segue]")
        if segue.identifier == "gotoItemList"{
            if let vc = segue.destination as? ToDoItemListViewController {
                if (sender as! Int) == 0{
                    //新增一份todoList
                    vc.listSelected = newTodoList
                }else{
                    //讀取舊資料,將這個coredata物件,送到下一個VC從點選過來,-1是因為第一個是新增的collectionCell
                    vc.listSelected = loadTodoLists?[(sender as! Int)-1]
                }
            }
        }
    }
    
}

