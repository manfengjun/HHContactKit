//
//  ContactAuthorize.swift
//  HHContactKit
//
//  Created by ios on 2019/6/27.
//

import UIKit
import Contacts

@available(iOS 9.0, *)
// MARK: - 授权
extension CNContactStore {
    static func authorizeToContaces(completion: @escaping (Bool) -> Void) {
        if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            // 已授权
            completion(true)
        } else if CNContactStore.authorizationStatus(for: .contacts) == .denied {
            // 拒绝授权
            let contactUsage = "通讯录权限未开启"
            let contactUsageTip = "请您到 设置->\(UIApplication.appName)->相机 开启访问权限"
            let alert = UIAlertController(title: "温馨提示", message: contactUsage + "(" + contactUsageTip + ")", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let sureAction = UIAlertAction(title: "确定", style: .default) { _ in
                self.openSetting()
            }
            alert.addAction(cancelAction)
            alert.addAction(sureAction)
            UIApplication.currentVC?.present(alert, animated: true, completion: nil)
            completion(false)
        } else if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
            // 请求授权
            CNContactStore().requestAccess(for: .contacts) { isRight, _ in
                if isRight {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        } else {
            completion(false)
        }
    }
    
    /// 打开权限设置
    static func openSetting() {
        let url = URL(string: UIApplication.openSettingsURLString)
        if let url = url, UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                        
                    })
                }
            } else {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}
public extension UIApplication {
    /// 获取单例 delegate
    static var appDelegate: UIApplicationDelegate { return UIApplication.shared.delegate! }
    /// 获取当前 UIViewController
    static var currentVC: UIViewController? {
        var top = UIApplication.shared.keyWindow?.rootViewController
        if top?.presentedViewController != nil {
            top = top?.presentedViewController
        } else if top?.isKind(of: UITabBarController.classForCoder()) == true {
            top = (top as! UITabBarController).selectedViewController
            if (top?.isKind(of: UINavigationController.classForCoder()) == true) && (top as! UINavigationController).topViewController != nil {
                top = (top as! UINavigationController).topViewController
            }
        } else if (top?.isKind(of: UINavigationController.classForCoder()) == true) && (top as! UINavigationController).topViewController != nil {
            top = (top as! UINavigationController).topViewController
        }
        return top
    }
    /// 获取应用名称
    static var appName: String {
        if let name = Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String {
            return name
        }
        return Bundle.main.infoDictionary!["CFBundleName"] as? String ?? ""
    }
}
