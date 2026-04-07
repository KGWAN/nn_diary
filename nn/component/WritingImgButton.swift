//
//  NomalButton.swift
//  nn
//
//  Created by JUNGGWAN KIM on 7/25/25.
//

import SwiftUI

struct WritingImgButton: View {
    let img: String
    let action: () -> Void
    
    @EnvironmentObject var theme: ThemeManager
    
    var body: some View {
        Button(action: action) {
            Image(img)
                .resizable()
        }
        .frame(width: 30, height: 30, alignment: .center)
        .background(theme.hilight2)
        .cornerRadius(15)
    }
}

#Preview {
    WritingImgButton(img: "사진") {
        
    }
}
