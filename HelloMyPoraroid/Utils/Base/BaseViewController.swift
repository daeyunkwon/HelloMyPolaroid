//
//  BaseViewController.swift
//  HelloMyPoraroid
//
//  Created by 권대윤 on 7/22/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        configureLayout()
        configureUI()
    }
    
    func setupNavi() { }
    
    func configureLayout() { }
    
    func configureUI() { view.backgroundColor = Constant.Color.primaryWhite }
}
