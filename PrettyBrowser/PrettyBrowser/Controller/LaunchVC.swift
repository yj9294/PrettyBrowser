//
//  LaunchVC.swift
//  PrettyBrowser
//
//  Created by yangjian on 2022/11/29.
//

import UIKit

class LaunchVC: BaseVC {
    
    @IBOutlet weak var progressView: UIProgressView!
    
    var progress = 0.0 {
        didSet {
            progressView.progress = Float(progress)
        }
    }
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(forName: .launching, object: nil, queue: .main) { [weak self] _ in
            self?.launching()
        }
        
        FirebaseUtil.logProperty(name: .local)
        FirebaseUtil.logEvent(name: .open)
        FirebaseUtil.logEvent(name: .openCold)
    }
    
    func launching() {
        progress = 0
        let duration = 2.5
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] timer in
            guard let self  = self else { return }
            if self.progress >= 1.0 {
                timer.invalidate()
                NotificationCenter.default.post(name: .launched, object: nil)
            } else {
                self.progress += 1.0 / (duration * 100)
            }
        }
    }
}
