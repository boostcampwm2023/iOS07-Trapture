//
//  AuthRepository.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/05.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

protocol AuthRepository {
    func withdrawal() async throws
    func logout()
}