//
//  TimelineVC.swift
//  traveline
//
//  Created by 김태현 on 11/22/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class TimelineVC: UIViewController {
    
    private enum Metric {
        static let travelInfoEstimatedHeight: CGFloat = 170.0
        static let timelineCardEstimatedHeight: CGFloat = 153.0
        static let headerHeight: CGFloat = 112.0
        
        enum FloatingButton {
            static let horizontalInset: CGFloat = 24.0
            static let verticalInset: CGFloat = 14.0
        }
    }
    
    // MARK: - UI Components
    
    private lazy var timelineCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        
        collectionView.register(cell: TravelInfoCVC.self)
        collectionView.register(cell: TimelineCardCVC.self)
        collectionView.registerHeader(view: TimelineDateHeaderView.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = TLColor.black
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    private let createPostingButton: TLFloatingButton = .init(style: .create)
    
    // MARK: - Properties
    
    // TODO: - dummy 제거
    private let dummyCardList = TimelineSample.makeCardList()
        
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttributes()
        setupLayout()
        setupCompositionalLayout()
    }
    
    // MARK: - Functions
    
    @objc func showMapView() {
        let mapVC = TimelineMapVC()
        mapVC.setMarker(by: TimelineSample.makeCardList(), day: 1)
        
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
    @objc private func createPostingButtonDidTapped() {
        let timelineWritingVC = TimelineWritingVC()
        navigationController?.pushViewController(timelineWritingVC, animated: true)
    }
    
}

// MARK: - Setup Functions

private extension TimelineVC {
    func setupAttributes() {
        view.backgroundColor = TLColor.black
        
        createPostingButton.addTarget(self, action: #selector(createPostingButtonDidTapped), for: .touchUpInside)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = TLColor.black
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let menuItems: [UIAction] = [
            .init(title: "수정하기", handler: { _ in
                // TODO: - 수정하기 연결
            }),
            .init(title: "삭제하기", attributes: .destructive, handler: { _ in
                // TODO: - 삭제하기 연결
            })
        ]
        let moreButton = UIBarButtonItem(
            image: TLImage.Travel.more.withRenderingMode(.alwaysOriginal),
            menu: .init(children: menuItems)
        )
        navigationItem.rightBarButtonItem = moreButton
                
        let backBarButtonItem = UIBarButtonItem(title: Literal.empty, style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = TLColor.white
        self.navigationItem.backBarButtonItem = backBarButtonItem

    }
    
    func setupLayout() {
        view.addSubviews(timelineCollectionView, createPostingButton)
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            timelineCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            timelineCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            timelineCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            timelineCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            createPostingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metric.FloatingButton.horizontalInset),
            createPostingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Metric.FloatingButton.verticalInset)
        ])
    }
    
    func setupCompositionalLayout() {
        let layout = UICollectionViewCompositionalLayout { [weak self] section, _ in
            switch section {
            case 0:
                self?.makeTravelInfoSection()
            case 1:
                self?.makeTimelineSection()
            default:
                self?.makeTravelInfoSection()
            }
        }
        
        timelineCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func makeTravelInfoSection() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(Metric.travelInfoEstimatedHeight)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: size)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: size,
            repeatingSubitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func makeTimelineSection() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(Metric.timelineCardEstimatedHeight)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: size)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: size,
            repeatingSubitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(Metric.headerHeight)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        header.pinToVisibleBounds = true
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
}

// MARK: - UICollectionView Delegate

extension TimelineVC: UICollectionViewDelegate {
    // TODO: - 상세 뷰 연결
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let timelineDetailVC = TimelineDetailVC(
            info: TimelineSample.makeDetailInfo()
        )
        
        navigationController?.pushViewController(timelineDetailVC, animated: true)
    }
}

extension TimelineVC: UICollectionViewDataSource {
    // TODO: - 모델 연결
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return dummyCardList.count
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeue(cell: TravelInfoCVC.self, for: indexPath)
            cell.setData(from: TimelineSample.makeTravelInfo())
            cell.delegate = self
            return cell
            
        case 1:
            let cell = collectionView.dequeue(cell: TimelineCardCVC.self, for: indexPath)
            cell.setData(by: dummyCardList[indexPath.row])
            let lastRow = collectionView.numberOfItems(inSection: indexPath.section) - 1
            if indexPath.row == lastRow { cell.changeToLast() }
            return cell
                
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeHeader(view: TimelineDateHeaderView.self, for: indexPath)
        header.delegate = self
        return header
    }
}

// MARK: - TravelInfo Delegate

extension TimelineVC: TravelInfoDelegate {
    func likeChanged(to isLiked: Bool) {
        // TODO: - 좋아요 변경 처리
        print("Like Changed")
    }
}

// MARK: - TimelineDateHeader Delegate

extension TimelineVC: TimelineDateHeaderDelegate {
    func goToMapView() {
        showMapView()
    }
}

@available(iOS 17, *)
#Preview {
    UINavigationController(rootViewController: TimelineVC())
}