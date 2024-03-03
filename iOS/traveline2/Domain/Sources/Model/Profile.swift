//
//  Profile.swift
//  traveline
//
//  Created by 김영인 on 2023/11/17.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

struct Profile: Hashable {
    let imageURL: String
    let imagePath: String
    let name: String
    
    static let empty: Profile = .init(
        imageURL: Literal.empty,
        imagePath: Literal.empty,
        name: Literal.empty
    )
}
