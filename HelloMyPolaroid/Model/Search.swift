//
//  Search.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/26/24.
//

import Foundation

struct Search: Decodable {
    let total: Int
    let totalPage: Int
    let results: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPage = "total_pages"
        case results
    }
}
