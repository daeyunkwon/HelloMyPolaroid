//
//  LikedPhoto.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/27/24.
//

import Foundation

import RealmSwift

class LikedPhoto: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var photoID: String
    @Persisted var date: Date
    @Persisted var created: String
    @Persisted var width: Int
    @Persisted var height: Int
    @Persisted var photoImageURLRaw: String
    @Persisted var photoImageURLSmall: String
    @Persisted var userProfileImageURLSmall: String
    @Persisted var userProfileImageURLMedium: String
    @Persisted var userProfileImageURLLarge: String
    @Persisted var username: String
    @Persisted var likeCount: Int
    @Persisted var userProfileID: String
    
    convenience init(photoID: String, created: String, width: Int, height: Int, photoImageURLRaw: String, photoImageURLSmall: String, userProfileImageURLSmall: String, userProfileImageURLMedium: String, userProfileImageURLLarge: String, username: String, likeCount: Int) {
        self.init()
        self.photoID = photoID
        self.date = Date()
        self.created = created
        self.width = width
        self.height = height
        self.photoImageURLRaw = photoImageURLRaw
        self.photoImageURLSmall = photoImageURLSmall
        self.userProfileImageURLSmall = userProfileImageURLSmall
        self.userProfileImageURLMedium = userProfileImageURLMedium
        self.userProfileImageURLLarge = userProfileImageURLLarge
        self.username = username
        self.likeCount = likeCount
        
        let text = photoID + username.replacingOccurrences(of: " ", with: "_")
        self.userProfileID = text.trimmingCharacters(in: .whitespaces)
    }
    
    enum Key: String {
        case photoID
        case date
    }
}
