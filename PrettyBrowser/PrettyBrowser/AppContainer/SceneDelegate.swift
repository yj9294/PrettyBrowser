//
//  SceneDelegate.swift
//  PrettyBrowser
//
//  Created by yangjian on 2022/11/29.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var homeWindow: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        AppSceneDelegate = self
        guard let _ = (scene as? UIWindowScene) else { return }
        homeWindow = UIWindow()
        homeWindow?.windowScene = window?.windowScene
        homeWindow?.rootViewController = UIStoryboard(name: "Home", bundle: .main).instantiateViewController(withIdentifier: "HomeVC")
        
        NotificationCenter.default.addObserver(forName: .launching, object: nil, queue: .main) { _ in
            self.window?.makeKeyAndVisible()
        }
        
        NotificationCenter.default.addObserver(forName: .launched, object: nil, queue: .main) { _ in
            self.homeWindow?.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        if AppEnterBackground {
            FirebaseUtil.logEvent(name: .openHot)
        }
        AppEnterBackground = false
        window?.makeKeyAndVisible()
        NotificationCenter.default.post(name: .launching, object: nil)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        AppEnterBackground = true
    }

}

extension Notification.Name {
    static let launching = Notification.Name(rawValue: "launching")
    static let launched = Notification.Name(rawValue: "launched")
}

