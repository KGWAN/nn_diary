//
//  ThemeManager.swift
//  nn
//
//  Created by JUNGGWAN KIM on 8/12/25.
//

import Foundation
import SwiftUI
import UIKit

class ThemeManager: ObservableObject {
    @Published var currentTheme: Theme = .SYSTEM
    @Published var background: Color = .white
    @Published var foreground: Color = .black
    @Published var hilight: Color = Color(hex: "#eeeeee")
    @Published var hilight2: Color = Color(hex: "#cccccc")
    @Published var hilight3: Color = Color(hex: "#ffffff")
    @Published var week: Color = .gray
    

    func changeTheme(theme: Theme) {
        let style = UIScreen.main.traitCollection.userInterfaceStyle
        switch theme {
        case .SYSTEM:
            if style == .light {
                changeTheme(theme: .LIGHT)
            } else {
                changeTheme(theme: .DARK)
            }
        case .LIGHT:
            background = .white
            foreground = .black
            hilight = Color(hex: "#eeeeee")
            hilight2 = Color(hex: "#ffffff")
            hilight3 = Color(hex: "#ffffff")
            week = .gray
        case .DARK:
            background = .black
            foreground = .white
            hilight = Color(hex: "#333333")
            hilight2 = Color(hex: "#cccccc")
            hilight3 = Color(hex: "#ffffff")
            week = Color.gray
        }
        currentTheme = theme
    }
}


