//
//  MainView.swift
//  nn
//
//  Created by JUNGGWAN KIM on 7/23/25.
//

import SwiftUI

struct MainView: View {
    @State var path: Path?
    
    @State var isNotMain: Bool = false
    @State var isShowPopup: Bool = false
    @State var tempDate: MDate = MDate(date: Date())
    @State private var refreshID = UUID()
    
    @Environment(\.scenePhase) private var scenePhase
    
    @EnvironmentObject var theme: ThemeManager
    
    
    var body: some View {
        ZStack {
            VStack {
                HeaderView(path: $path)
                Spacer()
                CalendarView(
                    currentMonth: $tempDate,
                    isShowPopup: $isShowPopup,
                    onTappedDayView: { d in
                        tempDate = d
                        path = .WRITING
                    }
                )
                .id(refreshID)
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    Button {
                        tempDate = MDate(date: Date())
                        path = .WRITING
                    } label: {
                        Image("write_btn")
                            .resizable()
                    }
                    .frame(width: 50, height: 50, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(25)
                }.padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
            }
            if isShowPopup {
                SelectingMonthPopup(
                    year: tempDate.date.getYear(),
                    isShowPopup: $isShowPopup
                ) { mAndY in
                    tempDate.date = mAndY
                    isShowPopup = false
                }
            }
        }
        .background(theme.background)
        .onChange(of: scenePhase) { old, new in
            if new == .active {
                if theme.currentTheme == .SYSTEM {
                    theme.changeTheme(
                        theme: UIScreen.main.traitCollection.userInterfaceStyle == .light ? Theme.LIGHT : Theme.DARK
                    )
                }
            }
        }
        .fullScreenCover(
            item: $path,
            onDismiss: {
                refreshID = UUID()
            },
            content: { p in 
                switch p {
                case .WRITING:
                    WritingView(date: tempDate)
                case .SETTING:
                    SettingView()
                case .MONTHLYLIST:
                    MonthlyListView(month: tempDate.date)
                default:
                    ErrorView()
                }
            }
        )
    }
}

#Preview {
    MainView()
}
