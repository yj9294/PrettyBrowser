//
//  CleanVC.swift
//  PrettyBrowser
//
//  Created by yangjian on 2022/12/2.
//

import UIKit
import Lottie

class CleanVC: BaseVC {
    
    let animationView = LottieAnimationView()
    
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView.animation = LottieAnimation.named("data")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(animationView, aboveSubview: titleLabel)
        
        NSLayoutConstraint.activate([
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        GADUtil.share.load(.interstitial)
        
        
        var progress = 0.0
        var duration = 2.5 / 0.6
        var isNeedShowAd = false
        
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] timer in
            guard let self  = self else { return }
            if progress >= 1.0 {
                timer.invalidate()
                GADUtil.share.show(.interstitial, from: self) { _ in
                    GADUtil.share.load(.native)
                    GADUtil.share.load(.interstitial)
                    
                    BrowseUtil.shared.item.stopLoad()
                    
                    BrowseUtil.shared.items = [.navgationItem]
                    
                    self.performSegue(withIdentifier: "cleanBackToHomeVC", sender: nil)
                }
            } else {
                progress += 1.0 / (duration * 100)
            }
            
            if isNeedShowAd, GADUtil.share.isLoaded(.interstitial) {
                isNeedShowAd = false
                duration = 0.1
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isNeedShowAd = true
            duration = 16.0
        }
    }

}
