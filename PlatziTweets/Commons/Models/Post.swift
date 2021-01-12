//
//  Post.swift
//  PlatziTweets
//
//  Created by Jose Octavio on 15/08/20.
//  Copyright © 2020 Jose Octavio. All rights reserved.
//

import Foundation

struct Post: Codable {
    let id: String
    let author: User
    let imageUrl: String
    let text: String
    let videoUrl: String
    let location: PostLocation
    let hasVideo: Bool
    let hasImage: Bool
    let hasLocation: Bool
    let createdAt: String
}
