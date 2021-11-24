//
//  UIViewController+Labs.swift
//  ButtonProgressBar-iOS_Example
//
//  Created by NicholasXu on 2021/11/24.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

fileprivate struct IOSDev {
    static let closeButtonTag = -1000
}

extension UIViewController {
    func show(_ config:((_ viewController: UIViewController, _ closeButton: UIButton) -> Void)? = nil) {
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self.view)

            let btn = UIButton()
            btn.tag = IOSDev.closeButtonTag
            btn.setTitle("x", for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.backgroundColor = .black
            if #available(iOS 11.0, *) {
                btn.frame = CGRect(x: 16, y: 16 + self.view.safeAreaInsets.top, width: 32, height: 32)
            } else {
                btn.frame = CGRect(x: 16, y: 16, width: 32, height: 32)
            }
            btn.addTarget(self, action: #selector(clickToClose), for: .touchUpInside)
            self.view.backgroundColor = .white
            self.view.addSubview(btn)
            view.frame = window.bounds

            config?(self, btn)
        }
    }

    @objc public func clickToClose() {
        if let btn = self.view.viewWithTag(IOSDev.closeButtonTag) as? UIButton {
            btn.removeTarget(self, action: #selector(clickToClose), for: .touchUpInside)
            btn.removeFromSuperview()
        }
        self.view.removeFromSuperview()
    }
}
