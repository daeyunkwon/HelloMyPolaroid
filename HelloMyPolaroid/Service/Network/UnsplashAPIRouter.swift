//
//  UnsplashAPIRouter.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/24/24.
//

import Foundation

import Alamofire

enum UnsplashAPIRouter {
    case topics(topicID: String)
    case search(keyword: String, page: Int, order: String, color: String?)
    case statistics(photoID: String)
}

extension UnsplashAPIRouter {
    var endpoint: URL? {
        switch self {
        case .topics(let topicID):
            let url = URL(string: APIURL.baseURL + "topics/\(topicID)/photos")
            return url
            
        case .search(_, _, _, _):
            let url = URL(string: APIURL.baseURL + "search/photos")
            return url
            
        case .statistics(let photoID):
            let url = URL(string: APIURL.baseURL + "photos/\(photoID)/statistics")
            return url
        }
    }
    
    var parameter: Parameters {
        switch self {
        case .topics(_):
            return [
                "page": "1",
                "client_id": APIKey.apiKey
            ]
        
        case .search(let keyword, let page, let order, let color):
            if let safeColor = color {
                return [
                    "page": "\(page)",
                    "client_id": APIKey.apiKey,
                    "query": keyword,
                    "order_by": order,
                    "color": safeColor,
                    "per_page": "20"
                ]
            } else {
                return [
                    "page": "\(page)",
                    "client_id": APIKey.apiKey,
                    "query": keyword,
                    "order_by": order,
                    "per_page": "20"
                ]
            }
        
        case .statistics(_):
            return [
                "client_id": APIKey.apiKey
            ]
        }
    }
    
}
