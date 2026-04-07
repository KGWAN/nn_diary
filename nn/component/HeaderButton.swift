//
//  HeaderButton.swift
//  nn
//
//  Created by JUNGGWAN KIM on 7/23/25.
//

import SwiftUI

struct HeaderButton: View {
    let imgName: String
    let action: () -> Void
    
    @EnvironmentObject var theme: ThemeManager
    
    var body: some View {
        Button(action: action) {
            Image(imgName) // Assets.xcassets에 등록된 이미지 이름
                .resizable()
        }
        .frame(width: 30, height: 30, alignment: .center)
        .background(theme.hilight2)
        .cornerRadius(5)
    }
}

#Preview {
    HeaderButton(imgName: "exampleTitle") {
    }
}
