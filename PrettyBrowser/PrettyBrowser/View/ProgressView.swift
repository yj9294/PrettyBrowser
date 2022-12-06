//
//  ProgressView.swift
//  PrettyBrowser
//
//  Created by yangjian on 2022/11/30.
//

import Foundation
import UIKit

class ProgressView: UIView {
    
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    
    var progress: Double = 0.0 {
        didSet {
            contentViewWidthConstraint.constant = self.progress * self.bounds.width
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
