//
//  VCFactory.swift
//  traveline
//
//  Created by 김태현 on 11/30/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum VCFactory {
    
    static let network: NetworkType = NetworkManager(urlSession: URLSession.shared)
    
    static func makeAutoLoginVC() -> AutoLoginVC {
        let repository = AuthRepositoryImpl(network: network)
        let useCase = AutoLoginUseCaseImpl(repository: repository)
        let viewModel = AutoLoginViewModel(useCase: useCase)
        return AutoLoginVC(viewModel: viewModel)
    }
    
    static func makeLoginVC() -> LoginVC {
        let repository = AuthRepositoryImpl(network: network)
        let loginUseCase = LoginUseCaseImpl(repository: repository)
        let settingUseCase = SettingUseCaseImpl(repository: repository)
        let viewModel = LoginViewModel(loginUseCase: loginUseCase, settingUseCase: settingUseCase)
        return LoginVC(viewModel: viewModel)
    }
    
    static func makeRootContainerVC() -> RootContainerVC {
        return RootContainerVC()
    }
    
    static func makeTimelineVC(id: TravelID, userID: UserID? = nil) -> TimelineVC {
        let postingRepository = PostingRepositoryImpl(network: network)
        let timelineRepository = TimelineRepositoryImpl(network: network)
        let userRepository = UserRepositoryImpl(network: network)
        let useCase = TimelineUseCaseImpl(
            postingRepository: postingRepository,
            timelineRepository: timelineRepository,
            userRepository: userRepository
        )
        let viewModel = TimelineViewModel(
            id: id,
            userID: userID,
            fetchTravelInfoUseCase: useCase
        )
        return TimelineVC(viewModel: viewModel)
    }
    
    static func makeHomeVC() -> HomeVC {
        let repository = PostingRepositoryImpl(network: network)
        let useCase = HomeUseCaseImpl(repository: repository)
        let viewModel = HomeViewModel(homeUseCase: useCase)
        return HomeVC(viewModel: viewModel)
    }
    
    static func makeTimelineDetailVC(with id: String) -> TimelineDetailVC {
        let repository = TimelineDetailRepositoryImpl(network: network)
        let useCase = TimelineDetailUseCaseImpl(repository: repository)
        let viewModel = TimelineDetailViewModel(timelineDetailUseCase: useCase, timelineId: id)
        return TimelineDetailVC(viewModel: viewModel)
    }
    
    static func makeMyPostListVC() -> MyPostListVC {
        let repository = PostingRepositoryImpl(network: network)
        let useCase = MyPostListUseCaseImpl(repository: repository)
        let viewModel = MyPostListViewModel(myPostListUseCase: useCase)
        return MyPostListVC(viewModel: viewModel)
    }
    
    static func makeTravelVC(
        id: TravelID? = nil,
        travelInfo: TimelineTravelInfo? = nil
    ) -> TravelVC {
        let repository = PostingRepositoryImpl(network: network)
        let useCase = TravelUseCaseImpl(repository: repository)
        let viewModel = TravelViewModel(
            id: id,
            travelInfo: travelInfo,
            travelUseCase: useCase
        )
        return TravelVC(viewModel: viewModel)
    }
    
    static func makeTimelineWritingVC(
        id: TravelID,
        date: String,
        day: Int,
        timelineDetailInfo: TimelineDetailInfo? = nil
    ) -> TimelineWritingVC {
        let repository = TimelineDetailRepositoryImpl(network: network)
        let useCase = TimelineWritingUseCaseImpl(repository: repository)
        let viewModel = TimelineWritingViewModel(
            useCase: useCase,
            id: id,
            date: date,
            day: day,
            timelineDetailInfo: timelineDetailInfo
        )
        return TimelineWritingVC(viewModel: viewModel)
    }
    
    static func makeSideMenuVC() -> SideMenuVC {
        let repository = UserRepositoryImpl(network: network)
        let useCase = SideMenuUseCaseImpl(repository: repository)
        let viewModel = SideMenuViewModel(useCase: useCase)
        return SideMenuVC(viewModel: viewModel)
    }
    
    static func makeSettingVC() -> SettingVC {
        let repository = AuthRepositoryImpl(network: network)
        let useCase = SettingUseCaseImpl(repository: repository)
        let viewModel = SettingViewModel(useCase: useCase)
        return SettingVC(viewModel: viewModel)
    }
    
    static func makeProfileEditingVC() -> ProfileEditingVC {
        let repository = UserRepositoryImpl(network: network)
        let useCase = ProfileEditingUseCaseImpl(repository: repository)
        let viewModel = ProfileEditingViewModel(useCase: useCase)
        return ProfileEditingVC(viewModel: viewModel)
    }
    
}
