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

extension UserDefaults {
    func setObject<T: Encodable> (_ object: T?, forKey key: String) {
        let encoder =  JSONEncoder()
        guard let object = object else {
            self.removeObject(forKey: key)
            return
        }
        guard let encoded = try? encoder.encode(object) else {
            return
        }
        
        self.setValue(encoded, forKey: key)
    }
    
    func getObject<T: Decodable> (_ type: T.Type, forKey key: String) -> T? {
        guard let data = self.data(forKey: key) else {
            return nil
        }
        let decoder = JSONDecoder()
        guard let object = try? decoder.decode(type, from: data) else {
            print("Could'n find key")
            return nil
        }
        
        return object
    }
}

