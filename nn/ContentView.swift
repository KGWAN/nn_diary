//
//  ContentView.swift
//  nn
//
//  Created by JUNGGWAN KIM on 7/23/25.
//

import SwiftUI
import LocalAuthentication
import GoogleSignIn

struct ContentView: View {
    @State private var authCode: String = "0000"
    @State private var pathCode: Path? = nil
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var theme: ThemeManager

    
    var body: some View {
        Group {
            if authCode == "0001" {
                MainView()
            } else {
                IntroView()
                    .onAppear {
                        checkTheme()
                        GoogleDriverManager.shared.restorePreviousGoogleSignIn()
                        checkAuth()
                    }
            }
        }
        .fullScreenCover(item: $pathCode) {
            // onDismiss
        } content: { pc in
            switch pc {
            case Path.PASSWORD:
                PassWordView(
                    purposeCode: 1,
                    isSuccess: Binding(
                        get: { self.authCode == "0001" },
                        set: { isSucces in
                            if isSucces {
                                authCode = "0001"
                            } else {
                                authCode = "9999"
                            }
                        }
                    )
                )
            default:
                ErrorView()
            }
        }
        .onChange(of: authCode) { old, new in
            if new == "9999" {
                exit(0)
            }
        }
    }
    
    private func checkAuth() {
        let config = ConfigServicer.shared.search(viewContext)
        if config?.useYnBio == "Y" {
            BioController.shared.authenticate {
                authCode = "0001"
            } onFailure: { e in
                print(e)
                if config?.useYnPw == "Y" {
                    pathCode = .PASSWORD
                } else {
                    authCode = "9999"
                }
            }
        } else if config?.useYnPw == "Y" {
            pathCode = .PASSWORD
        } else {
            authCode = "0001"
        }
    }
    
    private func checkTheme() {
        if let raw = ConfigServicer.shared.search(viewContext)?.theme,
           let t = Theme(rawValue: raw) {
            theme.changeTheme(theme: t)
        }
    }
}

#Preview {
    ContentView()
}
