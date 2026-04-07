//
//  BtnSeletingMonth.swift
//  nn
//
//  Created by JUNGGWAN KIM on 8/26/25.
//

import SwiftUI

struct BtnSeletingMonth: View {
    @Binding var month: Date
    let onTouched: () -> Void
    
    @EnvironmentObject var theme: ThemeManager
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Spacer()
            SmallImgButton(title: "<") {
                if let new = month.getPrevMonth() {
                    month = new
                } else {
                    print("error")
                }
            }
            Button(month.formatted(format: "yyyy년 M월")) {
                onTouched()
            }
            .foregroundStyle(theme.foreground)
            SmallImgButton(title: ">") {
                if let new = month.getNextMonth() {
                    month = new
                } else {
                    print("error")
                }
            }
            Spacer()
        }
    }
}

//#Preview {
//    @Previewable @State var m: Date = Date()
//    
//    BtnSeletingMonth(month: $m, onTouched: {
//        print("Touch")
//    })
//}
