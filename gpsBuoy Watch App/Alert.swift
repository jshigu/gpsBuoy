//
//  Alert.swift
//  gpsBuoy Watch App
//
//  Created by 世吉 on 2024/04/20.
//

import UIKit

final class Alert {
    // OKのみアラート
    static func okAlert(vc: UIViewController, title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let okAlertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        okAlertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        vc.present(okAlertVC, animated: true, completion: nil)
    }
    
    // OK&キャンセルアラート
    　static func cancelAlert(vc: UIViewController, title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let cancelAlertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        cancelAlertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        cancelAlertVC.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        vc.present(cancelAlertVC, animated: true, completion: nil)
    }
    
    // TextField付きアラート
    　static func textFieldAlert(vc: UIViewController, title: String, message: String, placeholder: String, securyText: Bool, handler: ((String?) -> Void)? = nil) {
        let textFieldAlertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        textFieldAlertVC.addTextField { (textField) in
            textField.placeholder = placeholder
            textField.isSecureTextEntry = securyText
        }
        textFieldAlertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            handler?(textFieldAlertVC.textFields?.first?.text)
        }))
        textFieldAlertVC.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        vc.present(textFieldAlertVC, animated: true, completion: nil)
    }
    
    // 自動で消えるアラート
    static func autoCloseAlert(vc: UIViewController, title: String, message: String) {
        let autoCloseAlertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        vc.present(autoCloseAlertVC, animated: true) {
            // 1.5秒後に削除
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                autoCloseAlertVC.dismiss(animated: true, completion: nil)
            }
        }
    }
}
