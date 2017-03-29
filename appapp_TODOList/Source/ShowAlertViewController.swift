//
//  showAlertViewController.swift
//  appapp_TODOList
//
//  Created by  shawn on 22/03/2017.
//  Copyright © 2017 shawn. All rights reserved.
//
protocol showAlertViewControllerDelegate{
    func type1PressOk(textFieldContent:String)
}

import UIKit

class ShowAlertViewController{
    var delegate:showAlertViewControllerDelegate?
    
    func type1(title:String,message:String)-> UIAlertController{
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: {
            (textFieldContent) in
            textFieldContent.placeholder = "enter here"
        })
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action) in
            let textFieldValue = (alertController.textFields?.first)! as UITextField
            var textFieldContent = ""
            if textFieldValue.text! == ""{
                textFieldContent = "No Named"
            }else{
                textFieldContent = textFieldValue.text!
            }
            self.delegate?.type1PressOk(textFieldContent: textFieldContent)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        return alertController
    }
    
    
}
