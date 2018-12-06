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
    
    var delegate: MPNowPlayingViewDelegate?
    
    static let buttonSize = CGSize(width: 40, height: 40)
    var isPlaying = false {
        didSet {
            if !isPlaying {
                self.playButton.setImage(UIImage(from: .ionicon, code: "ios-play", textColor: .darkGray, backgroundColor: .clear, size: MPNowPlayingView.buttonSize), for: .normal)
            } else {
                self.playButton.setImage(UIImage(from: .ionicon, code: "ios-pause", textColor: .darkGray, backgroundColor: .clear, size: MPNowPlayingView.buttonSize), for: .normal)
            }
        }
    }
    let artwork = MPImageView(cornerRadius: 3)
    let titleLabel = MPLabel(text: "Not Playing", fontSize: 12)
    let artistLabel = MPLabel(text: "", fontSize: 12)
    let previousButton: MPButton = {
        let button = MPButton()
        button.setImage(UIImage(from: .ionicon, code: "ios-play", textColor: .darkGray, backgroundColor: .clear, size: MPNowPlayingView.buttonSize), for: .normal)
        
        
        return button
    }()
    let playButton: MPButton = {
        let button = MPButton()
        button.setImage(UIImage(from: .ionicon, code: "ios-play", textColor: .darkGray, backgroundColor: .clear, size: MPNowPlayingView.buttonSize), for: .normal)
        
        
        return button
    }()
    let nextButton: MPButton = {
        let button = MPButton()
        button.setImage(UIImage(from: .ionicon, code: "ios-skip-forward", textColor: .darkGray, backgroundColor: .clear, size: MPNowPlayingView.buttonSize), for: .normal)
        
        
        return button
    }()

    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = .white
        self.addBorders(edges: [.top], color: .gray, thickness: 0.2)
        
        [self.artwork, self.titleLabel, self.artistLabel, self.playButton, self.nextButton].forEach { self.addSubview($0) }
        
        self.setAnchors()
        self.setTargets()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MPNowPlayingView {
    
    private func setAnchors() {
        self.artwork.anchor(top: self.topAnchor, right: nil, bottom: self.bottomAnchor, left: self.leftAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0))
        self.artwork.widthAnchor.constraint(equalTo: self.artwork.heightAnchor).isActive = true
        
        self.nextButton.anchor(top: self.topAnchor, right: self.rightAnchor, bottom: nil, left: nil, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 10), size: MPNowPlayingView.buttonSize)
        
        self.playButton.anchor(top: self.nextButton.topAnchor, right: self.nextButton.leftAnchor, bottom: nil, left: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10), size: MPNowPlayingView.buttonSize)
        
        
        self.titleLabel.anchor(top: self.artwork.topAnchor, right: self.playButton.leftAnchor, bottom: nil, left: self.artwork.rightAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
        
        self.artistLabel.anchor(top: self.titleLabel.bottomAnchor, right: self.titleLabel.rightAnchor, bottom: nil, left: self.artwork.rightAnchor, padding: UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 0))
        
    }
    
    private func setTargets() {
        self.playButton.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        self.nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
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
}

extension MPNowPlayingView {
    @objc func playButtonPressed() {
        if let delegate = self.delegate {
            if !self.isPlaying {
                delegate.play()
                self.play()
            } else {
                delegate.pause()
                self.pause()
            }
        }
    }
    
    @objc func nextButtonPressed() {
        if let delegate = self.delegate {
            delegate.next()
        }
    }
}
