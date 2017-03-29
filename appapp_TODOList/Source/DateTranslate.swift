//
//  DateTranslate.swift
//  appapp_TODOList
//
//  Created by  shawn on 23/03/2017.
//  Copyright © 2017 shawn. All rights reserved.
//

import UIKit

class DateTranslate{
    
    func dateTransShortFormatter(date:Date)->String{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        return dateformatter.string(from: date)
    }

    func dateTransLongFormatter(date:Date)->String{
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "Asia/Taipei")
        dateformatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return dateformatter.string(from: date)
    }

    func stringTransDateLongFormatter(date:String)->Date{
        //print("要轉換的日期\(date)")
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "Asia/Taipei")
        dateformatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return dateformatter.date(from: "\(date)")!
    }

    func stringTransDateShortFormatter(date:String)->Date{
        //print("要轉換的日期\(date)")
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        return dateformatter.date(from: "\(date)")!
    }

    
}
