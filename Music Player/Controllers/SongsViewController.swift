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
    var player: AVPlayer!
    var currentSong: Song?
    
    let CELL_ID = "cell_id"
    let tableView = MPTableView()
    let nowPlayingView = MPNowPlayingView()
    let headerView = MPHeaderView(titleText: "SONGS")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        [self.tableView, self.nowPlayingView, self.headerView].forEach { view.addSubview($0) }
        
        self.setAnchors()
        
        [self.tableView].forEach { $0.delegate = self }
        self.tableView.dataSource = self
        self.tableView.register(MPTableViewCell.self, forCellReuseIdentifier: self.CELL_ID)
    }
    
    func setAnchors () {
        self.headerView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, right: self.view.safeAreaLayoutGuide.rightAnchor, bottom: nil, left: self.view.safeAreaLayoutGuide.leftAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 60))
        
        self.tableView.anchor(top: self.headerView.bottomAnchor, right: self.view.safeAreaLayoutGuide.rightAnchor, bottom: self.nowPlayingView.topAnchor, left: self.view.safeAreaLayoutGuide.leftAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        self.nowPlayingView.anchor(top: nil, right: self.view.safeAreaLayoutGuide.rightAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, left: self.view.safeAreaLayoutGuide.leftAnchor, size: CGSize(width: 0, height: 60))
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
            if self.currentSong == nil {
                self.currentSong = song
                player = AVPlayer(playerItem: song.playerItem)
            } else if let currentSong = self.currentSong, currentSong !== song  {
                currentSong.playerItem.seek(to: .zero, completionHandler: nil)
                self.currentSong = song
                player.replaceCurrentItem(with: song.playerItem)
                self.pauseSong()
            }
            
            if !self.playSong() {
                self.pauseSong()
            }
            
            setAudioSession()
        }
    }
}

extension SongsViewController {
    
    private func playSong() -> Bool {
        print(self.player.rate)
        if self.player.rate == 0, let song = self.currentSong {
            self.player.play()
            self.setNowPlayingInfo()
            self.nowPlayingView.configure(with: song)
            self.setRemoteTransportControls()
            
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
//        MPNowPlayingInfoCenter.default().playbackState = .playing
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
