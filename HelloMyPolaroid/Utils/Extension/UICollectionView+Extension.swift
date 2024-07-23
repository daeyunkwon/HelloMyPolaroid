//
//  UICollectionView+Extension.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/23/24.
//

import UIKit

extension UICollectionView {
    
    static func layoutSquareType(sectionSpacing: CGFloat, minimumInteritemSpacing: CGFloat, minimumLineSpacing: CGFloat, cellCount: CGFloat) -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = sectionSpacing //컬렉션뷰와 셀의 간격
        let cellSpacing: CGFloat = minimumInteritemSpacing //셀과 셀 사이 간격
        let cellCount: CGFloat = cellCount //한 행에 셀 갯수
        let width = UIScreen.main.bounds.width - ((cellSpacing * (cellCount - 1)) + (sectionSpacing * 2))
        layout.itemSize = CGSize(width: width / cellCount, height: width / cellCount)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = minimumLineSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        return layout
    }
    
}
