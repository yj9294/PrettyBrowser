//
//  TermsVC.swift
//  PrettyBrowser
//
//  Created by yangjian on 2022/12/2.
//

import UIKit

class TermsVC: BaseVC {

    override func viewDidLoad() {
            super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting_back"), style: .plain, target: self, action: #selector(backAction))
        self.navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    @objc func backAction() {
        NotificationCenter.default.post(name: .homeWillappear, object: nil)
        self.dismiss(animated: true)
    }

}
