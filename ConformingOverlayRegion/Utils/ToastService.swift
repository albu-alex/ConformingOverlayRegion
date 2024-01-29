//
//  ToastService.swift
//  ConformingOverlayRegion
//
//  Created by Alex Albu on 29.01.2024.
//

import UIKit

struct ToastService {
    
    static let shared = ToastService()

    func showToast(message: String, type: ToastType, duration: TimeInterval = 1.5) {
        let toastLabel = createToastLabel()
        toastLabel.text = message
        toastLabel.font = UIFont.systemFont(ofSize: 14.0)
        toastLabel.backgroundColor = getBackgroundForToast(type)
        toastLabel.textColor = .black
        
        if let window = UIApplication.keyWindow {
            window.addSubview(toastLabel)

            NSLayoutConstraint.activate([
                toastLabel.topAnchor.constraint(equalTo: window.topAnchor, constant: 100),
                toastLabel.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 24),
                toastLabel.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -24),
                toastLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 48)
            ])

            UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
                toastLabel.frame.origin.y = 200
                toastLabel.alpha = 1.0
            }, completion: { _ in
                UIView.animate(withDuration: duration, delay: duration, options: .curveEaseInOut, animations: {
                    toastLabel.frame.origin.y = -100
                    toastLabel.alpha = 0.0
                }, completion: { _ in
                    toastLabel.removeFromSuperview()
                })
            })
        }
    }
    
    private func createToastLabel() -> UILabel {
        let toastLabel = UILabel()
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.textAlignment = .center
        toastLabel.numberOfLines = 0
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        return toastLabel
    }
    
    private func getBackgroundForToast(_ type: ToastType) -> UIColor {
        switch type {
            case .error:
                return .red.withAlphaComponent(0.8)
            case .info:
                return .systemYellow.withAlphaComponent(0.6)
            case .success:
                return .green.withAlphaComponent(0.8)
        }
    }
}

