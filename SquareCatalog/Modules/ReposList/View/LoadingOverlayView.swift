//
//  LoadingOverlayView.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 25.12.2025.
//

import UIKit

final class LoadingOverlayView: UIView {

    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemUltraThinMaterial)
        let v = UIVisualEffectView(effect: blur)
        v.backgroundColor = UIColor.black.withAlphaComponent(0.18)
        return v
    }()

    private let loaderView = LoaderView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        setupBlurView()
        setupConstraints()
        isHidden = true
        alpha = 0
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func setLoading(_ isLoading: Bool, animated: Bool = true) {
        if isLoading {
            isHidden = false
            loaderView.startAnimating()

            if animated {
                UIView.animate(withDuration: 0.15) { self.alpha = 1 }
            } else {
                alpha = 1
            }
        } else {
            let finish = {
                self.loaderView.stopAnimating()
                self.isHidden = true
            }

            if animated {
                UIView.animate(withDuration: 0.15, animations: {
                    self.alpha = 0
                }, completion: { _ in
                    finish()
                })
            } else {
                alpha = 0
                finish()
            }
        }
    }
    
    private func setupBlurView() {
        addSubview(blurView)
        blurView.contentView.addSubview(loaderView)
    }
    
    private func setupConstraints() {
        blurView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            loaderView.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: blurView.centerYAnchor),
            
            loaderView.widthAnchor.constraint(equalToConstant: 220),
            loaderView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
}


