//
//  SelectingMonthPopup.swift
//  nn
//
//  Created by JUNGGWAN KIM on 7/28/25.
//

import SwiftUI

struct SelectingMonthPopup: View {
    @State var year: Int
    @Binding var isShowPopup: Bool
    var onSelect: (Date) -> Void
    
    @EnvironmentObject var theme: ThemeManager
    
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    isShowPopup = false
                }
            HStack {
                VStack(alignment: .center, spacing: 20) {
                    HStack(alignment: .center, spacing: 10) {
                        SmallImgButton(title: "<") {
                            year -= 1
                        }
                        Text("\(String(year))년")
                            .foregroundStyle(theme.foreground)
                            .frame(maxWidth: .infinity, maxHeight: 30)
                        SmallImgButton(title: ">") {
                            year += 1
                        }
                    }
                    HStack(spacing: 15) {
                        ForEach(0..<4) { col in
                            VStack(spacing: 15) {
                                ForEach(0..<3) { row in
                                    let index = row * 4 + col
                                    Button("\(index + 1)") {
                                        if let mAndY = Date().changeMonthTo(index + 1, year: year) {
                                            onSelect(mAndY)
                                        } else {
                                            print("Error: Cannot select date")
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(10)
                                    .foregroundStyle(theme.background)
                                    .background(theme.foreground)
                                    .cornerRadius(5)
                                }
                            }
                        }
                    }
                }
                .padding(30)
                .background(theme.hilight)
                .cornerRadius(10)
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        }
        .frame(maxWidth: .infinity)
    }
}
//
//#Preview {
//    @Previewable @State var isShowPopup: Bool = false
//    
//    SelectingMonthPopup(
//        year: 2025,
//        isShowPopup: $isShowPopup
//    ) {_  in
//        
//    }
//}
