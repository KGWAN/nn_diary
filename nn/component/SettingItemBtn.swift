//
//  SettingItemBtn.swift
//  nn
//
//  Created by JUNGGWAN KIM on 8/4/25.
//

import SwiftUI

struct SettingItemBtn: View {
    let img: String
    let title: String
    let acttion: () -> Void
    
    @EnvironmentObject var theme: ThemeManager
    
    var body: some View {
        Button(action: acttion) {
            HStack(alignment: .center, spacing: 12) {
                Image(img)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .background(theme.hilight3)
                    .cornerRadius(5)
                Text(title)
                    .foregroundStyle(theme.foreground)
                Spacer()
            }
        }
        .padding(10)
        .background(theme.hilight)
        .cornerRadius(5)
    }
}

#Preview {
    SettingItemBtn(img: "img", title: "title") {}
}
