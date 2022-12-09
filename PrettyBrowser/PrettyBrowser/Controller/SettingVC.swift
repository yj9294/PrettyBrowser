//
//  SettingVC.swift
//  PrettyBrowser
//
//  Created by yangjian on 2022/11/30.
//

import UIKit
import MobileCoreServices

class SettingVC: BaseVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navi = UINavigationBarAppearance()
        navi.shadowImage = UIImage()
        navi.backgroundImage = UIImage()
        navi.shadowColor = .clear
        navi.backgroundColor = .clear
        navi.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = navi
        navigationController?.navigationBar.scrollEdgeAppearance = navi
        navigationController?.navigationBar.compactAppearance = navi
        
    }
    
    @IBAction func backAction() {
        self.dismiss(animated: true)
    }
    
    @IBAction func newAction() {
        BrowseUtil.shared.add()
        FirebaseUtil.logEvent(name: .tabNew, params: ["lig": "setting"])
    }
    
    @IBAction func copyAction() {
        FirebaseUtil.logEvent(name: .copyClick)
        
        if !BrowseUtil.shared.item.isNavigation {
            UIPasteboard.general.setValue(BrowseUtil.shared.item.webView.url?.absoluteString ?? "", forPasteboardType: kUTTypePlainText as String)
            self.alert("Copy successfully.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.dismiss(animated: true)
            }
            return
        }
        UIPasteboard.general.setValue("", forPasteboardType: kUTTypePlainText as String)
        self.alert("Copy successfully.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func shareAction() {
        FirebaseUtil.logEvent(name: .shareClick)

        var url = "https://itunes.apple.com/cn/app/id"
        if !BrowseUtil.shared.item.isNavigation {
            url = BrowseUtil.shared.item.webView.url?.absoluteString ?? "https://itunes.apple.com/cn/app/id1658729096"
        }
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        vc.completionWithItemsHandler = { _, isCompletion, _, _ in
            self.dismiss(animated: true)
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func rateAction() {
        self.dismiss(animated: true)
        let url = URL(string: "https://itunes.apple.com/cn/app/id1658729096")
        if let url = url {
            UIApplication.shared.open(url)
        }
    }
}
