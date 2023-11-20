//
//  SettingVC.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/19.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit
import SafariServices

enum ServiceGuideType: String, CaseIterable {
    case license = "라이센스"
    case termsOfUse = "이용약관"
    case privacyPolicy = "개인정보 처리방침"
    
    var link: String {
        switch self {
        case .license: return "https://www.apple.com"
        case .termsOfUse: return "https://www.naver.com"
        case .privacyPolicy: return "https://www.daum.net"
        }
    }
    
    func button() -> UIButton {
        let button = UIButton()
        button.setTitle(self.rawValue, for: .normal)
        button.setTitleColor(TLColor.white, for: .normal)
        
        return button
    }
    
}

// MARK: - Setting VC

final class SettingVC: UIViewController {
    // MARK: - UI Components
    private let lineWidth: CGFloat = 1
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 12
        return stackView
    }()
    
    let serviceGuides: [ServiceGuideType: UIButton] = {
        return ServiceGuideType.allCases.reduce(into: [:]) { result, key in
            result[key] = key.button()
        }
    }()
    
    let line: UIView = {
        let line = UIView()
        line.backgroundColor = TLColor.lineGray
        return line
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(TLColor.white, for: .normal)
        return button
    }()
    
    let withdrawalButton: UIButton = {
        let button = UIButton()
        button.setTitle("탈퇴하기", for: .normal)
        button.setTitleColor(TLColor.white, for: .normal)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttributes()
        setupLayout()
    }
    
    // MARK: - Functions
    
    @objc private func logoutButtonTapped() {
        showLogoutAlert()
    }
    
    @objc private func withdrawalButtonTapped() {
        showWithdrawalAlert()
    }
    
    private func showLogoutAlert() {
        let alert = TLAlertController(
            title: "로그아웃",
            message: "정말 로그아웃하시겠습니까?",
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let logout = UIAlertAction(title: "로그아웃", style: .destructive) { _ in
            // logout action
        }
        
        alert.addActions([cancel, logout])
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showWithdrawalAlert() {
        let alert = TLAlertController(
            title: "정말 탈퇴하시겠습니까?",
            message: "작성한 글들을 다시 볼 수 없습니다.",
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "취소", style: .default)
        let withdrawal = UIAlertAction(title: "탈퇴하기", style: .destructive) { _ in
            // withdrawal action
        }
        
        alert.addActions([withdrawal, cancel])
        cancel.setValue(TLColor.gray, forKey: "titleTextColor")
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Setup Functions

extension SettingVC {
    
    private func setupAttributes() {
        self.navigationItem.title = "설정"
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        withdrawalButton.addTarget(self, action: #selector(withdrawalButtonTapped), for: .touchUpInside)
        setupServiceGuideButton()
    }
    
    private func setupServiceGuideButton() {
        serviceGuides.forEach { type, button in
            let action = UIAction(handler: { _ in
                guard let url = URL(string: type.link) else { return }
                guard UIApplication.shared.canOpenURL(url) else { return }
                
                let safariVC = SFSafariViewController(url: url)
                self.present(safariVC, animated: true)
            })
            button.addAction(action, for: .touchUpInside)
        }
    }
    
    private func setupLayout() {
        view.addSubview(stackView)
        [
            serviceGuides[.license] ?? UIButton(),
            serviceGuides[.termsOfUse] ?? UIButton(),
            serviceGuides[.privacyPolicy] ?? UIButton(),
            line,
            logoutButton,
            withdrawalButton
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            line.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            line.heightAnchor.constraint(equalToConstant: lineWidth)
        ])
    }
    
}

