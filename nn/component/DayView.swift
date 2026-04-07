//
//  DayView.swift
//  nn
//
//  Created by JUNGGWAN KIM on 7/25/25.
//

import SwiftUI

struct DayView: View {
    @State var date: MDate
    @State var title: String?
    
    // d: 활성화, 0: 비활성화, 1: 오늘, 2: 숨김
    let presentTypeCode: Int
    let isWrited: Bool
    let onTapped: (MDate) -> Void
    
//    @EnvironmentObject var theme: ThemeManager
    
    var body: some View {
        Button(action: {
            switch presentTypeCode {
            case 0, 2:
                return
            default:
                onTapped(date)
            }
        }) {
            ZStack {
                VStack(alignment: .center) {
                    switch presentTypeCode {
                    case 0:
                        Text(title ?? "")
                            .frame(maxWidth: .infinity)
//                            .foregroundStyle(theme.week)
                    case 1:
                        Text(title ?? "")
                            .frame(maxWidth: .infinity)
//                            .foregroundStyle(theme.foreground)
                            .background(Color.gray.opacity(0.5))
                    case 2:
                        Text("")
                            .frame(maxWidth: .infinity)
//                            .foregroundStyle(theme.background)
                    default:
                        Text(title ?? "")
                            .frame(maxWidth: .infinity)
//                            .foregroundStyle(theme.foreground)
                    }
                }
                if (
                    ![0, 2].contains(where: { $0 == presentTypeCode }) &&
                    isWrited
                ) {
                    VStack{
                        HStack{
                            Spacer()
                            Circle()
                                .fill(.black)
//                                .fill(theme.foreground)
                                .frame(width: 5, height: 5)
                        }
                        Spacer()
                    }
                }
            }
            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
            .frame(height: 50)
        }
        .onAppear() {
            title = date.date.formatted(format: "d")
        }
    }
}

#Preview {
    DayView(date: MDate(date: Date()), presentTypeCode: 2, isWrited: true) { d in
    }
}
