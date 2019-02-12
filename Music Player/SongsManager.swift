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
    private let documentDirectory: URL?
    private let sharedContainer: URL?
    private let sharedPath: String
    private let musicPath: String
    
    init(path: String, sharedPath: String) {
        self.documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        self.sharedContainer = fileManager.containerURL(forSecurityApplicationGroupIdentifier: path)
        self.sharedPath = sharedPath
        self.musicPath = ".music"
    }
    
    public func createDirectoryIfNeeded() {
        guard let container = self.sharedContainer else { return }
        guard let documentDirectory = self.documentDirectory else { return }
        let musicDirectory = documentDirectory.appendingPathComponent(self.musicPath)
        let dir = container.appendingPathComponent(self.sharedPath)
        
        if !fileManager.fileExists(atPath: musicDirectory.path) {
            do {
                try fileManager.createDirectory(at: musicDirectory, withIntermediateDirectories: false, attributes: nil)
            } catch let error {
                print("Error on creating \(self.musicPath) directory: \(error.localizedDescription)")
            }
        }
        
        if !fileManager.fileExists(atPath: dir.path) {
            do {
                try fileManager.createDirectory(at: dir, withIntermediateDirectories: false, attributes: nil)
            } catch let error {
                print("Error on creating \(self.sharedPath) directory: \(error.localizedDescription)")
            }
        }
    }
    
    public func moveSongsToMusicDirectory() -> [Song] {
        guard let documentDirectory = self.documentDirectory else { return [] }
        guard let container = self.sharedContainer else { return [] }
        let musicDirectory = documentDirectory.appendingPathComponent(self.musicPath)
        let dir = container.appendingPathComponent(self.sharedPath)
        
        if !fileManager.fileExists(atPath: dir.path) { return [] }

        do {
            var newSongs = [Song]()
            
            var items = try fileManager.contentsOfDirectory(atPath: dir.path)
            
            items = moveSongs(items: items, from: dir, to: musicDirectory)
            newSongs += self.readSongs(from: musicDirectory, songsPath: items)
            
            items = try fileManager.contentsOfDirectory(atPath: documentDirectory.path)
            items = moveSongs(items: items, from: documentDirectory, to: musicDirectory)
            newSongs += self.readSongs(from: musicDirectory, songsPath: items)
            
            print("newSongs.count = \(newSongs.count)")
            
            return newSongs
        } catch let error {
            print("Error on reading contents of directory: \(error.localizedDescription)")
        }
        return []
    }
    
    private func moveSongs(items: [String], from sourceDir: URL, to destinationDir: URL) -> [String] {
        var newItems = [String]()
        for item in items {
            if item == self.musicPath { continue }
            let source = sourceDir.appendingPathComponent(item)
            let destination = destinationDir.appendingPathComponent(item)
            do {
                try fileManager.moveItem(at: source, to: destination)
                newItems.append(item)
            } catch let error {
                print("Error on moving \(item) to musicDirectory: \(error.localizedDescription)")
                do {
                    try fileManager.removeItem(at: source)
                } catch let error {
                    print("Error on removing\(item): \(error.localizedDescription)")
                }
            }
        }
        return newItems
    }
    
    public func getAllSongs() -> [Song] {
        guard let musicDirectory = self.documentDirectory?.appendingPathComponent(self.musicPath) else { return [] }
        if !fileManager.fileExists(atPath: musicDirectory.path) { return [] }
        do {
            let items = try fileManager.contentsOfDirectory(atPath: musicDirectory.path)
            return self.readSongs(from: musicDirectory, songsPath: items)
        } catch let error {
            print("Error on reading contents of directory: \(error.localizedDescription)")
            return []
        }
    }
    
    public func remove(song: Song) {
        guard let documentDirectory = self.documentDirectory else { return }
        let path = documentDirectory.appendingPathComponent(song.path)
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
