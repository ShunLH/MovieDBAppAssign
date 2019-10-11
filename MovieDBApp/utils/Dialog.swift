//
//  Dialog.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/11/19.
//  Copyright © 2019 SLH. All rights reserved.
//


import Foundation
import UIKit


class Dialog {
    static func showAlert(viewController : UIViewController, title : String, message : String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alertVC, animated: true, completion: nil)
    }

}
