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
    
    convenience init(photoID: String) {
        self.init()
        
        self.photoID = photoID
        self.date = Date()
    }
    
    enum Key: String {
        case photoID
        case date
    }
}
