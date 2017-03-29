//
//  ConnectSheetSu.swift
//  appapp_TODOList
//
//  Created by  shawn on 23/03/2017.
//  Copyright © 2017 shawn. All rights reserved.
//

@objc protocol ConnectSheetSuDelegate {
    func loadDataFromSheetSuDone(data:[[String : String]])
    @objc optional func uploadDataToSheetSuDone()
    @objc optional func deleteAllDataFromSheetSuDone()
    @objc optional func deleteOneTaskFromSheetSuDone()
    @objc optional func editOneTaskFromSheetSuDone()
    
}

import UIKit
import SystemConfiguration

class ConnectSheetSu {
    var delegate:ConnectSheetSuDelegate?
    let urlString = "https://sheetsu.com/apis/v1.0/367106d3cb33"
    let urlString2 = "https://sheetsu.com/apis/v1.0/367106d3cb33/reserved1/1"
    let urlString3 = "https://sheetsu.com/apis/v1.0/367106d3cb33/uuid"
    
    func loadDataFromSheetSu(){
        let url = URL(string: urlString)
        let urlRequest = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30)
        print("loadDataFromSheetSu")
        print("開始\(urlRequest)")
        let task = URLSession.shared.dataTask(with: urlRequest) {
            (data , responese , error )  in
            if error == nil {
                let res = responese as! HTTPURLResponse
                //print("status:",res.statusCode)
                if let data = data {
                    do{
                        //let str = String(data: data, encoding: .utf8)
                        //print("str ->\(str!)")
                        //print("data size->\(data)")
                        let itemDataFromSheetSu:[[String : String]]?
                        try itemDataFromSheetSu = JSONSerialization.jsonObject(with: data) as? [[String : String]]
                        self.delegate?.loadDataFromSheetSuDone(data:itemDataFromSheetSu!)
                    }catch{
                        print(error)
                    }
                }
            }
        }
        task.resume()
    }
    
    func deleteAllDataOnSheetSu(){
        let url = URL(string: urlString2)
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        let task = URLSession.shared.dataTask(with: request){
            (data,response,error) in
            guard let _ = data else{
                print("error call delete")
                return
            }
            print("delete OK1")
            self.delegate?.deleteAllDataFromSheetSuDone!()
        }
        task.resume()
    }
    
    func deleteTaskOnSheetSuByLocalList(uuid:String){
        let url = URL(string: urlString3 + "/\(uuid)")
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        let task = URLSession.shared.dataTask(with: request){
            (data,response,error) in
            guard let _ = data else{
                print("error call delete")
                return
            }
            print("delete OK2")
            self.delegate?.deleteOneTaskFromSheetSuDone!()
        }
        task.resume()
    }

    func editTaskOnSheetSuByLocalList(uuid:String,dueDate:String,itemName:String,finishedStatus:String,editDate:String){
        let url = URL(string: urlString3 + "/\(uuid)")
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        let itemDataDictionary = ["datetime": dueDate, "task":"\(itemName)", "isFinish":finishedStatus,"editDate":"\(editDate)"]
        do {
            let data = try  JSONSerialization.data(withJSONObject: itemDataDictionary, options: [])
            let task = URLSession.shared.uploadTask(with: request, from: data) {
                (data, res, err) in
                self.delegate?.editOneTaskFromSheetSuDone!()
            }
            task.resume()
        }catch {
            print(error)
        }
    }


    func uploadTaskToSheetSu(dueDate:String,itemName:String,finishedStatus:String,listName:String,editDate:String,uuid:String){
        let url = URL(string: urlString)
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let itemDataDictionary = ["datetime": dueDate, "task":"\(itemName)", "isFinish":finishedStatus,"listName":"\(listName)","editDate":"\(editDate)","reserved1":"1","uuid":"\(uuid)"]
        do {
            let data = try  JSONSerialization.data(withJSONObject: itemDataDictionary, options: [])
            let task = URLSession.shared.uploadTask(with: request, from: data) {
                (data, res, err) in
                self.delegate?.uploadDataToSheetSuDone!()
            }
            task.resume()
        }catch {
            print(error)
        }
    }
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired
        return isReachable && !needsConnection
    }
}
