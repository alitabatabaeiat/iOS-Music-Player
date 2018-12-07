//
//  OptionSet.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 12/7/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import Foundation

struct songListOption: OptionSet {
    let rawValue: Int
    
    static let all = songListOption(rawValue: 1 << 0)
    static let shuffled = songListOption(rawValue: 1 << 1)
}
