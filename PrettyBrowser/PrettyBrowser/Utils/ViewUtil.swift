//
//  ViewUtil.swift
//  PrettyBrowser
//
//  Created by yangjian on 2022/11/30.
//

import UIKit

var cornerRadiusKey: Void?
extension UIView {
    @IBInspectable var cornerRadius: Double {
        set {
            objc_setAssociatedObject(self, &cornerRadiusKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
        
        get {
            (objc_getAssociatedObject(self, &cornerRadiusKey) as? Double) ?? 0.0
        }
    }
}
