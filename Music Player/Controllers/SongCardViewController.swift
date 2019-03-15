//
//  SongCardViewController.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 3/15/19.
//  Copyright © 2019 Ali Tabatabaei. All rights reserved.
//

import UIKit

class SongCardViewController: UIViewController, SongSubscriber {
    
    var currentSong: Song?
    
    private let artworkImageView = MPImageView(image: nil, cornerRadius: 4)

    override func viewDidLoad() {
        super.viewDidLoad()

        [self.artworkImageView].forEach { self.view.addSubview($0) }
        self.setAnchors()
    }
}

extension SongCardViewController {
    private func setAnchors() {
        self.artworkImageView.anchor(top: self.view.safeAreaTopAnchor(), right: self.view.safeAreaRightAnchor(), bottom: nil, left: self.view.safeAreaLeftAnchor(), padding: UIEdgeInsets(top: 30, left: 30, bottom: 0, right: 30))
        self.artworkImageView.aspect(1, 1, widthIsConstrained: true)
    }
    
    
    public func configure(song: Song) {
        self.currentSong = song
        self.artworkImageView.image = song.artwork
    }
}
