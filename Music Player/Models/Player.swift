//
//  Player.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 12/6/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

class Player: NSObject {
    static let shared = Player()
    
    var delegate: PlayerDelegate?
    private var player: AVQueuePlayer
    private var songs: [Song]
    private var currentSong: Song? {
        get {
            return self.songs.first { $0.playerItem === self.player.currentItem }
        }
    }
    
    private var playlists: [Playlist]
    
    override init() {
        self.player = AVQueuePlayer()
        self.songs = [Song]()
        self.playlists = Defaults.getPlaylists()
        print(self.playlists.count)
        super.init()
        
        self.player.addObserver(self, forKeyPath: #keyPath(AVQueuePlayer.currentItem), options: [.new, .old], context: nil)
        self.player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(0.01, preferredTimescale: 100), queue: DispatchQueue.main) { time in
            if let delegate = self.delegate {
                delegate.player(self, timeElapsed: time)
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.audioSessionInterruptionHandler), name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    func add(mulitpleSongs songs: [Song]) {
        self.songs = songs
        if let sortBy = Defaults.getSortBy() {
            self.sortSongs(by: sortBy)
        }
    }
    
    func getSongs() -> [Song] {
        return self.songs
    }
    
    func getSong(at index: Int) -> Song {
        return self.songs[index]
    }

    func getSong(withTitle title: String) -> Song? {
        return self.songs.first { $0.title == title }
    }
    
    func setPlaylists(_ playlists: [Playlist]) {
        self.playlists = playlists
    }
    
    func getPlaylists() -> [Playlist] {
        return self.playlists
    }
    
    func getPlaylist(at index: Int) -> Playlist {
        return self.playlists[index]
    }

    func sortSongs(by sort: Sort) {
        switch sort {
            case .ByTitle:
                self.songs.sort { $0.title < $1.title }
                break
            case .ByArtist:
                self.songs.sort {
                    if $0.artist.isEmpty {
                        return false
                    }
                    if $1.artist.isEmpty {
                        return true
                    }
                    return $0.artist < $1.artist
                }
                break
            case .ByRecentlyAdded:
                // TODO: implement after core data modeled
                break
        }
        
        Defaults.set(sortBy: sort)
    }
    
    func setNewQueue(with queueOption: Queue, startingFrom song: Song?) {
        self.seek(to: .zero)
        self.player.removeAllItems()
        
        if self.songs.count == 0 { return }
        
        var startingSong: Song
        var songs = [Song]()
        
        switch queueOption {
            case .default:
                songs = self.songs
                if let song = song {
                    startingSong = song
                } else {
                    startingSong = songs[0]
                }
            case .shuffle:
                songs = self.songs.shuffled()
                startingSong = songs[0]
        }
        self.insertMany(from: songs, startingFrom: startingSong)
    }
    
    func setNewQueue(with songs: [Song], startingFrom song: Song) {
        self.seek(to: .zero)
        self.player.removeAllItems()
        
        if songs.count == 0 { return }
        
        self.insertMany(from: songs, startingFrom: song)
    }
    
    func insertMany(from songs: [Song], startingFrom song: Song) {
        if self.player.canInsert(song.playerItem, after: nil) {
            self.player.insert(song.playerItem, after: nil)
            
            let songIndex = songs.firstIndex { $0 === song }
            if let songIndex = songIndex {
                for i in 1 ..< songs.count {
                    let current = (i + songIndex) % songs.count
                    self.insert(songs[current].playerItem, afterIndex: self.player.items().count - 1)
                }
            }
        }
    }
    
    func insertMany(from playerItems: [AVPlayerItem], startingFrom playerItem: AVPlayerItem) {
        if self.player.canInsert(playerItem, after: nil) {
            self.player.insert(playerItem, after: nil)
            
            let playerItemIndex = playerItems.firstIndex { $0 === playerItem }
            if let playerItemIndex = playerItemIndex {
                for i in 1 ..< playerItems.count {
                    let current = (i + playerItemIndex) % playerItems.count
                    self.insert(playerItems[current], afterIndex: self.player.items().count - 1)
                }
            }
        }
    }
    
    func play() {
        if self.player.rate == 0 {
            self.player.play()
            self.setAudioSession()
        }
        self.setNowPlayingInfo()
        if let delegate = self.delegate {
            delegate.player(self, didPlay: self.currentSong)
        }
    }
    
    func pause() {
        if self.player.rate == 1 {
            self.player.pause()
        }
        self.setNowPlayingInfo()
        if let delegate = self.delegate {
            delegate.player(self, didPause: self.currentSong)
        }
    }
    
    func next() {
        if let previousSong = self.currentSong {
            self.player.currentItem?.seek(to: .zero, completionHandler: nil)
            self.player.advanceToNextItem()
            self.insert(previousSong.playerItem, afterIndex: self.player.items().count - 1)
        }
        self.setNowPlayingInfo()
        if let delegate = self.delegate {
            delegate.player(self, didAdvanceToNext: self.currentSong)
        }
    }
    
    func previous() {
        if self.currentSong != nil {
            self.pause()
            self.player.currentItem?.seek(to: .zero, completionHandler: nil)
            var playerItems = self.player.items()
            if playerItems.count > 1 {
                self.player.removeAllItems()
                playerItems = [playerItems.popLast()!] + playerItems
                self.insertMany(from: playerItems, startingFrom: playerItems.first!)
            }
            self.play()
        }
    }
    
    func seek(to time: CMTime) {
        if let currentSong = self.currentSong {
            currentSong.playerItem.seek(to: time) { (_) in
                self.setNowPlayingInfo()
            }
        }
    }
    
    func isPlaying(song: Song?) -> Bool {
        if song != nil {
            return self.currentSong === song && self.player.rate > 0
        }
        return self.player.rate > 0
    }
    
    func insert(_ item: AVPlayerItem, afterIndex index: Int?) {
        var afterItem: AVPlayerItem? = nil
        if let index = index {
            if self.player.items().count == 0 { return }
            afterItem = self.player.items()[index]
        }
        if self.player.canInsert(item, after: afterItem) {
            self.player.insert(item, after: afterItem)
        }
    }
    
    func removeSong(at index: Int) {
        if let delegate = self.delegate {
            delegate.player(self, willRemoveSong: self.songs[index])
        }
        self.songs.remove(at: index)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let keyPath = keyPath {
            if keyPath == #keyPath(AVQueuePlayer.currentItem) {
                if let oldItem = change?[NSKeyValueChangeKey.oldKey] as? AVPlayerItem {
                    oldItem.seek(to: .zero, completionHandler: nil)
                    self.insert(oldItem, afterIndex: self.player.items().count - 1)
                }
                if (change?[NSKeyValueChangeKey.newKey] as? AVPlayerItem) != nil {
                    self.setNowPlayingInfo()
                    if let delegate = self.delegate {
                        delegate.player(self, didPlay: self.currentSong)
                    }
                }
            }
        }
    }
    
    func setRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Add handler for Play Command
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { event in
            self.play()
            return .success
        }
        
        // Add handler for Pause Command
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { event in
            self.pause()
            return .success
        }
        
        // Add handler for Next Track Command
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget { event in
            self.next()
            return .success
        }
        
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget { event in
            self.previous()
            return .success
        }
        
        commandCenter.changePlaybackPositionCommand.isEnabled = true
        commandCenter.changePlaybackPositionCommand.addTarget { event in
            let event = event as! MPChangePlaybackPositionCommandEvent
            let time = CMTime(seconds: event.positionTime, preferredTimescale: 1)
            self.seek(to: time)
            return .success
        }
        
//        commandCenter.changeShuffleModeCommand.isEnabled = true
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
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: .allowAirPlay)
            try audioSession.setActive(true)
        } catch let ex {
            print(ex.localizedDescription)
        }
    }
    
    @objc private func audioSessionInterruptionHandler(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                return
        }
        
        if type == .began {
           self.pause()
        }
        else if type == .ended {
            guard let optionsValue =
                userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else {
                    return
            }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume) {
                self.play()
            }
        }
    }
}
