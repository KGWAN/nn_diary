//
//  HeaderView.swift
//  nn
//
//  Created by JUNGGWAN KIM on 7/23/25.
//

import SwiftUI

struct HeaderView: View {
    @Binding var path: Path?
    
    var body: some View {
        HStack(alignment: .center) {
            HeaderButton(imgName: "setting_btn") {
                path = .SETTING
            }
            Spacer()
//                HeaderButton(title: "검색") {
//                    // open 검색
//                }
            HeaderButton(imgName: "monthly_btn") {
                // open 월별
                path = .MONTHLYLIST
            }
        }.padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
    }
}

//#Preview {
//    HeaderView()
//}
