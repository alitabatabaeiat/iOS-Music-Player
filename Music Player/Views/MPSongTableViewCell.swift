//
//  MPSongTableViewCell.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 12/1/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import UIKit
import AVFoundation

class MPSongTableViewCell: UITableViewCell {
    
    let container = MPView()
    let artwork = MPImageView(cornerRadius: 4)
    let titleLabel = MPLabel(fontSize: 16)
    let artistLabel = MPLabel(font: UIFont.latoLight, fontSize: 12)
    let horizontalLine: MPView = {
        let horizontalLine = MPView()
        horizontalLine.backgroundColor = .gray
        return horizontalLine
    }()
    
    var song: Song? {
        didSet {
            if let song = self.song {
                self.titleLabel.text = song.title
                self.artistLabel.text = song.artist
                self.artwork.image = song.artwork
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        self.addSubview(self.container)
        [self.artwork, self.titleLabel, self.artistLabel].forEach { self.container.addSubview($0) }
        
        self.setAnchors()
    }
    
    func setAnchors() {
        self.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.container.anchor(top: self.topAnchor, right: self.rightAnchor, bottom: self.bottomAnchor, left: self.leftAnchor, padding: UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 15))
        
        self.artwork.anchor(top: self.container.topAnchor, right: nil, bottom: self.container.bottomAnchor, left: self.container.leftAnchor)
        self.artwork.widthAnchor.constraint(equalTo: self.artwork.heightAnchor).isActive = true
        
        self.titleLabel.anchor(top: nil, right: self.container.rightAnchor, bottom: self.centerYAnchor, left: self.artwork.rightAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: -2, right: 5))
        
        self.artistLabel.anchor(top: self.titleLabel.bottomAnchor, right: self.titleLabel.rightAnchor, bottom: nil, left: self.titleLabel.leftAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    public func addBottomLine() {
        self.container.addSubview(self.horizontalLine)
        self.horizontalLine.anchor(top: nil, right: self.rightAnchor, bottom: self.bottomAnchor, left: self.titleLabel.leftAnchor, size: CGSize(width: 0, height: 0.2))
    }
    
    public func removeBottomLine() {
        self.horizontalLine.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MPSongTableViewCell {
    public func animate() {
        self.artwork.animate(completion: nil)
    }
}
