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
        self.backgroundColor = UIColor.clear
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Цвет заливки
//        let color = UIColor(red: 35/255.0, green: 139/255.0, blue: 140/255.0, alpha: 1)
        let color = UIColor(red: 3/255.0, green: 74/255.0, blue: 70/255.0, alpha: 1)
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        // Генерация текстуры с шумом
        if let noiseImage = generateNoiseTexture(size: rect.size, color: color) {
            context.draw(noiseImage.cgImage!, in: rect)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupRoundedCorners()
    }
    
    private func generateNoiseTexture(size: CGSize, color: UIColor) -> UIImage? {
        let scale = UIScreen.main.scale
        let width = Int(size.width * scale)
        let height = Int(size.height * scale)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        var pixelData = [UInt8](repeating: 0, count: width * height * bytesPerPixel)
        
        for y in 0..<height {
            for x in 0..<width {
                let offset = (y * width + x) * bytesPerPixel
                let noise = UInt8.random(in: 0...255)
                let red = UInt8((color.cgColor.components?[0] ?? 0) * 255)
                let green = UInt8((color.cgColor.components?[1] ?? 0) * 255)
                let blue = UInt8((color.cgColor.components?[2] ?? 0) * 255)
                
                pixelData[offset] = red
                pixelData[offset + 1] = green
                pixelData[offset + 2] = blue
                pixelData[offset + 3] = noise / 4 // уменьшение интенсивности шума
            }
        }
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        guard let context = CGContext(data: &pixelData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            return nil
        }
        
        guard let cgImage = context.makeImage() else {
            return nil
        }
        
        return UIImage(cgImage: cgImage, scale: scale, orientation: .up)
    }
}
