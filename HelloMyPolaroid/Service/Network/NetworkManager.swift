//
//  NetworkManager.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/24/24.
//

import UIKit

import Alamofire

enum UnsplashNetworkError: Error {
    case failedToCreateURL
    case requestFailed(statusCode: Int)
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func fetchData<T: Decodable>(api: UnsplashAPIRouter, model: T.Type, completionHandler: @escaping (Result<T, UnsplashNetworkError>) -> Void) {
        guard let url = api.endpoint else {
            completionHandler(.failure(.failedToCreateURL))
            return
        }
        
        AF.request(url, method: .get, parameters: api.parameter, encoding: URLEncoding.queryString).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completionHandler(.success(data))
            
            case .failure(let error):
                print(error)
                completionHandler(.failure(.requestFailed(statusCode: response.response?.statusCode ?? 0)))
            }
        }
    }
    
}

