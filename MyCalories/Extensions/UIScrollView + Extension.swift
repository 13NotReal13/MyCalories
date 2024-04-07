//
//  UIScrollView + Extension.swift
//  MyCalories
//
//  Created by Иван Семикин on 07/04/2024.
//

import UIKit

extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        setContentOffset(bottomOffset, animated: animated)
    }
}
