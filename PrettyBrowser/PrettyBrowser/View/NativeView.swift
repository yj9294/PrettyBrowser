//
//  NativeView.swift
//  PrettyBrowser
//
//  Created by yangjian on 2022/12/6.
//

import GoogleMobileAds

class NativeView: GADNativeAdView {
    
    @IBOutlet weak var placeholder: UIImageView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var adTag: UIImageView!
    @IBOutlet weak var installButton: UIButton!
    
    var ad: GADNativeAd? {
        didSet {
            nativeAd = ad
            guard let ad = ad else {
                icon.isHidden = true
                title.isHidden = true
                subTitle.isHidden = true
                adTag.isHidden = true
                installButton.isHidden = true
                placeholder.isHidden = false
                return
            }
            
            icon.isHidden = false
            title.isHidden = false
            subTitle.isHidden = false
            adTag.isHidden = false
            installButton.isHidden = false
            placeholder.isHidden = true
            
            icon.image = ad.icon?.image
            title.text = ad.headline
            subTitle.text = ad.body
            installButton.setTitle(ad.callToAction, for: .normal)
            
            iconView = icon
            headlineView = title
            bodyView = subTitle
            callToActionView = installButton

        }
    }
}
