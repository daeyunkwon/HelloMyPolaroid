//
//  PhotoCollectionViewCellDelegate.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/27/24.
//

import Foundation

protocol PhotoCollectionViewCellDelegate: AnyObject {
    func likeButtonTapped(senderCell: PhotoCollectionViewCell)
}
