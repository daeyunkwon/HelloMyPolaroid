//
//  LikedPhotoRepository.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/27/24.
//

import Foundation

import RealmSwift

class LikedPhotoRepository {
    
    //MARK: - Properties
    
    enum RealmError: Error {
        case failedToCreate
        case failedToDelete
        case failedToAllDelete
        
        var description: String {
            switch self {
            case .failedToCreate:
                return "Error: Realm에 LikedPhoto 데이터 생성 실패되었습니다."
            case .failedToDelete:
                return "Error: Realm에 LikedPhoto 데이터 삭제 실패되었습니다."
            case .failedToAllDelete:
                return "Error: Realm에 모든 데이터 삭제 실패되었습니다."
            }
        }
    }
    
    private let realm = try! Realm()
    
    //MARK: - Methods
    
    func create(data: LikedPhoto, completionHandler: @escaping (Result<LikedPhoto, RealmError>) -> Void) {
        do {
            try realm.write {
                realm.add(data)
                print("Realm Create Succeed")
                completionHandler(.success(data))
            }
        } catch {
            print(error)
            completionHandler(.failure(.failedToCreate))
        }
    }
    
    func fetchAllItemSorted(key: LikedPhoto.Key, ascending: Bool) -> Results<LikedPhoto> {
        return realm.objects(LikedPhoto.self).sorted(byKeyPath: key.rawValue, ascending: ascending)
    }
    
    func deleteItem(data: LikedPhoto, completionHandler: @escaping (Result<String, RealmError>) -> Void) {
        do {
            try realm.write {
                ImageFileManager.shared.removeImageFromDocument(filename: data.photoID)
                realm.delete(data)
                completionHandler(.success("Realm Delete Succeed"))
            }
        } catch {
            print(error)
            completionHandler(.failure(.failedToDelete))
        }
    }
    
    func deleteAllItem(completionHandler: @escaping (Result<String, RealmError>) -> Void) {
        do {
            try realm.write {
                realm.deleteAll()
                completionHandler(.success("Realm All Data Delete Succeed"))
            }
        } catch {
            print(error)
            completionHandler(.failure(.failedToAllDelete))
        }
    }
    
}

