//
//  SubHeaderView.swift
//  nn
//
//  Created by JUNGGWAN KIM on 7/25/25.
//

import SwiftUI

struct SubHeaderView: View {
    var onBackBtnTapped: (() -> Void)
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            HeaderButton(imgName: "back_btn") {
                onBackBtnTapped()
            }
            Spacer()
        }.padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
    }
}

#Preview {
    SubHeaderView() {
    }
}
