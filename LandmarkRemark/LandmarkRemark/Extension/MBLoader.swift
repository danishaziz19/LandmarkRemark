//
//  MBLoader.swift
//  LandmarkRemark
//
//  Created by Danish Aziz on 20/3/21.
//

import MBProgressHUD

class MBLoader: NSObject {
    
    public static func show() {
        if let view = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
            .filter({$0.isKeyWindow}).first?.rootViewController?.view {
            MBProgressHUD.showAdded(to: view, animated: true)
        }
    }
    
    public static func hide() {
        if let view = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
                .filter({$0.isKeyWindow}).first?.rootViewController?.view {
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    
    public static func show(view: UIView) {
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    public static func hide(view: UIView) {
        MBProgressHUD.hide(for: view, animated: true)
    }
}
