//
//  TabVC.swift
//  PrettyBrowser
//
//  Created by yangjian on 2022/11/30.
//

import UIKit

class TabVC: BaseVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseUtil.logEvent(name: .tabShow)
    }
    
    @IBAction func backAction() {
        self.dismiss(animated: true)
    }
    
    @IBAction func newAction() {
        BrowseUtil.shared.add()
        FirebaseUtil.logEvent(name: .tabNew, params: ["lig": "tab"])
    }
    
    func delete(item: BrowseItem) {
        BrowseUtil.shared.remove(item)
    }
    
    func select(item: BrowseItem) {
        BrowseUtil.shared.select(item)
    }
}

extension TabVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        BrowseUtil.shared.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCell", for: indexPath)
        if let cell = cell as? TabCell {
            let item = BrowseUtil.shared.items[indexPath.row]
            cell.item = item
            cell.closeHandle = { [weak self] in
                self?.delete(item: item)
                collectionView.reloadData()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let width = self.view.window?.bounds.width ?? 375.0
        let w = width - 20 * 2 - 150 * 2 - 10
        return w
    }
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = BrowseUtil.shared.items[indexPath.row]
        self.select(item: item)
    }
}

class TabCell: UICollectionViewCell {
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var webView: UIView!
    
    @IBOutlet weak var urlLabel: UILabel!
    
    var closeHandle: (()->Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var item: BrowseItem? = nil {
        didSet {
            if let item = item {
                self.webView.isHidden = false
                self.urlLabel.text = item.webView.url?.absoluteString
            } else {
                self.webView.isHidden = true
            }
            
            closeButton.isHidden = BrowseUtil.shared.items.count == 1

            if item?.isSelect == true {
                self.layer.borderColor = UIColor.red.cgColor
                self.layer.borderWidth = 1
            } else {
                self.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBAction func closeAction() {
        closeHandle?()
    }
}
