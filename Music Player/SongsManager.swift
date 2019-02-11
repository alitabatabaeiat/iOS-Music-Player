//
//  SongsManager.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 2/5/19.
//  Copyright © 2019 Ali Tabatabaei. All rights reserved.
//

import UIKit
import AVFoundation

class SongsManager {
    
    public static let shared = SongsManager(path: "group.ir.alitabatabaei.Music-Player", sharedPath: "sharedSongs")
    
    private let fileManager = FileManager.default
    private let container: URL?
    private let sharedPath: String
    
    init(path: String, sharedPath: String) {
        self.container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: path)
        self.sharedPath = sharedPath
    }
    
    public func createDirectoryIfNeeded() {
        if let container = self.container {
            let dir = container.appendingPathComponent(self.sharedPath)
            if !fileManager.fileExists(atPath: dir.path) {
                do {
                    try fileManager.createDirectory(at: dir, withIntermediateDirectories: false, attributes: nil)
                } catch let error {
                    print("Error on creating directory: \(error.localizedDescription)")
                }
            }
        }
    }
    
    public func getAllSongs() -> [Song] {
        guard let container = self.container else { return [] }
        let dir = container.appendingPathComponent(self.sharedPath)
        if !fileManager.fileExists(atPath: dir.path) { return [] }
        do {
            let items = try fileManager.contentsOfDirectory(atPath: dir.path)
            return self.readSongs(from: dir, songsPath: items)
        } catch let error {
            print("Error on reading contents of directory: \(error.localizedDescription)")
            return []
        }
    }
    
    public func remove(song: Song) {
        guard let container = self.container else { return }
        let dir = container.appendingPathComponent(self.sharedPath)
        let path = dir.appendingPathComponent(song.path)
        do {
            try fileManager.removeItem(at: path)
        } catch let error {
            print("Error in removing song: \(error.localizedDescription)")
        }
    }
    
    private func readSongs(from dir: URL, songsPath: [String]) -> [Song] {
        var songs = [Song]()
        for path in songsPath {
            let url = dir.appendingPathComponent(path)
            let playerItem = AVPlayerItem(url: url)
            let song = Song(path: path, playerItem: playerItem)
            self.setSongInfo(song, fileName: String(path.split(separator: ".")[0]))
            
            songs.append(song)
        }
        return songs
    }
    
    private func setSongInfo(_ song: Song, fileName: String) {
        for item in song.playerItem.asset.metadata {
            guard let key = item.commonKey?.rawValue, let value = item.value else {
                continue
            }
            
            switch key {
                case "title" : song.title = value as? String ?? ""
                case "artist" : song.artist = value as? String ?? ""
                case "artwork" where value is Data : song.artwork = UIImage(data: value as! Data)
                default: continue
            }
        }
        
        if song.title == "" {
            song.title = fileName
        }
    }
}
