//
//  CardView.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/10/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable

class CardView : UIView {
	@IBInspectable var cornerRadius : CGFloat = 2
	@IBInspectable var shadowOffsetWidth : Int = 0
	@IBInspectable var shadowOffsetHeight : Int = 3
	@IBInspectable var shadowColor : UIColor? = UIColor.black
	@IBInspectable var shadowOpacity : Float = 0.5
	@IBInspectable var isMaskToBounds : Bool = false
	
	override func layoutSubviews() {
		layer.cornerRadius = cornerRadius
		let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
		layer.masksToBounds = isMaskToBounds
		layer.shadowColor = shadowColor?.cgColor
		layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
		layer.shadowOpacity = shadowOpacity
		layer.shadowPath = shadowPath.cgPath
	}
}
