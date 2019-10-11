//
//  Extensions.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/11/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView


extension UIViewController : NVActivityIndicatorViewable {
	func showIndicatior(_ message : String) {
		startAnimating(CGSize(width: 40, height: 40),message: message,type: NVActivityIndicatorType.ballScaleRipple, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
	}
	func hideIndicator() {
		stopAnimating()
	}
}
