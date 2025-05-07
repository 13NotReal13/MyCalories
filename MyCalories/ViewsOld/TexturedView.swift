//
//  TexturedView.swift
//  MyCalories
//
//  Created by Иван Семикин on 02/05/2024.
//

import UIKit

final class TexturedView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupRoundedCorners()
    }

    private func setupRoundedCorners() {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: 35, height: 35))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupRoundedCorners()
    }
}
