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
    
    var errorDescription: String {
        switch self {
        case .failedToCreateURL:
            return "Error: 유효하지 않은 주소로 인해 URL 생성 실패하였습니다."
        case .requestFailed(let statusCode):
            return "Error: 네트워크 요청 실패 | 상태코드: \(statusCode)"
        }
    }
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

