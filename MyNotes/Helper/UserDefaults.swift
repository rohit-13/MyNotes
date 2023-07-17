//
//  UserDefaults.swift
//  MyNotes
//
//  Created by Rohit Kumar on 09/07/23.
//

import Foundation

extension UserDefaults {
    private static let privateNotes = "privateNotes"
    private static let darkTheme = "darkTheme"
    
    var darkThemeEnabled: Bool? {
        get { bool(forKey: UserDefaults.darkTheme) }
        set { set(newValue, forKey: UserDefaults.darkTheme) }
    }
    
    var privateNotesEnabled: Bool? {
        get { bool(forKey: UserDefaults.privateNotes) }
        set { set(newValue, forKey: UserDefaults.privateNotes) }
    }
    
}


