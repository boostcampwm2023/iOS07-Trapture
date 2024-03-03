//
//  SelectedLocationButton.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class SelectLocationButton: UIView {
    
    private enum Constants {
        static let defaultText: String = "장소 선택"
        static let labelHeight: CGFloat = 24
        static let spacing: CGFloat = 6
        static let buttonSpacing: CGFloat = 2
    }
    // MARK: - UI Components
    
    private let icon: UIImageView = .init(image: TLImage.Travel.locationDisable)
    private let label: TLLabel = .init(font: TLFont.body1, color: TLColor.disabledGray)
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(TLImage.Tag.close, for: .normal)
        
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
    
    // MARK: - properties
    
    private var hasLocation: Bool {
        label.text != Constants.defaultText
    }
    
    // MARK: - Functions
    
    private func updateLayout() {
        if hasLocation {
            icon.image = TLImage.Travel.location
            label.setColor(to: TLColor.white)
            cancelButton.isHidden = false
        } else {
            icon.image = TLImage.Travel.locationDisable
            label.setColor(to: TLColor.disabledGray)
            cancelButton.isHidden = true
        }
    }
    
    func setText(to text: String) {
        label.setText(to: text)
        updateLayout()
    }
    
}

// MARK: - Setup Functions

private extension SelectLocationButton {
    func setupAttributes() {
        setText(to: Constants.defaultText)
    }
    
    func setupLayout() {
        addSubviews(
            icon,
            label,
            cancelButton
        )
        
        translatesAutoresizingMaskIntoConstraints = false
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.sizeToFit()
        }
        
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: leadingAnchor),
            icon.topAnchor.constraint(equalTo: topAnchor),
            icon.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            label.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: Constants.spacing),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: topAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: Constants.buttonSpacing),
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
