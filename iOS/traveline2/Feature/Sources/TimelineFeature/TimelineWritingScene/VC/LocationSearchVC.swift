//
//  LocationSearchVC.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import UIKit

protocol LocationSearchDelegate: AnyObject {
    func selectedLocation(result: TimelinePlace)
    func editingChagnedLocation(text: String)
}

final class LocationSearchVC: UIViewController {
    
    private enum Metric {
        static let topInset: CGFloat = 27
        static let margin: CGFloat = 16
        static let contentHeight: CGFloat = 52
        static let placeHeight: CGFloat = 65
    }
    
    private enum Constants {
        static let titleText = "장소 선택"
        static let placeholder = "여행 검색"
    }
    
    // MARK: - UI Components
    
    private let header: UIView = .init()
    private let headerTitle: TLLabel = .init(
        font: TLFont.subtitle1,
        text: Constants.titleText,
        color: TLColor.white
    )
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(TLImage.Common.close, for: .normal)
        
        return button
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = Constants.placeholder
        searchBar.searchTextField.textColor = TLColor.white
        searchBar.barTintColor = TLColor.black
        searchBar.searchTextField.backgroundColor = TLColor.backgroundGray
        searchBar.backgroundColor = TLColor.black
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = TLColor.black
        tableView.keyboardDismissMode = .onDrag
        tableView.register(PlaceTVC.self, forCellReuseIdentifier: PlaceTVC.identifier)
        
        return tableView
    }()
    
    // MARK: - Properties
    
    private var results: TimelinePlaceList = []
    private var keyword: String = ""
    weak var delegate: LocationSearchDelegate?
    
    let didScrollToBottom: PassthroughSubject<Void, Never> = .init()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttributes()
        setupLayout()
    }
    
    // MARK: - Functions
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    func setData(keyword: String, places: TimelinePlaceList) {
        self.keyword = keyword
        results = places
        tableView.reloadData()
    }
    
}

// MARK: - Setup Functions

private extension LocationSearchVC {
    
    func setupAttributes() {
        view.backgroundColor = TLColor.black
        header.backgroundColor = TLColor.black
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = Metric.placeHeight
        
        closeButton.addTarget(
            self,
            action: #selector(closeButtonTapped),
            for: .touchUpInside
        )
        
        searchBar.text = .none
        results = []
        tableView.reloadData()
    }
    
    func setupLayout() {
        view.addSubviews(
            header,
            searchBar,
            tableView
        )
        header.addSubviews(
            closeButton,
            headerTitle
        )
        
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        header.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: Metric.contentHeight),
            
            closeButton.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: Metric.margin),
            closeButton.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            headerTitle.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            headerTitle.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            
            searchBar.topAnchor.constraint(equalTo: header.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: Metric.contentHeight),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Metric.topInset),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
}

// MARK: - UISearchBarDelegate extension

extension LocationSearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.editingChagnedLocation(text: searchText)
    }
}

// MARK: - UITableViewDelegate extension

extension LocationSearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = results[indexPath.row]
        delegate?.selectedLocation(result: place)
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource extension

extension LocationSearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaceTVC.identifier) as? PlaceTVC else { return UITableViewCell() }
        
        let title = results[indexPath.row].title
        let address = results[indexPath.row].address
        
        cell.setData(place: title, address: address, keyword: keyword)
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.size.height {
            didScrollToBottom.send(Void())
        }
    }
    
}

@available(iOS 17, *)
#Preview("LocationSearchVC") {
    let vc = LocationSearchVC()
    let homeNV = UINavigationController(rootViewController: vc)
    return homeNV
}
