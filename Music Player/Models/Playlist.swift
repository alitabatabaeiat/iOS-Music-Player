//
//  Playlist.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 12/14/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import UIKit

class Playlist: Codable {
    var title: String
    var songs: [String]
    private var insertedSongs: Set<String>
    
    init(title: String) {
        self.title = title
        self.songs = [String]()
        self.insertedSongs = Set<String>()
    }
    
    func add(song title: String, at position: Int? = nil) {
        if self.insertedSongs.insert(title).inserted {
            if let position = position {
                self.songs.insert(title, at: position)
            } else {
                self.songs.append(title)
            }
        }
    }

    func getImage() -> [UIImage?] {
        var image = [UIImage?]()
        if self.songs.count > 0 {
            self.songs.forEach { (title) in
                if image.count < 4, let song = Player.shared.getSong(withTitle: title) {
                    image.append(song.artwork)
                }
            }
        }
        return image
    }
}
