//
//  ThemeSettingView.swift
//  nn
//
//  Created by JUNGGWAN KIM on 8/12/25.
//

import SwiftUI

struct ThemeSettingView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var theme: ThemeManager
    
    @State var selectedTheme: Theme
    
    
    var body: some View {
        VStack {
            SubHeaderView() {
                dismiss()
            }
            VStack(spacing: 10) {
                ForEach(Theme.allCases, id: \.self) { option in
                    Button(
                        action: {
                            theme.changeTheme(theme: option)
                            selectedTheme = option
                        }, label: {
                            HStack {
                                Text(option.rawValue)
                                    .foregroundStyle(theme.foreground)
                                Spacer()
                                if selectedTheme == option {
                                    Circle()
                                        .fill(theme.foreground)
                                        .frame(width: 20, height: 20)
                                } else {
                                    Circle()
                                        .stroke(theme.week, lineWidth: 3)
                                        .frame(width: 17, height: 17)
                                }
                            }
                            .padding(15)
                            .background(theme.hilight)
                            .cornerRadius(5)
                        }
                    )
                }
            }
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            Spacer()
        }
        .background(theme.background)
        .onAppear() {
            if let key = ConfigServicer.shared.search(viewContext)?.theme,
                let t = Theme(rawValue: key) {
                selectedTheme = t
            } else {
                selectedTheme = theme.currentTheme
            }
        }
        .onChange(of: selectedTheme) { oldValue, newValue in
            ConfigServicer.shared.updateTheme(selectedTheme.rawValue, viewContext: viewContext)
        }
    }
}

//#Preview {
//    ThemeSettingView()
//}
