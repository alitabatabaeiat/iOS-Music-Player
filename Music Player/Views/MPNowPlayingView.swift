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
    
    static let buttonSize = CGSize(width: 30, height: 30)
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
    let artistLabel = MPLabel(text: "", font: UIFont.latoLight, fontSize: 12)
    let previousButton: MPButton = {
        let button = MPButton()
        button.setImage(UIImage(from: .ionicon, code: "ios-rewind", textColor: .darkGray, backgroundColor: .clear, size: MPNowPlayingView.buttonSize), for: .normal)
        
        
        return button
    }()
    let playButton: MPButton = {
        let button = MPButton()
        button.setImage(UIImage(from: .ionicon, code: "ios-play", textColor: .darkGray, backgroundColor: .clear, size: MPNowPlayingView.buttonSize), for: .normal)
        
        
        return button
    }()
    let nextButton: MPButton = {
        let button = MPButton()
        button.setImage(UIImage(from: .ionicon, code: "ios-fastforward", textColor: .darkGray, backgroundColor: .clear, size: MPNowPlayingView.buttonSize), for: .normal)
        
        
        return button
    }()

    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = .white
        self.addBorders(edges: [.top], color: .gray, thickness: 0.2)
        
        [self.artwork, self.titleLabel, self.artistLabel, self.playButton, self.nextButton, self.previousButton].forEach { self.addSubview($0) }
        
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
        
        self.nextButton.anchor(top: nil, right: self.rightAnchor, bottom: nil, left: nil, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 10), size: MPNowPlayingView.buttonSize)
        self.nextButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.playButton.anchor(top: nil, right: self.nextButton.leftAnchor, bottom: nil, left: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10), size: MPNowPlayingView.buttonSize)
        self.playButton.centerYAnchor.constraint(equalTo: self.nextButton.centerYAnchor).isActive = true
        
        self.previousButton.anchor(top: nil, right: self.playButton.leftAnchor, bottom: nil, left: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10), size: MPNowPlayingView.buttonSize)
        self.previousButton.centerYAnchor.constraint(equalTo: self.nextButton.centerYAnchor).isActive = true
        
        self.titleLabel.anchor(top: nil, right: self.playButton.leftAnchor, bottom: self.centerYAnchor, left: self.artwork.rightAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5))
        
        self.artistLabel.anchor(top: self.titleLabel.bottomAnchor, right: self.titleLabel.rightAnchor, bottom: nil, left: self.titleLabel.leftAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
    }
    
    private func setTargets() {
        self.playButton.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        self.nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        self.previousButton.addTarget(self, action: #selector(previousButtonPressed), for: .touchUpInside)
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
        self.playButton.animate(completion: nil)
        if let delegate = self.delegate {
            if !self.isPlaying {
                delegate.play(in: self)
                self.play()
            } else {
                delegate.pause(in: self)
                self.pause()
            }
        }
    }
    
    @objc func nextButtonPressed() {
        self.nextButton.animate(completion: nil)
        if let delegate = self.delegate {
            delegate.next(in: self)
        }
    }
    
    @objc func previousButtonPressed() {
        self.previousButton.animate(completion: nil)
        if let delegate = self.delegate {
            delegate.previous(in: self)
        }
    }
}
