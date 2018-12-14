//
//  Playlist.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 12/14/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import UIKit

class Playlist {
    var title: String
    var list: Set<String>
    
    init(title: String, list: Set<String>) {
        self.title = title
        self.list = list
    }

    func getImage() -> [UIImage?] {
        var image = [UIImage?]()
        if !self.list.isEmpty {
            let titles = Array(list)
            titles.forEach { (title) in
                if image.count < 4, let song = Player.shared.getSong(withTitle: title) {
                    image.append(song.artwork)
                }
            }
        }
        return image
    }
}
