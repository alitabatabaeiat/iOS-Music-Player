//
//  MPNowPlayingView.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 12/5/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftIconFont

class MPNowPlayingView: UIView {
    
    var isPlaying = false {
        didSet {
            if !isPlaying {
                self.playButton.setImage(UIImage(from: .ionicon, code: "ios-play", textColor: .gray, backgroundColor: .clear, size: CGSize(width: 50, height: 50)), for: .normal)
            } else {
                self.playButton.setImage(UIImage(from: .ionicon, code: "ios-pause", textColor: .gray, backgroundColor: .clear, size: CGSize(width: 50, height: 50)), for: .normal)
            }
        }
    }
    let artwork = MPImageView()
    let titleLabel = MPLabel(fontSize: 12)
    let artistLabel = MPLabel(fontSize: 12)
    let playButton: MPButton = {
        let button = MPButton()
        button.setImage(UIImage(from: .ionicon, code: "ios-play", textColor: .gray, backgroundColor: .clear, size: CGSize(width: 50, height: 50)), for: .normal)
        
        
        return button
    }()

    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = .white
        self.addBorders(edges: [.top], color: .gray, thickness: 0.2)
        
        [self.artwork, self.titleLabel, self.artistLabel, self.playButton].forEach { self.addSubview($0) }
        
        setupAnchors()
    }
    
    func setupAnchors() {
        self.artwork.anchor(top: self.topAnchor, right: nil, bottom: self.bottomAnchor, left: self.leftAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0))
        self.artwork.widthAnchor.constraint(equalTo: self.artwork.heightAnchor).isActive = true
        
        self.playButton.anchor(top: self.topAnchor, right: self.rightAnchor, bottom: nil, left: nil, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 10))
        
        self.titleLabel.anchor(top: self.artwork.topAnchor, right: self.playButton.rightAnchor, bottom: nil, left: self.artwork.rightAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
        
        self.artistLabel.anchor(top: self.titleLabel.bottomAnchor, right: self.titleLabel.rightAnchor, bottom: nil, left: self.artwork.rightAnchor, padding: UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 0))
        
    }
    
    func configure(with song: Song) {
        self.titleLabel.text = song.title
        self.artistLabel.text = song.artist
        self.artwork.image = song.artwork
        self.play()
    }
    
    func play() {
        self.isPlaying = true
    }
    
    func pause() {
        self.isPlaying = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
