//
//  FirebaseUtil.swift
//  PrettyBrowser
//
//  Created by yangjian on 2022/12/2.
//

import UIKit
import Firebase

func SLog(_ log: @autoclosure () -> String) {
#if DEBUG
    NSLog("\(log())")
#else
    NSLog(log())
#endif
}

class FirebaseUtil: NSObject {
    static func logEvent(name: FirebaseEvent, params: [String: Any]? = nil) {
        
        if name.first {
            if UserDefaults.standard.bool(forKey: name.rawValue) == true {
                return
            } else {
                UserDefaults.standard.set(true, forKey: name.rawValue)
            }
        }
        
        if name == .homeShow, BrowseUtil.shared.item.isNavigation {
            logEvent(name: .navigaShow)
        }
        
        #if DEBUG
        #else
        Analytics.logEvent(name.rawValue, parameters: params)
        #endif
        
        SLog("[Event] \(name.rawValue) \(params ?? [:])")
    }
    
    static func logProperty(name: FirebaseProperty, value: String? = nil) {
        
        var value = value
        
        if name.first {
            if UserDefaults.standard.string(forKey: name.rawValue) != nil {
                value = UserDefaults.standard.string(forKey: name.rawValue)!
            } else {
                UserDefaults.standard.set(Locale.current.regionCode ?? "us", forKey: name.rawValue)
            }
        }
#if DEBUG
#else
        Analytics.setUserProperty(value, forName: name.rawValue)
#endif
        SLog("[Property] \(name.rawValue) \(value ?? "")")
    }
}

enum FirebaseProperty: String {
    /// 設備
    case local = "w"
    
    var first: Bool {
        switch self {
        case .local:
            return true
        }
    }
}

enum FirebaseEvent: String {
    
    var first: Bool {
        switch self {
        case .open:
            return true
        default:
            return false
        }
    }
    
    /// 首次打開
    case open = "e_21"
    /// 冷啟動
    case openCold = "r_21"
    /// 熱起動
    case openHot = "h_21"
    
    /// 主頁展示
    case homeShow = "u_21"
    
    /// 展示导航页面
    case navigaShow = "i_21"
    
    /// 导航点击
    /// lib（点击的网站）：facebook / google / youtube / twitter / instagram / amazon / gmail / yahoo
    case navigaClick = "o_21"
    
    /// 在导航页上方输入栏中输入内容，并点击键盘上的 search
    /// lib（用户输入的内容）：具体的内容直接打印出来
    case navigaSearch = "p_21"
    
    /// clean click
    case cleanClick = "z_21"
    
    /// 清理动画展示完成
    case cleanSuccess = "x_21"
    
    /// 展示清理成功的 toast 提示
    /// bro（点击清理按钮～展示 toast 的时间）：秒，时间向上取整，不足 1 计 1
    case cleanAlert = "c_21"
    
    /// 展示 tab 管理页
    case tabShow = "b_21"
    
    /// 点击开启新 tab 按钮时，立马打点
    /// - 包括：tab 管理页点击底部加号、设置弹窗点击加号
    /// lig（点击开启新 tab 按钮的位置）：tab（tab 管理页）/ setting（设置弹窗）
    case tabNew = "v_21"
    
    
    /// share click
    case shareClick = "n_21"
    
    /// copy click
    case copyClick = "m_21"
    
    case webStart = "k_21"
    
    /// lig（开始请求～加载成功的时间）：秒，时间向上取整，不足 1 计 1
    case webSuccess = "ll_21"
}
