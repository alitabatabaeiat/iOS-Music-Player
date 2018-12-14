//
//  MPImageView.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 12/1/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import UIKit

class MPImageView: UIImageView {

    init(image: UIImage? = nil, cornerRadius: CGFloat = 0) {
        super.init(image: image)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
