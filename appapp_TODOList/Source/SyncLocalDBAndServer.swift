//
//  SyncLocalDBAndServer.swift
//  appapp_TODOList
//
//  Created by  shawn on 23/03/2017.
//  Copyright © 2017 shawn. All rights reserved.
//
protocol SyncLocalDBAndServerDelegate{
    func endSyneNotification()
}


import UIKit

class SyncLocalDBAndServer {
    let coreDataDB = CoreDataDB()
    let dateTranslte = DateTranslate()
    let connectSheetSu = ConnectSheetSu()
    var localDB:[ToDoItem]?
    var nowProcessLocalDBNumber:Int = 0
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var delegate:SyncLocalDBAndServerDelegate?
    var serverDB:[[String:String]]?
   
    func startSync(){
        print("開始同步===>")
        connectSheetSu.delegate = self
        appDelegate?.canSync = false
        syncDeleteListWithServer()
    }
    
    func endSync(){
        appDelegate?.canSync = true
        delegate?.endSyneNotification()
        print(">====同步完成")
    }
    
    func syncDeleteListWithServer(){
        if let existToRemoveList = UserDefaults.standard.array(forKey: "DeleteList"){
            if existToRemoveList.count > 0{
                connectSheetSu.deleteTaskOnSheetSuByLocalList(uuid: existToRemoveList[0] as! String)
                var copyList = existToRemoveList
                let newList = copyList.remove(at: 0)
                UserDefaults.standard.set(newList, forKey: "DeleteList")
                UserDefaults.standard.synchronize()
            }else{
                print("資料刪除完畢,開始載入線上資料")
                connectSheetSu.loadDataFromSheetSu()
            }
        }else{
            print("goto syncDataWithCompare")
            connectSheetSu.loadDataFromSheetSu()
        }
    }
    
    
    //載入資料完成
    func syncDataWithCompare(serverData: [[String : String]]) {
        print("開始比對--->")
        //載入LocalDB
        localDB = coreDataDB.loadDataOfAllTaskFromDB()
        //print("本地端資料\(localDB)")
        //載入sheetsuDB
        serverDB = serverData
        //print("下載的資料\(serverDB)")
        //比對
        //情況1:server有,local沒有,就把server download下來,存起來
        var selectedList:ToDoList?
        print("情況1開始比對")
        for object in serverDB!{
            var cnt1 = 0
            for object2 in localDB!{
                if object["uuid"] == object2.uuid{
                    cnt1 += 1
                }else if object["uuid"] == ""{
                    cnt1 += 1
                }
            }
            if cnt1 == 0 {
                if selectedList == nil{
                    print("建立清單,準備寫入Local端資料**")
                    selectedList = coreDataDB.saveDataOfTodoList()
                }
                if object["uuid"] != "" && object["datetime"] != "" {
                    print("download值下來--")
                    print("  1.\(object["datetime"]!)")
                    print("  2.\(object["task"]!)")
                    print("  3.\(object["isFinish"])")
                    print("  4.\(selectedList?.listName)")
                    print("  5.\(object["uuid"]!)")
                    let dueDate = dateTranslte.stringTransDateShortFormatter(date: object["datetime"]!)
                    let editDate = dateTranslte.stringTransDateLongFormatter(date: object["editDate"]!)
                    print("  6.\(dueDate)")
                    print("  7.\(editDate)")
                    var finishStatus:Bool?
                    if object["isFinish"]  == "TRUE"{
                        finishStatus = true
                    }else{
                        finishStatus = false
                    }
                    coreDataDB.saveDataOfTodoItem(createdDate: Date(), itemName: object["task"]!, finishedStatus: finishStatus!, dueDate: dueDate, listObj: selectedList!, listName: (selectedList?.listName!)!,uuid:object["uuid"]!,editDate:editDate)
                }
            }
        }
        
        print("情況1比對完成,go to 情況2 check")
        //情況2：server沒有,local有,先寫入帶上傳的list,上傳
        var waitingUploadList = [String]()
        for object in localDB!{
            //print("value1:\(object.uuid!)")
            var cnt1 = 0
            for object2 in serverDB!{
                //print("value2:\(object2["uuid"]!)")
                if object.uuid! == object2["uuid"]!{
                    //print("相同值")
                    cnt1 += 1
                }
            }
            if cnt1 == 0 {
                print("新增資料")
                waitingUploadList.append(object.uuid!)
                print("要上傳的資料uuid是\(object.uuid!)")
            }
        }
        if waitingUploadList.count > 0{
            print("建立上傳名單")
            UserDefaults.standard.set(waitingUploadList, forKey: "WaitingUploadList")
            UserDefaults.standard.synchronize()
        }
        
        print("情況2比對完成,go to 情況3 check")
        var waitingUpdateList = [String]()
        //情況3:uuid一樣,edit日期不一樣,要更新
        for object in serverDB!{
            for object2 in localDB!{
                if object["uuid"] == object2.uuid{
                    //print("轉換前網路端資料日期:\(object["editDate"])")
                    //print("轉換前本地端資料日期:\(object2.editDate)")
                    let date1 = dateTranslte.stringTransDateLongFormatter(date: object["editDate"]!)
                    let date2 = dateTranslte.stringTransDateLongFormatter(date: "\(object2.editDate as! Date)")
                    if date2.compare(date1) == ComparisonResult.orderedDescending{
                        print("local端資料較新,要更新server資料")
                        print("網路該筆最後更新資料日期:\(date1)")
                        print("本地端該筆最後更新資料日期:\(date2)")
                        let dueDate = dateTranslte.dateTransShortFormatter(date: object2.dueDate as! Date)
                        let editDate = dateTranslte.dateTransLongFormatter(date: object2.editDate as! Date)
                        print("  1.\(object2.uuid)")
                        print("  2.\(dueDate)")
                        print("  3.\(object2.itemName!)")
                        print("  4.\(object2.finishedStatus)")
                        print("  5.\(editDate)")
                        waitingUpdateList.append(object2.uuid!)
                    }
                }
            }
        }
        if waitingUpdateList.count > 0{
            print("建立更新名單")
            UserDefaults.standard.set(waitingUpdateList, forKey: "WaitingUpdateList")
            UserDefaults.standard.synchronize()
        }
        
        if waitingUploadList.count > 0{
            serialUploadSpecificData()
        }else if waitingUpdateList.count > 0{
            serialUpdateSpecificData()
        }else{
            print("-->檢查結束,不需執行上傳任務")
            endSync()
        }
    }
    
    func serialUploadSpecificData(){
        print("開始upload「上傳名單」到server 1")
        var uploadArray = UserDefaults.standard.array(forKey: "WaitingUploadList") as! [String]
        for object in localDB!{
            for (index,object2) in uploadArray.enumerated(){
                if object.uuid == object2{
                    let dueDate = dateTranslte.dateTransShortFormatter(date: object.dueDate as! Date)
                    let editDate = dateTranslte.dateTransLongFormatter(date: object.editDate as! Date)
                    print("開始傳輸第\(index)筆")
                    print("\(dueDate)")
                    print("\(object.itemName)")
                    print("\(object.listName )")
                    print("\(object.finishedStatus )")
                    print("\(object.editDate )")
                    print("\(editDate)")
                    connectSheetSu.uploadTaskToSheetSu(dueDate: dueDate, itemName: object.itemName!, finishedStatus: "\(object.finishedStatus)", listName: object.listName!, editDate: editDate, uuid: object.uuid!)
                    uploadArray.remove(at: index)
                    UserDefaults.standard.set(uploadArray, forKey: "WaitingUploadList")
                    UserDefaults.standard.synchronize()
                    return
                }
            }
        }
    }
    
    func serialUpdateSpecificData(){
        var updateArray = UserDefaults.standard.array(forKey: "WaitingUpdateList") as! [String]
        print("開始upload「更新名單」到server 1,資料量:\(updateArray.count)")
        for object in localDB!{
            for (index,object2) in updateArray.enumerated(){
                if object.uuid == object2{
                    let dueDate = dateTranslte.dateTransShortFormatter(date: object.dueDate as! Date)
                    let editDate = dateTranslte.dateTransLongFormatter(date: object.editDate as! Date)
                    print("開始傳輸第\(index)筆")
                    print(" 1.\(dueDate)")
                    print(" 2.\(object.itemName)")
                    print(" 3.\(object.listName )")
                    print(" 4.\(object.finishedStatus )")
                    print(" 5.\(object.editDate )")
                    print(" 6.\(editDate)")
                    connectSheetSu.editTaskOnSheetSuByLocalList(uuid: object.uuid!, dueDate: dueDate, itemName: object.itemName!, finishedStatus: "\(object.finishedStatus)", editDate: editDate)
                    updateArray.remove(at: index)
                    UserDefaults.standard.set(updateArray, forKey: "WaitingUpdateList")
                    UserDefaults.standard.synchronize()
                    return
                }
            }
        }
    }

}

extension SyncLocalDBAndServer:ConnectSheetSuDelegate{
    func deleteOneTaskFromSheetSuDone() {
        syncDeleteListWithServer()
    }
    
    func loadDataFromSheetSuDone(data: [[String : String]]) {
        print("下載完成")
        syncDataWithCompare(serverData: data)
    }
    
    func uploadDataToSheetSuDone() {
        print("「上傳名單」上傳一筆完成")
        if let uploadArray = UserDefaults.standard.array(forKey: "WaitingUploadList"){
            if uploadArray.count > 0 {
                serialUploadSpecificData()
            }else{
                print("「上傳名單」傳輸完成1")
                if let updateList = UserDefaults.standard.array(forKey: "WaitingUpdateList"){
                    if updateList.count > 0{
                        print("開始upload「更新名單」到server 2")
                        serialUpdateSpecificData()
                    }else{
                        endSync()
                    }
                }else{
                    endSync()
                }
            }
        }else{
            print("「上傳名單」傳輸完成2")
            endSync()
        }
    }
    
    func editOneTaskFromSheetSuDone() {
        print("「更新名單」上傳一筆完成")
        if let updateArray = UserDefaults.standard.array(forKey: "WaitingUpdateList"){
            if updateArray.count > 0 {
                serialUpdateSpecificData()
            }else{
                print("「更新名單」傳輸完成1")
                endSync()
            }
        }else{
            print("「上傳名單」傳輸完成2")
            endSync()
        }
    }

}
