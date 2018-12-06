//
//  MPHeaderView.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 12/6/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import UIKit

class MPHeaderView: UIView {
    
    let title = MPLabel(fontSize: 20, textAlignment: .center)
    
    init(titleText: String) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.title.text = titleText
        
        [self.title].forEach { self.addSubview($0) }
        
        self.setAnchors()
        self.addBorders(edges: [.bottom], color: .gray, thickness: 0.2)
    }
    
    func setAnchors() {
        self.title.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
