//
//  ViewController.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 12/1/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import UIKit
import AVFoundation

import SwiftIconFont

class MainTabBarController: UITabBarController {
    
    let player = Player.shared
    
    let songsVC = SongsViewController()
    let searchVC = SearchViewController()
    let playlistsVC = PlaylistsViewController()
    
    let nowPlayingView = MPNowPlayingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [self.nowPlayingView].forEach { self.view.addSubview($0) }
        
        self.player.setRemoteTransportControls()
        self.setAnchors()
        self.setDelegates()
        self.setTabs()
    }
    
    private func setTabs() {
        songsVC.tabBarItem = UITabBarItem(title: "Songs", image: UIImage(from: .ionicon, code: "ios-musical-notes", textColor: .blue, backgroundColor: .clear, size: CGSize(width: 90, height: 30)), tag: 0)
        
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        
        playlistsVC.tabBarItem = UITabBarItem(title: "Playlists", image: UIImage(from: .ionicon, code: "ios-list", textColor: .blue, backgroundColor: .clear, size: CGSize(width: 90, height: 30)), tag: 0)
        
        self.viewControllers = [songsVC, searchVC, playlistsVC]
    }
    
    private func setAnchors() {
        self.nowPlayingView.anchor(top: nil, right: self.view.safeAreaRightAnchor(), bottom: self.tabBar.topAnchor, left: self.view.safeAreaLeftAnchor(), size: CGSize(width: 0, height: 60))
    }
    
    private func setDelegates() {
        self.player.delegate = self
    }
}

extension MainTabBarController: PlayerDelegate {
    func player(_ player: Player, didPlay song: Song?) {
        if let playingSong = song {
            self.nowPlayingView.configure(with: playingSong)
        }
    }
    
    func player(_ player: Player, didPause song: Song?) {
        self.nowPlayingView.pause()
    }
    
    func player(_ player: Player, didAdvanceToNext song: Song?) {
        if let playingSong = song {
            self.nowPlayingView.configure(with: playingSong)
        }
    }
    
    func player(_ player: Player, timeElapsed time: CMTime) {
        let seconds = CMTimeGetSeconds(time)
        self.nowPlayingView.playbackSlider.value = Float(seconds)
    }
}
