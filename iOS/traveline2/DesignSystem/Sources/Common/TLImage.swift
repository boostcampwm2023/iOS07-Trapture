//
//  TLImage.swift
//  traveline
//
//  Created by 김태현 on 2023/11/16.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum TLImage {
    
    enum Tag {
        static let close = TravelineAsset.Images.close.image
    }
    
    enum Filter {
        static let total = TravelineAsset.Images.totalFilter.image
        static let totalSelected = TravelineAsset.Images.totalFilterSelected.image
        static let down = TravelineAsset.Images.downArrow.image
        static let downSelected = TravelineAsset.Images.downArrowSelected.image
    }
    
    enum Common {
        static let like = TravelineAsset.Images.likeUnselected.image
        static let likeSelected = TravelineAsset.Images.likeSelected.image
        static let camera = TravelineAsset.Images.camera.image
        static let album = TravelineAsset.Images.album.image
        static let back = TravelineAsset.Images.back.image
        static let plus = TravelineAsset.Images.plus.image
        static let closeBlack = TravelineAsset.Images.closeBlack.image
        static let search = TravelineAsset.Images.search.image
        static let close = TravelineAsset.Images.closeMedium.image
        static let logo = TravelineAsset.Images.travelineLogo.image
        static let`default` = TravelineAsset.Images.default.image
        static let empty = TravelineAsset.Images.empty.image
        static let errorCircle = TravelineAsset.Images.errorCircle.image
    }
    
    enum Travel {
        static let location = TravelineAsset.Images.location.image
        static let locationDisable = TravelineAsset.Images.locationDisabled.image
        static let time = TravelineAsset.Images.time.image
        static let map = TravelineAsset.Images.map.image
        static let more = TravelineAsset.Images.more.image
        static let marker = TravelineAsset.Images.markerUnselected.image
        static let markerSelected = TravelineAsset.Images.markerSelected.image
    }
    
    enum Home {
        static let menu = TravelineAsset.Images.menu.image
    }
    
    enum ToastIcon {
        static let success = TravelineAsset.Images.greenFace
        static let warning = TravelineAsset.Images.yellowFace
        static let failure = TravelineAsset.Images.redFace
    }
    
}
