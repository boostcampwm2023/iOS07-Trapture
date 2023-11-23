//
//  HomeSearchView.swift
//  traveline
//
//  Created by 김영인 on 2023/11/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

enum SearchViewType {
    case recent
    case related
}

final class HomeSearchView: UIView {
    
    private enum Metric {
        static let relatedInset: CGFloat = 24
        static let inset: CGFloat = 16
        static let height: CGFloat = 52
        static let topInset: CGFloat = 24
    }
    
    private enum SearchSection {
        case searchList
    }
    
    // MARK: - UI Components
    
    private lazy var searchCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: .init()
        )
        collectionView.register(cell: SearchCVC.self)
        collectionView.registerHeader(view: RecentHeaderView.self)
        collectionView.backgroundColor = TLColor.black
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Properties
    
    private typealias DataSource = UICollectionViewDiffableDataSource<SearchSection, SearchKeyword>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<SearchSection, SearchKeyword>
    
    private var dataSource: DataSource!
    
    // MARK: - Initializer
    
    init() {
        super.init(frame: .zero)
        
        setupAttributes()
        setupLayout()
        setupDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupDataSource() {
        dataSource = DataSource(
            collectionView: searchCollectionView
        ) { collectionView, indexPath, searchKeyword in
            let cell = collectionView.dequeue(cell: SearchCVC.self, for: indexPath)
            cell.setupData(item: searchKeyword)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let view = collectionView.dequeHeader(view: RecentHeaderView.self, for: indexPath)
            
            return view
        }
        
        searchCollectionView.dataSource = dataSource
    }
    
    func makeLayout(type: SearchViewType) {
        let layout = UICollectionViewCompositionalLayout { _, _  in
            let size = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(Metric.height)
            )
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(
                top: type == .recent ? Metric.topInset : 0,
                leading: type == .recent ? Metric.inset : Metric.relatedInset,
                bottom: 0,
                trailing: Metric.inset
            )
            
            if type == .recent {
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(20)
                )
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .topLeading
                )
                section.boundarySupplementaryItems = [headerItem]
            }
            
            return section
        }
        
        searchCollectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    func setupData(list: SearchKeywordList) {
        var snapshot = Snapshot()
        snapshot.appendSections([.searchList])
        snapshot.appendItems(list)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - Setup Functions

private extension HomeSearchView {
    func setupAttributes() {
        backgroundColor = TLColor.black
    }
    
    func setupLayout() {
        addSubviews(searchCollectionView)
        
        NSLayoutConstraint.activate([
            searchCollectionView.topAnchor.constraint(equalTo: topAnchor),
            searchCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

@available(iOS 17, *)
#Preview("HomeSearchView") {
    let view = HomeSearchView()
    view.setupData(
        list: SearchKeywordSample.makeRecentList()
    )
    return view
}