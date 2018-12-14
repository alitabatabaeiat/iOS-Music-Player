//
//  MPPlaylistTableViewCell.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 12/14/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import UIKit

class MPPlaylistTableViewCell: UITableViewCell {
    
    let container = MPView()
    let playlistImageContainer = MPView(cornerRadius: 8)
    let playlistLabel = MPLabel(fontSize: 18)
    let horizontalLine = MPView()
    
    var playlist: Playlist? {
        didSet {
            if let playlist = self.playlist {
                self.playlistLabel.text = playlist.title
                self.setImage(playlist.getImage())
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        self.addSubview(self.container)
        [self.playlistImageContainer, self.playlistLabel, self.horizontalLine].forEach { self.container.addSubview($0) }
        
        self.setAnchors()
    }
    
    func setAnchors() {
        self.heightAnchor.constraint(equalToConstant: 85).isActive = true
        
        self.container.anchor(top: self.topAnchor, right: self.rightAnchor, bottom: self.bottomAnchor, left: self.leftAnchor, padding: UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15))
        
        self.playlistImageContainer.anchor(top: self.container.topAnchor, right: nil, bottom: self.container.bottomAnchor, left: self.container.leftAnchor)
        self.playlistImageContainer.widthAnchor.constraint(equalTo: self.playlistImageContainer.heightAnchor).isActive = true
        
        self.playlistLabel.anchor(top: nil, right: self.container.rightAnchor, bottom: nil, left: self.playlistImageContainer.rightAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 5))
        self.playlistLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.horizontalLine.anchor(top: nil, right: self.rightAnchor, bottom: self.bottomAnchor, left: self.playlistLabel.leftAnchor, size: CGSize(width: 0, height: 0.2))
        self.horizontalLine.backgroundColor = .gray
    }
    
    private func setImage(_ playlistImage: [UIImage?]) {
        if playlistImage.count >= 4 {
            var imageViews = [UIImageView]()
            playlistImage.forEach { imageViews.append(MPImageView(image: $0)) }
            imageViews.forEach { self.playlistImageContainer.addSubview($0) }
            
            imageViews[0].anchor(top: self.playlistImageContainer.topAnchor, right: self.playlistImageContainer.centerXAnchor, bottom: self.playlistImageContainer.centerYAnchor, left: self.playlistImageContainer.leftAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0.2, right: 0.2))
            
            imageViews[1].anchor(top: self.playlistImageContainer.topAnchor, right: self.playlistImageContainer.rightAnchor, bottom: self.playlistImageContainer.centerYAnchor, left: self.playlistImageContainer.centerXAnchor, padding: UIEdgeInsets(top: 0, left: 0.2, bottom: 0.2, right: 0))
            
            imageViews[2].anchor(top: self.playlistImageContainer.centerYAnchor, right: self.playlistImageContainer.centerXAnchor, bottom: self.playlistImageContainer.bottomAnchor, left: self.playlistImageContainer.leftAnchor, padding: UIEdgeInsets(top: 0.2, left: 0, bottom: 0, right: 0.2))
            
            imageViews[3].anchor(top: self.playlistImageContainer.centerYAnchor, right: self.playlistImageContainer.rightAnchor, bottom: self.playlistImageContainer.bottomAnchor, left: self.playlistImageContainer.centerXAnchor, padding: UIEdgeInsets(top: 0.2, left: 0.2, bottom: 0, right: 0))
            
        } else if playlistImage.count > 0 {
            let image = playlistImage[0]
            let imageView = MPImageView(image: image)
            self.playlistImageContainer.addSubview(imageView)
            
            imageView.anchorSize(to: self.playlistImageContainer)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
