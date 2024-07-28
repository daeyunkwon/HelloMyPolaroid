//
//  Photo.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/24/24.
//

import Foundation

struct Photo: Decodable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let urls: Urls
    let likes: Int
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case urls
        case likes
        case user
    }
    
    var userProfileID: String {
        let text = self.id + self.user.name.replacingOccurrences(of: " ", with: "_")
        return text.trimmingCharacters(in: .whitespaces)
    }
}

struct Urls: Decodable {
    let raw: String
    let small: String
}

struct User: Decodable {
    let name: String
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case name
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Decodable {
    let small, medium, large: String
}
