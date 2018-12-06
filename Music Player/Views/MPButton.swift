//
//  MPButton.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 12/5/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import UIKit

class MPButton: UIButton {

    init(fontSize: CGFloat = 16) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel?.font = UIFont(name: "Raleway-v4020-Regular", size: fontSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
