//
//  Path.swift
//  nn
//
//  Created by JUNGGWAN KIM on 8/4/25.
//

import Foundation

enum Path: Identifiable {
    case WRITING
    case SETTING
    case MONTHLYLIST
    // 설정
    case THEME
    case LOCK
    case PASSWORD
    case GOOGLEDRIVE
    case PDF
    case GITHUB
    
    var id: Int {
        hashValue
    }
}

enum Theme: String, Identifiable, CaseIterable {
    case SYSTEM = "System"
    case LIGHT = "Light"
    case DARK = "Dark"
    
    var id: Int {
        hashValue
    }
}

enum Lock: String, Identifiable, CaseIterable {
    case PASSWORD = "Password"
    case BIO = "Biometric authentication"
    
    var id: Int {
        hashValue
    }
}
