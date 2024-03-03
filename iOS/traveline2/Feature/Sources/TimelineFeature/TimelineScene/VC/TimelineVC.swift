//
//  TimelineVC.swift
//  traveline
//
//  Created by 김태현 on 11/22/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
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
    
    private enum Constants {
        static let didFinishDeleteWithSuccess: String = "여행 삭제를 완료했어요 !"
        static let didFinishDeleteWithFailure: String = "여행 삭제에 실패했어요."
    }
    
    private enum TimelineSection: Int {
        case travelInfo
        case timeline
    }
    
    private enum TimelineItem: Hashable {
        case travelInfoItem(TimelineTravelInfo)
        case timelineItem(TimelineCardInfo)
    }
    
    // MARK: - UI Components
    
    private lazy var tlNavigationBar: TLNavigationBar = .init(vc: self)
    
    private lazy var timelineCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: .init()
        )
        
        collectionView.register(cell: TravelInfoCVC.self)
        collectionView.register(cell: TimelineCardCVC.self)
        collectionView.registerHeader(view: TimelineDateHeaderView.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = TLColor.black
        collectionView.delegate = self
        
        return collectionView
    }()
    
    private let emptyView: TLEmptyView = .init(type: .timeline)
    
    private let createPostingButton: TLFloatingButton = .init(style: .create)
    
    // MARK: - Properties
    
    private typealias DataSource = UICollectionViewDiffableDataSource<TimelineSection, TimelineItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<TimelineSection, TimelineItem>
    
    private var dataSource: DataSource!
    
    private var cancellables: Set<AnyCancellable> = .init()
    private let viewModel: TimelineViewModel
    weak var delegate: ToastDelegate?
    
    // MARK: - Initializer
    
    init(viewModel: TimelineViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttributes()
        setupLayout()
        setupDataSource()
        setupCompositionalLayout()
        setupSnapshot()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        viewModel.sendAction(.viewWillAppear)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.sendAction(.enterToTimeline)
    }
    
    // MARK: - Functions
    
    @objc func showMapView() {
        let mapVC = TimelineMapVC()
        mapVC.setMarker(
            by: viewModel.currentState.timelineCardList,
            day: viewModel.currentState.day
        )
        
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
    private func setNavigationRightButton(isOwner: Bool) {
        var menuItems: [UIAction] = []
        
        if isOwner {
            menuItems = [
                .init(title: Literal.Action.modify, handler: { [weak self] _ in
                    self?.viewModel.sendAction(.editTravel)
                }),
                .init(title: Literal.Action.delete, attributes: .destructive, handler: {  [weak self] _ in
                    self?.viewModel.sendAction(.deleteTravel)
                })
            ]
        } else {
            menuItems = [
                .init(title: Literal.Action.report, attributes: .destructive, handler: { [weak self] _ in
                    self?.viewModel.sendAction(.reportTravel)
                })
            ]
        }
        
        tlNavigationBar.addRightButton(
            image: TLImage.Travel.more,
            menu: .init(children: menuItems)
        )
    }
}

// MARK: - Setup Functions

private extension TimelineVC {
    func setupAttributes() {
        view.backgroundColor = TLColor.black
        timelineCollectionView.backgroundView = emptyView
        timelineCollectionView.backgroundView?.isHidden = true
    }
    
    func setupLayout() {
        view.addSubviews(
            tlNavigationBar,
            timelineCollectionView,
            createPostingButton
        )
        
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            tlNavigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tlNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tlNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tlNavigationBar.heightAnchor.constraint(equalToConstant: BaseMetric.tlheight),
            
            timelineCollectionView.topAnchor.constraint(equalTo: tlNavigationBar.bottomAnchor),
            timelineCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            timelineCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            timelineCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            createPostingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metric.FloatingButton.horizontalInset),
            createPostingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Metric.FloatingButton.verticalInset)
        ])
    }
    
    func bind() {
        createPostingButton
            .tapPublisher
            .withUnretained(self)
            .sink { owner, _ in
                owner.viewModel.sendAction(.createPostingButtonPressed)
            }
            .store(in: &cancellables)
        
        viewModel.state
            .map(\.travelInfo)
            .filter { $0 != .empty }
            .removeDuplicates()
            .withUnretained(self)
            .sink { owner, travelInfo in
                owner.setupData(info: travelInfo)
            }
            .store(in: &cancellables)
        
        viewModel.state
            .map(\.timelineCardList)
            .removeDuplicates()
            .withUnretained(self)
            .sink { owner, cardlist in
                owner.setupData(list: cardlist)
            }
            .store(in: &cancellables)
        
        viewModel.state
            .map(\.isOwner)
            .withUnretained(self)
            .sink { owner, isOwner in
                owner.setNavigationRightButton(isOwner: isOwner)
                owner.createPostingButton.isHidden = !isOwner
            }
            .store(in: &cancellables)
        
        viewModel.state
            .compactMap(\.timelineWritingInfo)
            .withUnretained(self)
            .sink { owner, info in
                let timelineWritingVC = VCFactory.makeTimelineWritingVC(
                    id: info.id,
                    date: info.date,
                    day: info.day
                )
                
                timelineWritingVC.delegate = owner
                
                owner.navigationController?.pushViewController(timelineWritingVC, animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.state
            .map(\.isEdit)
            .filter { $0 }
            .withUnretained(self)
            .sink { owner, _ in
                let travelEditVC = VCFactory.makeTravelVC(
                    id: owner.viewModel.id,
                    travelInfo: owner.viewModel.currentState.travelInfo
                )
                owner.navigationController?.pushViewController(travelEditVC, animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.state
            .map(\.isDeleteCompleted)
            .removeDuplicates()
            .dropFirst()
            .withUnretained(self)
            .sink { owner, isSuccess in
                owner.navigationController?.popViewController(animated: true)
                owner.delegate?.viewControllerDidFinishAction(
                    isSuccess: isSuccess,
                    message: isSuccess ? Constants.didFinishDeleteWithSuccess : Constants.didFinishDeleteWithFailure
                )
            }
            .store(in: &cancellables)
        
        viewModel.state
            .map(\.isEmptyList)
            .withUnretained(self)
            .sink { owner, isEmptyList in
                owner.timelineCollectionView.backgroundView?.isHidden = !isEmptyList
            }
            .store(in: &cancellables)
    }
}

// MARK: - CollectionView Setup Functions

extension TimelineVC {
    func setupDataSource() {
        dataSource = DataSource(collectionView: timelineCollectionView) { collectionView, indexPath, itemIdentifier in
            
            let section = TimelineSection(rawValue: indexPath.section)
            
            var item: Any
            switch itemIdentifier {
            case let .travelInfoItem(value):
                item = value
                
            case let .timelineItem(value):
                item = value
            }
            
            switch section {
            case .travelInfo:
                let cell = collectionView.dequeue(cell: TravelInfoCVC.self, for: indexPath)
                cell.setData(from: item as? TimelineTravelInfo ?? .empty)
                cell.delegate = self
                return cell
                
            case .timeline:
                let cell = collectionView.dequeue(cell: TimelineCardCVC.self, for: indexPath)
                cell.setData(by: item as? TimelineCardInfo ?? .empty)
                let lastRow = collectionView.numberOfItems(inSection: indexPath.section) - 1
                if indexPath.row == lastRow { cell.changeToLast() }
                return cell
                
            default:
                return UICollectionViewCell()
            }
        }
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, _, indexPath in
            let header = collectionView.dequeHeader(view: TimelineDateHeaderView.self, for: indexPath)
            header.delegate = self
            
            if let model = self?.dataSource.itemIdentifier(for: [0, 0]),
               case let .travelInfoItem(info) = model {
                header.setData(info: info)
            }
            
            return header
        }
        
        timelineCollectionView.dataSource = dataSource
    }
    
    func setupCompositionalLayout() {
        let layout = UICollectionViewCompositionalLayout { [weak self] section, _ in
            switch section {
            case TimelineSection.travelInfo.rawValue:
                self?.makeTravelInfoSection()
                
            case TimelineSection.timeline.rawValue:
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
    
    func setupSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.travelInfo, .timeline])
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func setupData(info: TimelineTravelInfo) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .travelInfo))
        snapshot.appendItems([.travelInfoItem(info)], toSection: .travelInfo)
        
        dataSource.apply(snapshot, animatingDifferences: false)
        snapshot.reloadSections([.timeline])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func setupData(list: TimelineCardList) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .timeline))
        list.forEach { snapshot.appendItems([.timelineItem($0)], toSection: .timeline) }
        
        dataSource.apply(snapshot)
    }
    
}

// MARK: - UICollectionView Delegate, DataSource

extension TimelineVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 { return }
        
        let timelineDetailVC = VCFactory.makeTimelineDetailVC(with: viewModel.currentState.timelineCardList[indexPath.row].detailId)
        timelineDetailVC.delegate = self
        
        navigationController?.pushViewController(timelineDetailVC, animated: true)
    }
}

// MARK: - TravelInfo Delegate

extension TimelineVC: TravelInfoDelegate {
    func likeChanged() {
        viewModel.sendAction(.likeButtonPressed)
    }
}

// MARK: - TimelineDateHeader Delegate

extension TimelineVC: TimelineDateHeaderDelegate {
    func goToMapView() {
        showMapView()
    }
    
    func changeDay(to day: Int) {
        viewModel.sendAction(.changeDay(day))
    }
}

// MARK: - TimelineWriting, TimelineDetail Delegate

extension TimelineVC: ToastDelegate {
    func viewControllerDidFinishAction(isSuccess: Bool, message: String) {
        showToast(message: message, type: isSuccess ? .success : .failure)
    }
}

@available(iOS 17, *)
#Preview {
    UINavigationController(rootViewController: VCFactory.makeTimelineVC(id: .empty))
}
