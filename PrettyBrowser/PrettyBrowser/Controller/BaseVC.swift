//
//  BaseVC.swift
//  PrettyBrowser
//
//  Created by yangjian on 2022/11/29.
//

import UIKit

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes  = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.tintColor = .white
    }
    
    deinit{
        debugPrint("\(self) deinit!!!")
    }
    
}
