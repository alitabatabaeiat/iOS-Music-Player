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
    
    static func add(playlist title: String, songTitle: String? = nil) {
        var playlists = getPlaylists()
        
        if let playlist = playlists.first(where: { $0.title == title })  {
            if let songTitle = songTitle {
                playlist.add(song: songTitle)
            }
        } else {
            let playlist = Playlist(title: title)
            if let songTitle = songTitle {
                playlist.add(song: songTitle)
            }
            playlists.append(playlist)
        }
        
        do {
            let data = try JSONEncoder().encode(playlists)
            UserDefaults.standard.set(data, forKey: playlistsKey)
        } catch let ex {
            print(ex)
        }
    }
    
    static func getPlaylists() -> [Playlist] {
        if let data = UserDefaults.standard.data(forKey: playlistsKey) {
            do {
                let playlists = try JSONDecoder().decode([Playlist].self, from: data)
                return playlists
            } catch let ex {
                print(ex)
            }
        }
        return [Playlist]()
    }
}
