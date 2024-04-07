//
//  CircularProgressBar.swift
//  MyCalories
//
//  Created by Иван Семикин on 07/04/2024.
//

import UIKit

final class CircularProgressBar: UIView {
    private let progressLayer = CAShapeLayer()
    private let trackLayer = CAShapeLayer()
    private let progressLabel = UILabel()
    
    var progressColor: UIColor = .yellow {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    var trackColor: UIColor = .lightGray {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }
    
    var lineWidth: CGFloat = 3 {
        didSet {
            progressLayer.lineWidth = lineWidth
            trackLayer.lineWidth = lineWidth
        }
    }
    
    var progress: CGFloat = 0 {
        didSet {
            updateProgress()
        }
    }
    
    init(frame: CGRect, progressColor: UIColor) {
        super.init(frame: frame)
        self.progressColor = progressColor
        setupLayers()
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
        setupLabel()
    }
    
    private func setupLayers() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let circularPath = UIBezierPath(arcCenter: center, radius: bounds.width/2 - lineWidth/2, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi - CGFloat.pi / 2, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = lineWidth
        trackLayer.lineCap = .round
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        
        layer.addSublayer(trackLayer)
        layer.addSublayer(progressLayer)
    }
    
    private func setupLabel() {
        progressLabel.textColor = .white
        progressLabel.font = .boldSystemFont(ofSize: 17)
        progressLabel.textAlignment = .center
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressLabel)
        
        NSLayoutConstraint.activate([
            progressLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func updateProgress() {
        progressLayer.strokeEnd = progress
        progressLabel.text = "\(Int(progress * 100))%"
//        progressLabel.text = "100%"
    }
}

