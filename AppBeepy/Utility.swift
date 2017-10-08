//
//  Utility.swift
//  AppBeepy
//
//  Created by andrzej semeniuk on 10/8/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    open func createAlertForInput               (animated:Bool = true, title:String, message:String, value:String = "", ok:String = "Ok", cancel:String = "Cancel", setter:@escaping (String)->()) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { textfield in
            textfield.text = value
        }
        let ok = UIAlertAction.init(title: ok, style: UIAlertActionStyle.default) { action in
            setter(alert.textFields?[safe:0]?.text ?? "")
            alert.dismiss(animated: animated) {
            }
        }
        alert.addAction(ok)
        let cancel = UIAlertAction.init(title: cancel, style: UIAlertActionStyle.cancel) { action in
            alert.dismiss(animated: animated) {
            }
        }
        alert.addAction(cancel)
        self.present(alert, animated: animated)
    }
    
    open func createAlertForAnswer                (animated:Bool = true, title:String, message:String, ok:String = "Ok", handler:(()->())? = nil) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction.init(title: ok, style: UIAlertActionStyle.default) { action in
            handler?()
            alert.dismiss(animated: animated) {
            }
        }
        alert.addAction(ok)
        self.present(alert, animated: animated)
    }
    
    open func createAlertForQuestion            (animated:Bool = true, title:String, message:String, ok:String = "Ok", cancel:String = "Cancel", handler:@escaping ()->() ) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction.init(title: ok, style: UIAlertActionStyle.default) { action in
            handler()
            alert.dismiss(animated: animated) {
            }
        }
        alert.addAction(ok)
        let cancel = UIAlertAction.init(title: cancel, style: UIAlertActionStyle.cancel) { action in
            alert.dismiss(animated: animated) {
            }
        }
        alert.addAction(cancel)
        self.present(alert, animated: animated)
    }
    
    open func createAlertForUITextField         (_ field:UITextField, animated:Bool = true, title:String, message:String, ok:String = "Ok", cancel:String = "Cancel", setter:@escaping (String)->()) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { textfield in
            textfield.text = field.text
        }
        let ok = UIAlertAction.init(title: ok, style: UIAlertActionStyle.default) { action in
            setter(alert.textFields?[safe:0]?.text ?? "")
            alert.dismiss(animated: animated) {
            }
        }
        alert.addAction(ok)
        let cancel = UIAlertAction.init(title: cancel, style: UIAlertActionStyle.cancel) { action in
            alert.dismiss(animated: animated) {
            }
        }
        alert.addAction(cancel)
        self.present(alert, animated: animated)
    }
    
    open func createAlertForChoice              (animated:Bool = true, title:String, message:String, choices:[String], cancel:String = "Cancel", handler:@escaping (String)->()) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
        for choice in choices {
            let ok = UIAlertAction.init(title: choice, style: .destructive) { action in
                handler(choice)
                //                alert.dismiss(animated: true) {
                //                }
            }
            alert.addAction(ok)
        }
        let cancel = UIAlertAction.init(title: cancel, style: .cancel) { action in
            alert.dismiss(animated: animated) {
            }
        }
        alert.addAction(cancel)
        self.present(alert, animated: animated)
    }

}
