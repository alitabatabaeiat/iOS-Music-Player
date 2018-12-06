//
//  MPTableView.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 12/1/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import UIKit

class MPTableView: UITableView {

    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: .zero, style: style)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.separatorStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
