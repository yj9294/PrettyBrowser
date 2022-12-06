//
//  HomeVC.swift
//  PrettyBrowser
//
//  Created by yangjian on 2022/11/29.
//

import UIKit
import WebKit
import AppTrackingTransparency

class HomeVC: BaseVC {
    
    enum Item: CaseIterable {
        case facebook, google, youtube, twitter, instagram, amazone, gmail, yahoo
        var url: String {
            return "https://m.\(self).com"
        }
    }

    var item: BrowseItem{
        BrowseUtil.shared.item
    }
    
    @IBOutlet weak var cleanAlertView: CleanAlertView!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var progressView: ProgressView!
    @IBOutlet weak var tabButton: UIButton!
    
    @IBOutlet weak var lastButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var contentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        ATTrackingManager.requestTrackingAuthorization { _ in
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        item.webView.frame = contentView.bounds
    }
    
    @IBAction func searchAction() {
        searchTextField.resignFirstResponder()
        if let text = searchTextField.text, text.count > 0 {
            FirebaseUtil.logEvent(name: .navigaSearch, params: ["lig": text])
            search(text)
            return
        }
        alert("Please enter your search content.")
    }
    
    @IBAction func closeAction() {
        item.stopLoad()
    }
    
    @IBAction func buttonClick(btn: UIButton) {
        if Item.allCases.count > btn.tag - 1 {
            let item = Item.allCases[btn.tag - 1]
            let text = item.url
            FirebaseUtil.logEvent(name: .navigaClick, params: ["lig": text])
            search(text)
        }
    }
    
    @IBAction func lastAction() {
        item.webView.goBack()
    }
    
    @IBAction func nextAction() {
        item.webView.goForward()
    }
    
    @IBAction func cleanAction() {
        FirebaseUtil.logEvent(name: .cleanClick)
        cleanAlertView.alpha = 1
    }
    
    @IBAction func getSegue(segue : UIStoryboardSegue){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.layoutView()
        }
    }
    
    @IBAction func cleanHandle(segue: UIStoryboardSegue) {
        FirebaseUtil.logEvent(name: .cleanSuccess)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.layoutView()
            self.searchTextField.text = ""
            self.alert("Clean successfully.")
            FirebaseUtil.logEvent(name: .cleanAlert)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == "toSettingVC" {
            segue.destination.modalPresentationStyle = .overCurrentContext
        }
    }
    
}

extension HomeVC {
    
    func search(_ text: String) {
        self.view.endEditing(true)
        item.loadUrl(text)
        layoutView()
    }
    
    func layoutView() {
        FirebaseUtil.logEvent(name: .homeShow)

        tabButton.setTitle("\(BrowseUtil.shared.items.count)", for: .normal)
        searchTextField.text = item.webView.url?.absoluteString
        progressView.isHidden = !item.webView.isLoading
        item.backEnableHandle = { [weak self] (i,canGoBack) in
            guard let self = self else { return }
            if self.item != i {
                return
            }
            DispatchQueue.main.async {
                self.lastButton.isEnabled = canGoBack
            }
        }
        
        item.nextEnableHandle = { [weak self] (i,canGoForward) in
            guard let self = self else { return }
            if self.item != i {
                return
            }
            DispatchQueue.main.async {
                self.nextButton.isEnabled = canGoForward
            }
        }
        
        var date: Date = Date()
        item.progressExchangedHandle = { [weak self] (i,progress) in
            guard let self = self else { return }
            if self.item != i {
                return
            }
            debugPrint(progress)
            
            if progress == 0.1 {
                date = Date()
                FirebaseUtil.logEvent(name: .webStart)
            }
            
            if progress == 1.0 {
                let date = Date().timeIntervalSince1970 - date.timeIntervalSince1970
                FirebaseUtil.logEvent(name: .webSuccess, params: ["lig": "\(ceil(date))"])
            }
            
            self.progressView.isHidden = progress == 1.0
            self.searchButton.isHidden = progress != 1.0
            self.closeButton.isHidden = progress == 1.0
            self.progressView.progress = Double(progress)
            if progress >= 1.0 {
            } else if progress == 0.1 {
            }
        }
        
        if let url = item.webView.url?.absoluteString {
            item.webView.isHidden = url.count == 0
        } else {
            item.webView.isHidden = true
        }
        item.urlExchangedHandle = { [weak self] (i,url) in
            guard let self = self else { return }
            if self.item != i {
                return
            }
            self.searchTextField.text = url
            self.item.webView.isHidden = url.count == 0
        }
        
        item.webView.isUserInteractionEnabled = true
        contentView.subviews.forEach {
            if $0 is WKWebView {
                $0.removeFromSuperview()
            }
        }
        contentView.addSubview(item.webView)
        item.webView.frame = contentView.bounds
    }
}



extension HomeVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = searchTextField.text, text.count > 0 {
            search(text)
            return true
        }
        alert("Please enter your search content.")
        return true
    }
    
}
