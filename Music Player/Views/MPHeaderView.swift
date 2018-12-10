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
    let sortButton: MPButton = {
        let button = MPButton()
        let image = UIImage(from: .iconic, code: "sort-ascending", textColor: .darkGray, backgroundColor: .clear, size: CGSize(width: 30, height: 30))
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    init(titleText: String) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.title.text = titleText
        
        [self.title, self.sortButton].forEach { self.addSubview($0) }
        
        self.setAnchors()
        self.addBorders(edges: [.bottom], color: .gray, thickness: 0.2)
        self.sortButton.addTarget(self, action: #selector(self.sortButtonPressed), for: .touchUpInside)
    }
    
    func setAnchors() {
        self.title.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.sortButton.anchor(top: self.title.topAnchor, right: self.rightAnchor, bottom: nil, left: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15), size: CGSize(width: 25, height: 25))
    }
    
    @objc func sortButtonPressed() {
        if let delegate = self.delegate {
            delegate.headerView(self, didSortButtonPressed: self.sortButton)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
