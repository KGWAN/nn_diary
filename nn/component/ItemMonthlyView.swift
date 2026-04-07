//
//  ItemMonthlyView.swift
//  nn
//
//  Created by JUNGGWAN KIM on 8/4/25.
//

import SwiftUI

struct ItemMonthlyView: View {
    let date: String
    let contents: String
    
    @EnvironmentObject var theme: ThemeManager
    
    var body: some View {
        HStack {
            Text(date)
            Spacer()
            Text(contents)
        }
        .padding(10)
        .foregroundStyle(theme.foreground)
        .background(theme.hilight)
        .cornerRadius(5)
    }
}

#Preview {
    ItemMonthlyView(date: Date().formatted(format: "yyyy.MM.dd EEEE"), contents: "contents")
}
