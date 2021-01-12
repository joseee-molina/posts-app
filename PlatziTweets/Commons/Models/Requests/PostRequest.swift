//
//  PostRequest.swift
//  PlatziTweets
//
//  Created by Jose Octavio on 15/08/20.
//  Copyright © 2020 Jose Octavio. All rights reserved.
//

import Foundation

struct PostRequest: Codable {
    let text: String
    let imageUrl: String?
    let videoUrl: String?
    let location: PostRequestLocation?
}
