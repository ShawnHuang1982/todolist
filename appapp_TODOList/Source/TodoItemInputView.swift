//
//  TodoItemInputView.swift
//  appapp_TODOList
//
//  Created by  shawn on 22/03/2017.
//  Copyright © 2017 shawn. All rights reserved.
//

protocol TodoItemInputViewDelegate {
    func pressItemAddCancel()
    func pressItemAddSave()
    func pressItemEditSave()
}

import UIKit


class TodoItemInputView:UIView{
    @IBOutlet weak var textViewItemName: UITextView!
    @IBOutlet weak var datePickerDueDate: UIDatePicker!
    var delegate:TodoItemInputViewDelegate?
    var source = "" // Add/Edit

    @IBAction func buttonCancel(_ sender: Any) {
        delegate?.pressItemAddCancel()
    }
    
    @IBAction func buttonSave(_ sender: Any) {
        if source == "Add"{
            delegate?.pressItemAddSave()
        }else{
            delegate?.pressItemEditSave()
        }
    }
    
    
}
