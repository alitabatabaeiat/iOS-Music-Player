//
//  ViewController.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 12/1/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import UIKit
import SwiftIconFont

class MainTabBarController: UITabBarController {
    
    let songsVC = SongsViewController()
    let searchVC = SearchViewController()
    let playlistsVC = PlaylistsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        songsVC.tabBarItem = UITabBarItem(title: "Songs", image: UIImage(from: .ionicon, code: "ios-musical-notes", textColor: .blue, backgroundColor: .clear, size: CGSize(width: 90, height: 30)), tag: 0)
        
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        
        playlistsVC.tabBarItem = UITabBarItem(title: "Playlists", image: UIImage(from: .ionicon, code: "ios-list", textColor: .blue, backgroundColor: .clear, size: CGSize(width: 90, height: 30)), tag: 0)
        
        viewControllers = [songsVC, searchVC, playlistsVC]
    }
    
    
}
