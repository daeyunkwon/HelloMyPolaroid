//
//  Statistics.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/28/24.
//

import Foundation

struct Statistics: Decodable {
    let id: String
    let downloads: Downloads
    let views: Views
}

struct Downloads: Decodable {
    let total: Int
    let historical: Historical
}

struct Views: Decodable {
    let total: Int
    let historical: Historical
}

struct Historical: Decodable {
    let values: [Values]
}

struct Values: Decodable {
    let date: String
    let value: Int
}
