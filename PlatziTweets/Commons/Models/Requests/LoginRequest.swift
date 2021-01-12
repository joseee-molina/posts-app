//
//  LoginRequest.swift
//  PlatziTweets
//
//  Created by Jose Octavio on 15/08/20.
//  Copyright © 2020 Jose Octavio. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}
