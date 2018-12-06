//
//  Song.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 12/5/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import UIKit
import AVFoundation

class Song {
    var playerItem: AVPlayerItem!
    var title: String?
    var artist: String?
    var artwork: UIImage?
    
    init(playerItem: AVPlayerItem) {
        self.playerItem = playerItem
        self.title = nil
        self.artist = nil
        self.artwork = nil
    }
    
    init(playerItem: AVPlayerItem, title: String, artist: String, artwork: UIImage?) {
        self.playerItem = playerItem
        self.title = title
        self.artist = artist
        self.artwork = artwork
    }
}
