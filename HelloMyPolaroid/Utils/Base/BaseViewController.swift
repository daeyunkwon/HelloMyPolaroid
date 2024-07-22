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
        bindData()
        setupNavi()
        configureLayout()
        configureUI()
    }
    
    func bindData() { }
    
    func setupNavi() { }
    
    func configureLayout() { }
    
    func configureUI() { view.backgroundColor = Constant.Color.primaryWhite }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func popViewController(_ animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
}
