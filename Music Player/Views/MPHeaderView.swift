//
//  MPHeaderView.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 12/6/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import UIKit

class MPHeaderView: UIView {
    
    var delegate: MPHeaderViewDelegate?
    
    let title = MPLabel(fontSize: 20, textAlignment: .center)
    let rightButton = MPButton()
    
    init(titleText: String, rightButtonImage: UIImage? = nil) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.title.text = titleText
        self.rightButton.setImage(rightButtonImage, for: .normal)
        
        [self.title, self.rightButton].forEach { self.addSubview($0) }
        
        self.setAnchors()
        self.addBorders(edges: [.bottom], color: .gray, thickness: 0.2)
        if rightButtonImage != nil {
            self.rightButton.addTarget(self, action: #selector(self.rightButtonPressed), for: .touchUpInside)
        }
    }
    
    func setAnchors() {
        self.title.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.rightButton.anchor(top: self.title.topAnchor, right: self.rightAnchor, bottom: nil, left: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15), size: CGSize(width: 25, height: 25))
    }
    
    @objc func rightButtonPressed() {
        self.rightButton.animate(completion: nil)
        if let delegate = self.delegate {
            delegate.headerView(self, didRightButtonPressed: self.rightButton)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
