//
//  MPView.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 12/6/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import UIKit

class MPView: UIView {

    init(cornerRadius: CGFloat = 0) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = cornerRadius != 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
