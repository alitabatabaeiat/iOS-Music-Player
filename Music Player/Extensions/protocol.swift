//
//  protocol.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 12/6/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import Foundation
import AVFoundation

protocol MPHeaderViewDelegate {
    func headerView(_ headerView: MPHeaderView, didRightButtonPressed button: MPButton)
}

protocol MPNowPlayingViewDelegate {
    func play(in nowPlayingView: MPNowPlayingView)
    func pause(in nowPlayingView: MPNowPlayingView)
    func next(in nowPlayingView: MPNowPlayingView)
    func previous(in nowPlayingView: MPNowPlayingView)
}

protocol PlayerDelegate {
    func player(_ player: Player, didPlay song: Song?)
    func player(_ player: Player, didPause song: Song?)
    func player(_ player: Player, didAdvanceToNext song: Song?)
    func player(_ player: Player, willRemoveSong song: Song)
}
