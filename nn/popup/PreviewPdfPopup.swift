//
//  PreviewPdfPopup.swift
//  nn
//
//  Created by JUNGGWAN KIM on 9/15/25.
//

import SwiftUI

struct PreviewPdfPopup: View {
    let pageNumber: Int
    let diaries: [Diary]
    @Binding var isShowPreview: Bool
    
    var body: some View {
        Color.black
            .opacity(0.5)
            .ignoresSafeArea()
            .onTapGesture {
                isShowPreview = false
            }
        .overlay {
            DiaryPageTempleteView(pageNumber: pageNumber, diaries: diaries)
                .scaleEffect(0.5)
        }
    }
}

//#Preview {
//    PreviewPdfPopup()
//}
