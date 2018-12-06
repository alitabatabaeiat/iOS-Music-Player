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
    
    var songs = [Song]()
    var player: AVQueuePlayer!
    var currentSong: Song?
    
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
        button.titleLabel?.font = UIFont.raleWayBold
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
        button.titleLabel?.font = UIFont.raleWayBold
        button.titleLabel?.font.withSize(20)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        [self.tableView, self.nowPlayingView, self.headerView, self.buttonContainer, self.playButton, self.shuffleButton].forEach { view.addSubview($0) }
        
        self.setAnchors()
        self.setTargets()
        self.setDelegates()
        self.setPlayer()
        self.tableView.register(MPTableViewCell.self, forCellReuseIdentifier: self.CELL_ID)
    }
    
    func setAnchors () {
        self.headerView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, right: self.view.safeAreaLayoutGuide.rightAnchor, bottom: nil, left: self.view.safeAreaLayoutGuide.leftAnchor, size: CGSize(width: 0, height: 50))

        self.buttonContainer.anchor(top: self.headerView.bottomAnchor, right: self.view.safeAreaLayoutGuide.rightAnchor, bottom: nil, left: self.view.safeAreaLayoutGuide.leftAnchor, size: CGSize(width: 0, height: 60))
        
        self.tableView.anchor(top: self.buttonContainer.bottomAnchor, right: self.view.safeAreaLayoutGuide.rightAnchor, bottom: self.nowPlayingView.topAnchor, left: self.view.safeAreaLayoutGuide.leftAnchor)
        
        self.nowPlayingView.anchor(top: nil, right: self.view.safeAreaLayoutGuide.rightAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, left: self.view.safeAreaLayoutGuide.leftAnchor, size: CGSize(width: 0, height: 60))
        
        self.playButton.centerYAnchor.constraint(equalTo: self.buttonContainer.centerYAnchor).isActive = true
        self.playButton.anchor(top: nil, right: self.buttonContainer.centerXAnchor, bottom: nil, left: self.buttonContainer.leftAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 40))
        
        self.shuffleButton.centerYAnchor.constraint(equalTo: self.buttonContainer.centerYAnchor).isActive = true
        self.shuffleButton.anchor(top: nil, right: self.buttonContainer.rightAnchor, bottom: nil, left: self.buttonContainer.centerXAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 40))
    }
    
    private func setTargets() {
        self.playButton.addTarget(self, action: #selector(self.playButtonPressed), for: .touchUpInside)
        self.shuffleButton.addTarget(self, action: #selector(self.shuffleButtonPressed), for: .touchUpInside)
    }
    
    private func setDelegates() {
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
            if self.currentSong !== song  {
                if let currentSong = self.currentSong {
                    currentSong.playerItem.seek(to: .zero, completionHandler: nil)
                }
                self.currentSong = song
                self.setNewQueue(with: song)
                self.pauseSong()
            }
            
            if !self.playSong() {
                self.pauseSong()
            }
            
            setAudioSession()
        }
    }
}

extension SongsViewController: MPNowPlayingViewDelegate {
    func play() {
        self.playSong()
    }
    
    func pause() {
        self.pauseSong()
    }
    
    func next() {
        self.nextSong()
    }
}

extension SongsViewController {
    
    private func setPlayer() {
        self.player = AVQueuePlayer(playerItem: nil)
        self.setRemoteTransportControls()
    }
    
    @objc private func playButtonPressed() {
        if let song = self.songs.first {
            self.setNewQueue(with: song)
        }
    }
    
    @objc private func shuffleButtonPressed() {
        let shuffledSongs = self.songs.shuffled()
        player.removeAllItems()
        
        if let song = shuffledSongs.first, self.player.canInsert(song.playerItem, after: nil) {
            self.player.insert(song.playerItem, after: nil)
        }
        
        for i in 1 ..< shuffledSongs.count {
            let song = shuffledSongs[i]
            if self.player.canInsert(song.playerItem, after: self.player.items().last) {
                self.player.insert(song.playerItem, after: self.player.items().last)
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let keyPath = keyPath {
            if keyPath == #keyPath(AVQueuePlayer.currentItem) {
                if let oldItem = change?[NSKeyValueChangeKey.oldKey] as? AVPlayerItem {
                    oldItem.seek(to: .zero, completionHandler: nil)
                }
                if let newItem = change?[NSKeyValueChangeKey.newKey] as? AVPlayerItem {
                    self.changeCurrentSong(with: newItem)
                    self.pauseSong()
                    self.playSong()
                }
            }
        }
    }
    
    private func setNewQueue(with song: Song) {
        self.player.removeAllItems()
        
        self.player.addObserver(self, forKeyPath: #keyPath(AVQueuePlayer.currentItem), options: [.new, .old], context: nil)
        if self.player.canInsert(song.playerItem, after: nil) {
            self.player.insert(song.playerItem, after: nil)
            
            let songIndex = self.songs.firstIndex { $0 === song }
            
            if let songIndex = songIndex {
                for i in 1 ..< self.songs.count {
                    let current = (i + songIndex) % self.songs.count
                    
                    if self.player.canInsert(self.songs[current].playerItem, after: self.player.items().last) {
                        self.player.insert(self.songs[current].playerItem, after: self.player.items().last)
                    }
                }
            }
        }
    }
    
    @discardableResult
    private func playSong() -> Bool {
        if self.player.rate == 0, let song = self.currentSong {
            self.player.play()
            self.setNowPlayingInfo()
            self.nowPlayingView.configure(with: song)
            
            return true
        }
        return false
    }
    
    @discardableResult
    private func pauseSong() -> Bool {
        if self.player.rate == 1 {
            self.player.pause()
            self.nowPlayingView.pause()
            
            return true
        }
        return false
    }
    
    @discardableResult
    private func nextSong() -> Bool {
        if self.currentSong != nil {
            self.player.currentItem?.seek(to: .zero, completionHandler: nil)
            self.player.advanceToNextItem()
            self.changeCurrentSong(with: self.player.currentItem)
            self.setNowPlayingInfo()
            if let currentSong = self.currentSong {
                self.nowPlayingView.configure(with: currentSong)
            }
            return true
        }
        return false
    }
    
    private func changeCurrentSong(with newPlayerItem: AVPlayerItem?) {
        self.currentSong = self.songs.first { $0.playerItem === newPlayerItem }
    }
    
    private func setRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Add handler for Play Command
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.playSong() {
                return .success
            }
            return .commandFailed
        }
        
        // Add handler for Pause Command
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.pauseSong() {
                return .success
            }
            return .commandFailed
        }
        
        // Add handler for Next Track Command
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget { [unowned self] event in
            if self.nextSong() {
                return .success
            }
            return .commandFailed
        }
    }
    
    private func setNowPlayingInfo() {
        
        guard let song = self.currentSong, let playerItem = song.playerItem else { return }
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = song.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = song.artist
        if let image = song.artwork {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
            }
        }
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playerItem.currentTime().seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = playerItem.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.player.rate
        
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func setAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .allowAirPlay)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let ex {
            print(ex.localizedDescription)
        }
    }
}
