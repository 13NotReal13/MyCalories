//
//  UIView + Ext.swift
//  MyCalories
//
//  Created by Иван Семикин on 27/04/2024.
//

import UIKit

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        ).cgPath
        layer.mask = maskLayer
    }
    
    func setShadow(cornerRadius: CGFloat, shadowColor: UIColor, shadowOffset: CGSize, shadowRadius: CGFloat, shadowOpacity: Float) {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        self.clipsToBounds = false
        self.layer.masksToBounds = false
    }
}
