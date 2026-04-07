//
//  nnApp.swift
//  nn
//
//  Created by JUNGGWAN KIM on 7/23/25.
//

import SwiftUI

@main
struct nnApp: App {
    @StateObject private var themeManager = ThemeManager()
    
    let persistenceController = PersistenceController.shared
    
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.getContext())
                    .environmentObject(themeManager)
            }
        }
    }
}
