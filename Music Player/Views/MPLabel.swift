//
//  MPLabel.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 12/2/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import UIKit

class MPLabel: UILabel {

    init(text: String = "TDLabel", textColor: UIColor = .black, fontSize: CGFloat = 16, textAlignment:NSTextAlignment = .left) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.text = text
        self.textColor = textColor
        self.font = UIFont.lato?.withSize(fontSize)
        self.textAlignment = textAlignment
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
