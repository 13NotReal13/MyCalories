//
//  TexturedView.swift
//  MyCalories
//
//  Created by Иван Семикин on 02/05/2024.
//

import UIKit

class TexturedView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = UIColor.clear
        setupRoundedCorners()
    }

    private func setupRoundedCorners() {
        // Создаем путь с закругленными верхними углами
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: 35, height: 35))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let color = UIColor(red: 45/255.0, green: 149/255.0, blue: 150/255.0, alpha: 1)
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let path = CGMutablePath()
        path.addRect(rect)
        context.addPath(path)
        
        context.saveGState()
        context.setLineWidth(2)
        context.setLineCap(.round)
        context.setStrokeColor(UIColor.darkGray.withAlphaComponent(0.2).cgColor)
        
        for y in stride(from: 0, to: rect.height, by: 5) {
            context.move(to: CGPoint(x: 0, y: y))
            context.addLine(to: CGPoint(x: rect.width, y: y))
        }
        
        context.strokePath()
        context.restoreGState()
    }

    // Обновляем путь маски при изменении размеров вью
    override func layoutSubviews() {
        super.layoutSubviews()
        setupRoundedCorners()
    }
}
