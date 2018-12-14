//
//  Defaults.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 12/14/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import Foundation

struct Defaults {
    private static let (sortByKey) = ("sortby")
    
    static func set(sortBy: Sort) {
        UserDefaults.standard.set(sortBy.rawValue, forKey: sortByKey)
    }
    
    static func getSortBy() -> Sort? {
        let rawValue = UserDefaults.standard.string(forKey: sortByKey)
        return Sort(rawValue: rawValue ?? "")
    }
}
