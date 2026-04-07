//
//  SmallImgButton.swift
//  nn
//
//  Created by JUNGGWAN KIM on 7/28/25.
//

import SwiftUI

struct SmallImgButton: View {
    @State var title: String
    var action: () -> Void
    
    @EnvironmentObject var theme: ThemeManager
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundStyle(theme.foreground)
        }
        .frame(width: 20, height: 20)
        .padding(5)
        .cornerRadius(20)
    }
}

#Preview {
    SmallImgButton(title: "<") {
    }
}
