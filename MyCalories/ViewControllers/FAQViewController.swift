//
//  FAQViewController.swift
//  MyCalories
//
//  Created by Иван Семикин on 06/06/2024.
//

import UIKit

final class FAQViewController: UIViewController {
    
    @IBOutlet var extendingNavigationBarView: UIView!
    @IBOutlet var questionsViews: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        questionsViews.forEach { questionView in
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleAnswerVisibility(_:)))
            questionView.addGestureRecognizer(tapGesture)
            questionView.isUserInteractionEnabled = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        extendingNavigationBarView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 50)
    }
    
    @objc private func toggleAnswerVisibility(_ sender: UITapGestureRecognizer) {
        if let questionView = sender.view {
            // Предполагается, что в questionView есть stackView с двумя лейблами
            let stackView = questionView.subviews.first(where: { $0 is UIStackView }) as? UIStackView
            let answerLabel = stackView?.arrangedSubviews.compactMap { $0 as? UILabel }.last
            answerLabel?.isHidden.toggle() // Переключение видимости
        }
    }
    
    private func setupUI() {
        for questionView in questionsViews {
            questionView.setShadow(
                cornerRadius: 15,
                shadowColor: .black,
                shadowOffset: CGSize(width: 0, height: 2),
                shadowRadius: 0.6,
                shadowOpacity: 0.3
            )
        }
    }
}
