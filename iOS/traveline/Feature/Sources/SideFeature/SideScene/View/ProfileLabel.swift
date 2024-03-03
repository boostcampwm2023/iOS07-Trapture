//
//  ProfileLabel.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/24.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class ProfileLabel: UIView {
    
    private enum Metric {
        static let margin: CGFloat = 16.0
        static let imageWidth: CGFloat = 30.0
        static let spacing: CGFloat = 8.0
        static let buttonWidth: CGFloat = 54.0
        static let buttonHeight: CGFloat = 28.0
    }
    
    // MARK: - UI Components
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        view.layer.cornerRadius = Metric.imageWidth / 2
        view.backgroundColor = TLColor.backgroundGray
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let idLabel: TLLabel = .init(font: TLFont.subtitle1, text: "", color: TLColor.white)
    
    let editButton: UIButton = {
        var config = UIButton.Configuration.plain()
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 48, height: 28))
        
        config.title = "수정"
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = TLColor.white
        config.background.cornerRadius = 12
        config.background.strokeColor = TLColor.white
        config.background.strokeWidth = 1.5
        
        button.titleLabel?.font = TLFont.body4.font
        button.configuration = config
        
        return button
    }()
    
    // MARK: - initialize
    
    init() {
        super.init(frame: .zero)
        
        setupAttributes()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func updateProfile(_ profile: Profile) {
        idLabel.setText(to: profile.name)
        guard profile.imageURL != Literal.empty else {
            imageView.image = nil
            return
        }
        imageView.setImage(from: profile.imageURL, imagePath: profile.imagePath)
    }
}

// MARK: - Setup Functions

private extension ProfileLabel {
    
    func setupAttributes() {
        idLabel.numberOfLines = 2
    }
    
    func setupLayout() {
        addSubviews(
            imageView,
            idLabel,
            editButton
        )
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: Metric.imageWidth),
            imageView.heightAnchor.constraint(equalToConstant: Metric.imageWidth),
            
            idLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Metric.spacing),
            idLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            idLabel.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -Metric.spacing),
            
            editButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            editButton.leadingAnchor.constraint(equalTo: idLabel.trailingAnchor, constant: Metric.spacing),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            editButton.widthAnchor.constraint(equalToConstant: Metric.buttonWidth),
            editButton.heightAnchor.constraint(equalToConstant: Metric.buttonHeight)
        ])
    }
    
}
