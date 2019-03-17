//
//  SongCardViewController.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 3/15/19.
//  Copyright © 2019 Ali Tabatabaei. All rights reserved.
//

import UIKit

protocol SongCardSourceProtocol: class {
    var originatingFrameInWindow: CGRect { get }
    var originatingartworkImageView: MPImageView { get }
}

class SongCardViewController: UIViewController, SongSubscriber {
    
    public var currentSong: Song?
    weak var sourceView: SongCardSourceProtocol!
    
    public var backingImage: UIImage?
    private let backingImageView = MPImageView()
    private let dimmerLayer = MPView()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        return  scrollView
    }()
    private let artworkContainer = MPView()
    private let artworkImageView = MPImageView(cornerRadius: 5)
    private let dismissButton = MPButton()
    
    private var backingImageConstraints = [String : NSLayoutConstraint]()
    private var artworkContainerConstraints = [String : NSLayoutConstraint]()
    private var artworkImageConstraints = [String : NSLayoutConstraint]()
    
    private let primaryDuration = 4.0 //set to 0.5 when ready
    private let backingImageEdgeInset: CGFloat = 15.0
    private let cardCornerRadius: CGFloat = 10
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureImageLayerInStartPosition()
        self.artworkImageView.image = self.sourceView.originatingartworkImageView.image
        self.configureCoverImageInStartPosition()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.animateImageLayerIn()
        self.animateCoverImageIn()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.backingImageView.image = self.backingImage
        self.dimmerLayer.backgroundColor = .black
        
        self.artworkContainer.roundCorners([.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: self.cardCornerRadius)
        self.artworkContainer.backgroundColor = .white
        self.dismissButton.setImage(UIImage(from: .ionicon, code: "ios-arrow-down", textColor: .royalBlue, backgroundColor: .clear, size: CGSize(width: 50, height: 50)), for: .normal)
        
        [self.backingImageView, self.dimmerLayer, self.scrollView].forEach { self.view.addSubview($0) }
        [self.artworkContainer].forEach { self.scrollView.addSubview($0) }
        [self.artworkImageView, self.dismissButton].forEach { self.artworkContainer.addSubview($0) }
        self.setAnchors()
        self.setTargets()
        self.animateBackingImageIn()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

extension SongCardViewController {
    private func setAnchors() {
        self.backingImageConstraints = self.backingImageView.anchor(top: self.view.topAnchor, right: self.view.safeAreaRightAnchor(), bottom: self.view.bottomAnchor, left: self.view.safeAreaLeftAnchor())
        self.dimmerLayer.anchor(top: self.view.topAnchor, right: self.view.safeAreaRightAnchor(), bottom: self.view.bottomAnchor, left: self.view.safeAreaLeftAnchor())
        NSLayoutConstraint.activate(Array(backingImageConstraints.values))
        
        self.scrollView.anchor(top: self.backingImageView.topAnchor, right: self.view.safeAreaRightAnchor(), bottom: self.view.bottomAnchor, left: self.view.safeAreaLeftAnchor(), padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0))
        
        self.artworkContainerConstraints = self.artworkContainer.anchor(top: self.scrollView.topAnchor, right: self.scrollView.rightAnchor, bottom: self.scrollView.bottomAnchor, left: self.scrollView.leftAnchor, padding: UIEdgeInsets(top: 57, left: 0, bottom: 237, right: 0))
        NSLayoutConstraint.activate([self.artworkContainer.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor)])
        
        self.artworkImageConstraints = self.artworkImageView.anchor(top: self.dismissButton.bottomAnchor, right: nil, bottom: self.artworkContainer.bottomAnchor, left: self.artworkContainer.leftAnchor, padding: UIEdgeInsets(top: 0, left: 30, bottom: -30, right: 0), size: CGSize(width: 0, height: 354))
        self.artworkImageView.aspect(1, 1, widthIsConstrained: false)
        self.dismissButton.anchor(top: self.artworkContainer.topAnchor, right: nil, bottom: nil, left: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        NSLayoutConstraint.activate([self.dismissButton.centerXAnchor.constraint(equalTo: self.artworkContainer.centerXAnchor)])
    }
    
    private func setTargets() {
        self.dismissButton.addTarget(self, action: #selector(self.dismissButtonOnPress), for: .touchUpInside)
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
        
        
        self.backingImageConstraints["left"]!.constant = edgeInset
        self.backingImageConstraints["right"]!.constant = -edgeInset
        var aspectRatio = CGFloat(1)
        if let backingImage = self.backingImage {
            aspectRatio = backingImage.size.height / backingImage.size.width
        }
        self.backingImageConstraints["top"]!.constant = edgeInset * aspectRatio
        self.backingImageConstraints["bottom"]!.constant = -edgeInset * aspectRatio
        
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


extension SongCardViewController {
    private var startColor: UIColor {
        return UIColor.white.withAlphaComponent(0.3)
    }
    
    private var endColor: UIColor {
        return .white
    }
    
    private var imageLayerInsetForOutPosition: CGFloat {
        let imageFrame = view.convert(sourceView.originatingFrameInWindow, to: view)
        let inset = imageFrame.minY - backingImageEdgeInset
        return inset
    }
    
    func configureImageLayerInStartPosition() {
        self.artworkContainer.backgroundColor = startColor
        let startInset = imageLayerInsetForOutPosition
        self.dismissButton.alpha = 0
        self.artworkContainer.layer.cornerRadius = 0
        self.artworkContainerConstraints["top"]!.constant = startInset
        self.view.layoutIfNeeded()
    }
    
    func animateImageLayerIn() {
        UIView.animate(withDuration: primaryDuration / 4.0) {
            self.artworkContainer.backgroundColor = self.endColor
        }
        
        UIView.animate(withDuration: primaryDuration, delay: 0, options: [.curveEaseIn], animations: {
            self.artworkContainerConstraints["top"]!.constant = 0
            self.dismissButton.alpha = 1
            self.artworkContainer.layer.cornerRadius = self.cardCornerRadius
            self.view.layoutIfNeeded()
        })
    }
    
    func animateImageLayerOut(completion: @escaping ((Bool) -> Void)) {
        let endInset = imageLayerInsetForOutPosition
        
        UIView.animate(withDuration: primaryDuration / 4.0,
                       delay: primaryDuration,
                       options: [.curveEaseOut], animations: {
                        self.artworkContainer.backgroundColor = self.startColor
        }, completion: { finished in
            completion(finished) //fire complete here , because this is the end of the animation
        })
        
        UIView.animate(withDuration: primaryDuration, delay: 0, options: [.curveEaseOut], animations: {
            self.artworkContainerConstraints["top"]!.constant = endInset
            self.dismissButton.alpha = 0
            self.artworkContainer.layer.cornerRadius = 0
            self.view.layoutIfNeeded()
        })
    }
}

extension SongCardViewController {
    func configureCoverImageInStartPosition() {
        let originatingImageFrame = sourceView.originatingartworkImageView.frame
        self.artworkImageConstraints["height"]!.constant = originatingImageFrame.height
        self.artworkImageConstraints["left"]!.constant = originatingImageFrame.minX
        self.artworkImageConstraints["top"]!.constant = originatingImageFrame.minY
        self.artworkImageConstraints["bottom"]!.constant = originatingImageFrame.minY
    }
    
    func animateCoverImageIn() {
        let coverImageEdgeContraint: CGFloat = 30
        let endHeight = self.artworkContainer.bounds.width - coverImageEdgeContraint * 2
        UIView.animate(withDuration: primaryDuration, delay: 0, options: [.curveEaseIn], animations:  {
            self.artworkImageConstraints["height"]!.constant = endHeight
            self.artworkImageConstraints["left"]!.constant = coverImageEdgeContraint
            self.artworkImageConstraints["top"]!.constant = 0
            self.artworkImageConstraints["bottom"]!.constant = -coverImageEdgeContraint
            self.view.layoutIfNeeded()
        })
    }
    
    func animateCoverImageOut() {
        UIView.animate(withDuration: primaryDuration,
                       delay: 0,
                       options: [.curveEaseOut], animations:  {
                        self.configureCoverImageInStartPosition()
                        self.view.layoutIfNeeded()
        })
    }
}

extension SongCardViewController {
    @objc private func dismissButtonOnPress() {
        animateBackingImageOut()
        animateCoverImageOut()
        animateImageLayerOut() { _ in
            self.dismiss(animated: false)
        }
    }
}
