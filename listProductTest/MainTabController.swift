//
//  MainTabController.swift
//  listProductTest
//
//  Created by Кирилл Харьковский on 23.08.2021.
//

import Foundation
import UIKit
class MainTabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }
    
    
    private func configureViewControllers() {
        UIView.appearance().isExclusiveTouch = true
        
        let productList = templateNavigationController(selectedImage: UIImage(systemName: "house")!, rootViewController: MainTableViewController())
        productList.title = "Главная"
        
       
        let favourite = templateNavigationController(selectedImage: UIImage(systemName: "archivebox")!, rootViewController: FavouriteTableViewController())
        favourite.title = "Избранное"
        
        viewControllers = [productList, favourite]
        
    }
    
    private func templateNavigationController(selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = selectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        return nav
    }
    
    
}
