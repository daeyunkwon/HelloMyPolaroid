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
    case random
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
            
        case .random:
            let url = URL(string: APIURL.baseURL + "photos/random")
            return url
        }
    }
    
    var parameter: Parameters {
        switch self {
        case .topics(_):
            return [
                ParameterKey.page.rawValue: "1",
                ParameterKey.client_id.rawValue: APIKey.apiKey
            ]
        
        case .search(let keyword, let page, let order, let color):
            if let safeColor = color {
                return [
                    ParameterKey.page.rawValue: "\(page)",
                    ParameterKey.client_id.rawValue: APIKey.apiKey,
                    ParameterKey.query.rawValue: keyword,
                    ParameterKey.order_by.rawValue: order,
                    ParameterKey.color.rawValue: safeColor,
                    ParameterKey.per_page.rawValue: "20"
                ]
            } else {
                return [
                    ParameterKey.page.rawValue: "\(page)",
                    ParameterKey.client_id.rawValue: APIKey.apiKey,
                    ParameterKey.query.rawValue: keyword,
                    ParameterKey.order_by.rawValue: order,
                    ParameterKey.per_page.rawValue: "20"
                ]
            }
        
        case .statistics(_):
            return [
                ParameterKey.client_id.rawValue: APIKey.apiKey
            ]
            
        case .random:
            return [
                ParameterKey.client_id.rawValue: APIKey.apiKey,
                ParameterKey.count.rawValue: "10"
            ]
        }
    }
    
}
