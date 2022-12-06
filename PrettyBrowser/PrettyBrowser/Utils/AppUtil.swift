//
//  AppUtil.swift
//  PrettyBrowser
//
//  Created by yangjian on 2022/11/29.
//

import Foundation
import UIKit

var AppEnterBackground = false
var AppSceneDelegate: SceneDelegate? = nil

extension String {
    var isUrl: Bool {
        let url = "[a-zA-z]+://.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", url)
        return predicate.evaluate(with: self)
    }
}

extension UIViewController {
    func alert(_ message: String) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        self.present(alertController, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak alertController] in
            alertController?.dismiss(animated: true)
        }
    }
    
    func alert(_ message: String, certain: (()->Void)?) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Close Tabs and Clear Data", style: .destructive) {_ in
            certain?()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(action)
        alertController.addAction(cancel)
        self.present(alertController, animated: true)
    }
}

protocol NibLoadable {
}

extension NibLoadable where Self: UIView {
    static func loadFromNib(_ nibname: String? = nil) -> Self {
        let loadName = nibname == nil ? "\(self)" : nibname!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}
