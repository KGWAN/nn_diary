//
//  DiaryTempleteView.swift
//  nn
//
//  Created by JUNGGWAN KIM on 9/3/25.
//

import SwiftUI

struct DiaryTempleteView: View {
    @State var date: String
    @State var note: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(date)
                .font(.headline)
            Text(note)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 100, alignment: .leading) // 높이 고정
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

//#Preview {
//    DiaryTempleteView(date: "2025-09-03", note: "sample note")
//}
