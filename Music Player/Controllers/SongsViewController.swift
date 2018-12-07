//
//  SongsViewController.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 12/1/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class SongsViewController: UIViewController {
    
    var songs = [Song]() {
        didSet {
            self.player.songs = self.songs
        }
    }
    var player: Player!
    
    let CELL_ID = "cell_id"
    let tableView = MPTableView()
    let nowPlayingView = MPNowPlayingView()
    let headerView = MPHeaderView(titleText: "SONGS")
    let buttonContainer = MPView()
    let playButton: MPButton = {
        let button = MPButton()
        button.setImage(UIImage(from: .ionicon, code: "ios-play", textColor: .blue1, size: CGSize(width: 30, height: 30)), for: .normal)
        button.setTitle("play", for: .normal)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.backgroundColor = .grey2
        button.setTitleColor(.blue1, for: .normal)
        button.titleLabel?.font = UIFont.ralewayBold
        button.titleLabel?.font.withSize(20)
        
        return button
    }()
    let shuffleButton: MPButton = {
        let button = MPButton()
        button.setImage(UIImage(from: .ionicon, code: "ios-shuffle", textColor: .blue1, size: CGSize(width: 30, height: 30)), for: .normal)
        button.setTitle("shuffle", for: .normal)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.backgroundColor = .grey2
        button.setTitleColor(.blue1, for: .normal)
        button.titleLabel?.font = UIFont.ralewayBold
        button.titleLabel?.font.withSize(20)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        [self.tableView, self.nowPlayingView, self.headerView, self.buttonContainer, self.playButton, self.shuffleButton].forEach { view.addSubview($0) }
        
        self.setAnchors()
        self.setTargets()
        self.setPlayer()
        self.setDelegates()
        self.tableView.register(MPTableViewCell.self, forCellReuseIdentifier: self.CELL_ID)
        print("songsCtrl")
    }
    
    func setAnchors () {
        if #available(iOS 11.0, *) {
            self.headerView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, right: self.view.safeAreaLayoutGuide.rightAnchor, bottom: nil, left: self.view.safeAreaLayoutGuide.leftAnchor, size: CGSize(width: 0, height: 50))
        } else {
            self.headerView.anchor(top: self.view.topAnchor, right: self.view.rightAnchor, bottom: nil, left: self.view.leftAnchor, size: CGSize(width: 0, height: 50))
        }

        if #available(iOS 11.0, *) {
            self.buttonContainer.anchor(top: self.headerView.bottomAnchor, right: self.view.safeAreaLayoutGuide.rightAnchor, bottom: nil, left: self.view.safeAreaLayoutGuide.leftAnchor, size: CGSize(width: 0, height: 60))
        } else {
            self.buttonContainer.anchor(top: self.headerView.bottomAnchor, right: self.view.rightAnchor, bottom: nil, left: self.view.leftAnchor, size: CGSize(width: 0, height: 60))
        }
        
        if #available(iOS 11.0, *) {
            self.tableView.anchor(top: self.buttonContainer.bottomAnchor, right: self.view.safeAreaLayoutGuide.rightAnchor, bottom: self.nowPlayingView.topAnchor, left: self.view.safeAreaLayoutGuide.leftAnchor)
        } else {
            self.tableView.anchor(top: self.buttonContainer.bottomAnchor, right: self.view.rightAnchor, bottom: self.nowPlayingView.topAnchor, left: self.view.leftAnchor)
        }
        
        if #available(iOS 11.0, *) {
            self.nowPlayingView.anchor(top: nil, right: self.view.safeAreaLayoutGuide.rightAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, left: self.view.safeAreaLayoutGuide.leftAnchor, size: CGSize(width: 0, height: 60))
        } else {
            self.nowPlayingView.anchor(top: nil, right: self.view.rightAnchor, bottom: self.view.bottomAnchor, left: self.view.leftAnchor, size: CGSize(width: 0, height: 60))
        }
        
        if #available(iOS 11.0, *) {
            self.nowPlayingView.anchor(top: nil, right: self.view.safeAreaLayoutGuide.rightAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, left: self.view.safeAreaLayoutGuide.leftAnchor, size: CGSize(width: 0, height: 60))
        } else {
            self.nowPlayingView.anchor(top: nil, right: self.view.rightAnchor, bottom: self.view.bottomAnchor, left: self.view.leftAnchor, size: CGSize(width: 0, height: 60))
        }
        
        self.playButton.centerYAnchor.constraint(equalTo: self.buttonContainer.centerYAnchor).isActive = true
        self.playButton.anchor(top: nil, right: self.buttonContainer.centerXAnchor, bottom: nil, left: self.buttonContainer.leftAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 40))
        
        self.shuffleButton.centerYAnchor.constraint(equalTo: self.buttonContainer.centerYAnchor).isActive = true
        self.shuffleButton.anchor(top: nil, right: self.buttonContainer.rightAnchor, bottom: nil, left: self.buttonContainer.centerXAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 40))
    }
    
    private func setTargets() {
        self.playButton.addTarget(self, action: #selector(self.playButtonPressed), for: .touchUpInside)
        self.shuffleButton.addTarget(self, action: #selector(self.shuffleButtonPressed), for: .touchUpInside)
    }
    
    private func setPlayer() {
        self.player = Player(songs: self.songs)
        self.player.setRemoteTransportControls()
    }
    
    private func setDelegates() {
        self.player.delegate = self
        self.nowPlayingView.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

extension SongsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CELL_ID, for: indexPath) as! MPTableViewCell
        cell.song = self.songs[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MPTableViewCell, let song = cell.song {
            if !self.player.isPlaying(song: song)  {
                self.player.setNewQueue(with: .all, startingFrom: song)
                self.player.play()
            } else {
                
            }
        }
    }
}

extension SongsViewController: MPNowPlayingViewDelegate, PlayerDelegate {
    
    func play(in nowPlayingView: MPNowPlayingView) {
        self.player.play()
    }
    
    func pause(in nowPlayingView: MPNowPlayingView) {
        self.player.pause()
    }
    
    func next(in nowPlayingView: MPNowPlayingView) {
        self.player.next()
    }
    
    func previous(in nowPlayingView: MPNowPlayingView) {
        self.player.previous()
    }
    
    
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
}

extension SongsViewController {
    
    @objc private func playButtonPressed() {
        if let song = self.songs.first {
            self.player.setNewQueue(with: .all, startingFrom: song)
            self.player.play()
        }
    }
    
    @objc private func shuffleButtonPressed() {
        self.player.setNewQueue(with: .shuffled, startingFrom: nil)
        self.player.play()
    }
}
