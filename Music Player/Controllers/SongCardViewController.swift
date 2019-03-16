//
//  SongCardViewController.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 3/15/19.
//  Copyright © 2019 Ali Tabatabaei. All rights reserved.
//

import UIKit

class SongCardViewController: UIViewController, SongSubscriber {
    
    public var currentSong: Song?
    
    public var backingImage: UIImage?
    private let backingImageView = MPImageView()
    private var backingImageTopInset: NSLayoutConstraint!
    private var backingImageLeadingInset: NSLayoutConstraint!
    private var backingImageTrailingInset: NSLayoutConstraint!
    private var backingImageBottomInset: NSLayoutConstraint!
    
    private let dimmerLayer = MPView()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return  scrollView
    }()
    private let artworkContainer = MPView()
    private let artworkImageView = MPImageView()
    
    private let primaryDuration = 4.0 //set to 0.5 when ready
    private let backingImageEdgeInset: CGFloat = 15.0
    private let cardCornerRadius: CGFloat = 10

    override func viewDidLoad() {
        super.viewDidLoad()

        self.backingImageView.image = self.backingImage
        self.dimmerLayer.backgroundColor = .black
        
        self.artworkContainer.roundCorners([.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: self.cardCornerRadius)
        self.artworkContainer.backgroundColor = .white
        self.artworkImageView.backgroundColor = .yellow
        
        [self.backingImageView, self.dimmerLayer, self.scrollView].forEach { self.view.addSubview($0) }
        [self.artworkContainer].forEach { self.scrollView.addSubview($0) }
        [self.artworkImageView].forEach { self.artworkContainer.addSubview($0) }
        self.setAnchors()
        self.animateBackingImageIn()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

extension SongCardViewController {
    private func setAnchors() {
        self.backingImageTopInset = self.backingImageView.topAnchor.constraint(equalTo: self.view.topAnchor)
        self.backingImageBottomInset = self.backingImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        self.backingImageLeadingInset = self.backingImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLeadingAnchor())
        self.backingImageTrailingInset = self.backingImageView.trailingAnchor.constraint(equalTo: self.view.safeAreaTrailingAnchor())
        self.dimmerLayer.anchor(top: self.view.topAnchor, right: self.view.safeAreaRightAnchor(), bottom: self.view.bottomAnchor, left: self.view.safeAreaLeftAnchor())
        NSLayoutConstraint.activate([self.backingImageTopInset, self.backingImageBottomInset, self.backingImageTrailingInset, self.backingImageLeadingInset])
        
        self.scrollView.anchor(top: self.backingImageView.topAnchor, right: self.view.safeAreaRightAnchor(), bottom: self.view.bottomAnchor, left: self.view.safeAreaLeftAnchor(), padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0))
        
        self.artworkContainer.anchor(top: self.scrollView.topAnchor, right: self.scrollView.rightAnchor, bottom: self.scrollView.bottomAnchor, left: self.scrollView.leftAnchor, padding: UIEdgeInsets(top: 57, left: 0, bottom: 237, right: 0))
        NSLayoutConstraint.activate([self.artworkContainer.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor)])
        
        self.artworkImageView.anchor(top: self.artworkContainer.topAnchor, right: nil, bottom: self.artworkContainer.bottomAnchor, left: self.artworkContainer.leftAnchor, padding: UIEdgeInsets(top: 38, left: 30, bottom: 30, right: 0), size: CGSize(width: 0, height: 354))
        self.artworkImageView.aspect(1, 1, widthIsConstrained: false)
    }
    
    
    public func configure(song: Song?) {
        self.currentSong = song
    }
}

extension SongCardViewController {
    
    private func configureBackingImageInPosition(presenting: Bool) {
        let edgeInset: CGFloat = presenting ? self.backingImageEdgeInset : 0
        let dimmerAlpha: CGFloat = presenting ? 0.3 : 0
        let cornerRadius: CGFloat = presenting ? self.cardCornerRadius : 0
        
        
        self.backingImageLeadingInset.constant = edgeInset
        self.backingImageTrailingInset.constant = -edgeInset
        var aspectRatio = CGFloat(1)
        if let backingImage = self.backingImage {
            aspectRatio = backingImage.size.height / backingImage.size.width
        }
        self.backingImageTopInset.constant = edgeInset * aspectRatio
        self.backingImageBottomInset.constant = -edgeInset * aspectRatio
        
        self.dimmerLayer.alpha = dimmerAlpha
        
        self.backingImageView.layer.cornerRadius = cornerRadius
    }
    
    
    private func animateBackingImage(presenting: Bool) {
        UIView.animate(withDuration: primaryDuration) {
            self.configureBackingImageInPosition(presenting: presenting)
            self.view.layoutIfNeeded() //IMPORTANT!
        }
    }
    
    
    func animateBackingImageIn() {
        animateBackingImage(presenting: true)
    }
    
    func animateBackingImageOut() {
        animateBackingImage(presenting: false)
    }
}
