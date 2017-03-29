//
//  UIViewExtension.swift
//  appapp_TODOList
//
//  Created by  shawn on 22/03/2017.
//  Copyright © 2017 shawn. All rights reserved.
//


import UIKit

extension UIView{
    @IBInspectable var cornerRadius:CGFloat{
        get{
            return self.layer.cornerRadius
        }
        // also set(newValue)
        set{
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
    }
}

