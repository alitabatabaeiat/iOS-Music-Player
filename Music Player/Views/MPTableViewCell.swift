//
//  MPTableViewCell.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 12/1/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import UIKit
import AVFoundation

class MPTableViewCell: UITableViewCell {
    
    let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return  view
    }()
    let artwork = MPImageView()
    let titleLabel = MPLabel()
    let artistLabel = MPLabel()
    
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
        self.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.container.anchor(top: self.topAnchor, right: self.rightAnchor, bottom: self.bottomAnchor, left: self.leftAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
        
        self.artwork.anchor(top: self.container.topAnchor, right: nil, bottom: self.container.bottomAnchor, left: self.leftAnchor, padding: UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 0))
        self.artwork.widthAnchor.constraint(equalTo: self.artwork.heightAnchor).isActive = true
        
        self.titleLabel.anchor(top: self.artwork.topAnchor, right: self.container.rightAnchor, bottom: nil, left: self.artwork.rightAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
        
        self.artistLabel.anchor(top: self.titleLabel.bottomAnchor, right: self.titleLabel.rightAnchor, bottom: nil, left: self.titleLabel.leftAnchor, padding: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
