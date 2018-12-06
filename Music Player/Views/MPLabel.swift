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
        self.font = UIFont(name: "Raleway-v4020-Regular", size: fontSize)
        self.textAlignment = textAlignment
    }
    
    func setFontSize(fontSize: CGFloat) {
        self.font = UIFont(name: "Raleway-v4020-Regular", size: fontSize)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
