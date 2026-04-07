//
//  DiaryPageView.swift
//  nn
//
//  Created by JUNGGWAN KIM on 9/3/25.
//

import SwiftUI

struct DiaryPageTempleteView: View {
    let pageNumber: Int
    let diaries: [Diary]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Page \(pageNumber)")
                .font(.title2)
                .bold()
            
            Divider()
            
            ForEach(diaries) { diary in
                DiaryTempleteView(date: diary.date ?? "", note: diary.note ?? "")
                    .onAppear {
                        print("d5 : \(diary.date ?? "")")
                        print("d5 : \(diary.note ?? "")")
                    }
            }
            
            Spacer()
        }
        .padding()
        .frame(width: 595, height: 842) // A4 크기
        .background(Color.white)
    }
}

//#Preview {
//    DiaryPageView(pageNumber: <#Int#>, diaries: <#[Diary]#>)
//}
