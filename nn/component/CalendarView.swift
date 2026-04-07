//
//  CalendarView.swift
//  nn
//
//  Created by JUNGGWAN KIM on 7/23/25.
//

import SwiftUI
import CoreData

struct CalendarView: View {
    @Binding var currentMonth: MDate
    @Binding var isShowPopup: Bool
    let onTappedDayView: (MDate) -> Void
    
    @EnvironmentObject var theme: ThemeManager
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack(alignment: .center) {
                Button {
                    isShowPopup = true
                } label: {
                    HStack(alignment: .center) {
                        Text(currentMonth.date.formatted(format: "yyyy년 M월"))
                            .bold()
//                            .foregroundStyle(theme.foreground)
                        Text(currentMonth.date.formatted(format: ">"))
                            .foregroundStyle(Color.gray)
                    }
                }
                Spacer()
            }
            DayOfWeekView()
            MonthView(
                month: $currentMonth.date,
                onTappedDayView: onTappedDayView
            ).gesture(
                DragGesture()
                    .onEnded { v in
                        let horizontalAmount = v.translation.width
                        let verticalAmount = v.translation.height
                        if abs(horizontalAmount) < abs(verticalAmount) {
                            if verticalAmount < -50 {
                                // 위로 스와이프
                                if let next = currentMonth.date.getNextMonth() {
                                    currentMonth = MDate(date: next)
                                }
                            } else if verticalAmount > 50 {
                                // 아래로 스와이프
                                if let prev = currentMonth.date.getPrevMonth() {
                                    currentMonth = MDate(date: prev)
                                }
                            }
                        }
//                        
                    }
            )
        }.padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
    }

}

#Preview {
    @Previewable @State var currentMonth: MDate = MDate(date: Date())
    @Previewable @State var isShowPopup: Bool = false
    
    CalendarView(
        currentMonth: $currentMonth,
        isShowPopup: $isShowPopup
    ) {d in
        //
    }
}
