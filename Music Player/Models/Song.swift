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
    var path: String
    var playerItem: AVPlayerItem!
    var title: String
    var artist: String
    var artwork: UIImage?
    
    init(path: String, playerItem: AVPlayerItem) {
        self.path = path
        self.playerItem = playerItem
        self.title = ""
        self.artist = ""
        self.artwork = UIImage(named: "music")
    }
}
