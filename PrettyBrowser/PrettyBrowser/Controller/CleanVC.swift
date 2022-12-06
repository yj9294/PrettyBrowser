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

        

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            BrowseUtil.shared.item.stopLoad()
            
            BrowseUtil.shared.items = [.navgationItem]
            
            self.performSegue(withIdentifier: "cleanBackToHomeVC", sender: nil)
        }
    }

}
