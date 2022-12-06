//
//  CleanAlertView.swift
//  PrettyBrowser
//
//  Created by yangjian on 2022/12/2.
//

import UIKit

class CleanAlertView: BaseView {
    override func dismiss() {
        self.alpha = 0
    }
}
