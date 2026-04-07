//
//  MonthlyListView.swift
//  nn
//
//  Created by JUNGGWAN KIM on 8/4/25.
//

import SwiftUI
import CoreData

struct MonthlyListView: View {
    @State var month: Date
    @State private var diaryList: [Diary] = []
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var theme: ThemeManager
    private let servicer = DiaryServicer.shared
    
    private struct Param: Identifiable {
        let id = UUID()
        var path: Path? = nil
        var selectedDate: Date? = nil
    }
    @State private var param: Param? = nil
    @State var isShowPopup: Bool = false
    @State private var selectedSort: String = ""
    let sortItems: [String] = ["최신순", "오래된순"]
    
    let calendar = Calendar(identifier: .gregorian)
    
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                ZStack {
                    HStack(alignment: .center, spacing: 10) {
                        HeaderButton(imgName: "back_btn") {
                            dismiss()
                        }
                        Spacer()
                    }
                    BtnSeletingMonth(month: $month) {
                        isShowPopup = true
                    }
                }.padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                
                VStack {
                    ForEach(diaryList, id: \.self) { diary in
                        Button(action: {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyyMMdd"
                            
                            if let date = formatter.date(from: diary.date ?? "") {
                                param = MonthlyListView.Param(
                                    path: .WRITING,
                                    selectedDate: date
                                )
                            } else {
                                print("변환 실패")
                            }
                        }, label: {
                            ItemMonthlyView(date: diary.date ?? "", contents: diary.note ?? "")
                        })
                    }
                }.onAppear {
                    onSelected(servicer.selectFor(viewContext, month: month))
                }.onChange(of: month) { oldVal, newVal in
                    onSelected(servicer.selectFor(viewContext, month: newVal, isAscending: selectedSort == "최신순" ? true : false))
                }.onChange(of: selectedSort) { oldValue, newValue in
                    onSelected(servicer.selectFor(viewContext, month: month, isAscending: newValue == "최신순" ? true : false))
                }
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                .cornerRadius(5)
                Spacer()
            }
            HStack(alignment: .center, spacing: 10) {
                Spacer()
                DropdownButton(selectedItem: $selectedSort, items: sortItems, isFirstItemSelected: true)
            }
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            if isShowPopup {
                SelectingMonthPopup(
                    year: month.getYear(),
                    isShowPopup: $isShowPopup
                ) { mAndY in
                    month = mAndY
                    isShowPopup = false
                }
            }
        }
        .background(theme.background)
        .fullScreenCover(
            item: $param,
            onDismiss: {
                onSelected(servicer.selectFor(viewContext, month: month, isAscending: selectedSort == "최신순" ? true : false))
            }, content: { p in
                if p.path == Path.WRITING {
                    if let date = p.selectedDate {
                        WritingView(date: MDate(date: date))
                    }
                }
            })
    }
    
    private func onSelected(_ newList: [Diary]?) {
        if let li = newList {
            diaryList.removeAll()
            diaryList = li
        } else {
            diaryList.removeAll()
        }
    }
}

//#Preview {
//    MonthlyListView(month: Date())
//}
