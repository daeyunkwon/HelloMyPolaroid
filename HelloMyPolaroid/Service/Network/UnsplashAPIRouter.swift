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
    
    
    var endpoint: URL? {
        switch self {
        case .topics(let topicID):
            let url = URL(string: APIURL.baseURL + "topics/\(topicID)/photos")
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
        }
    }
}
