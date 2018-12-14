//
//  Defaults.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 12/14/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import Foundation

struct Defaults {
    private static let (sortByKey, playlistsKey) = ("sortby", "playlists")
    
    static func set(sortBy: Sort) {
        UserDefaults.standard.set(sortBy.rawValue, forKey: sortByKey)
    }
    
    static func getSortBy() -> Sort? {
        let rawValue = UserDefaults.standard.string(forKey: sortByKey)
        return Sort(rawValue: rawValue ?? "")
    }
    
    static func add(playlist name: String, songTitle: String) {
        var data: Data
        if var playlists = getPlaylists() {
            if var playlist = playlists[name] {
                playlist.insert(songTitle)
                playlists[name] = playlist
            } else {
                var playlist = Set<String>()
                playlist.insert(songTitle)
                playlists[name] = playlist
            }
            data = NSKeyedArchiver.archivedData(withRootObject: playlists)
        } else {
            var playlists = [String : Set<String>]()
            var playlist = Set<String>()
            playlist.insert(songTitle)
            playlists[name] = playlist
            data = NSKeyedArchiver.archivedData(withRootObject: playlists)
        }
        UserDefaults.standard.set(data, forKey: playlistsKey)
    }
    
    static func getPlaylists() -> [String : Set<String>]? {
        var playlists: [String : Set<String>]?
        if let data =  UserDefaults.standard.object(forKey: playlistsKey) as? Data {
            playlists = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String : Set<String>]
        }
        return playlists
    }
}
