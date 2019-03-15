//
//  SongSubscriber.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 3/15/19.
//  Copyright © 2019 Ali Tabatabaei. All rights reserved.
//

protocol SongSubscriber: class {
    var currentSong: Song? { get set }
}
