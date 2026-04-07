//
//  MonthView.swift
//  nn
//
//  Created by JUNGGWAN KIM on 7/23/25.
//

import SwiftUI
import CoreData

struct MonthView: View {
    @Binding var month: Date
    let onTappedDayView: (MDate) -> Void
    
    let weeks: Int = 6
    let calendar = Calendar(identifier: .gregorian)
    @State private var writedList: [NSDictionary] = []
    @State private var isWrited: Bool = false
    
    @Environment(\.managedObjectContext) private var viewContext

    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(generateCalendarDates(for: month), id: \.self.id) { d in
                // d: 활성화, 0: 비활성화, 1: 오늘, 2: 숨김
                let ptc: Int = if !isSelectedMonth(d.date) {
                        2
                    } else if isSelectedMonth(d.date) && calendar.isDate(d.date, equalTo: Date(), toGranularity: .day) {
                        1
                    } else if isSelectedMonth(d.date) && isFuture(d.date) {
                        0
                    } else {
                        -1
                    }
                
                DayView(
                    date: d,
                    presentTypeCode: ptc,
                    isWrited: isWritedDiaryAt(d.date),
                    onTapped: onTappedDayView
                ).frame(maxWidth: .infinity).onAppear {
                    print("[dayView data]--------------------")
                    print("date(UTC 기준): \(d.date)")
                    print("presentTypeCode: \(ptc)")
                    print("d: \(d.date.formatted(format: "d"))")
                    print("---------------------------------")
                }
            }
        }
        .onAppear {
            selectwritedDiaryListFor(month: month)
        }.onChange(of: month) { oldValue, newValue in
            selectwritedDiaryListFor(month: newValue)
        }
    }
    
    private func generateCalendarDates(for date: Date) -> [MDate] {
        print(date)
        // 이 달의 첫번재 날
        guard let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: date))
        else { return [] }
        // 첫번째 날의 요일
        // 1 = 일, 7 = 토
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        // 앞에 채워야 할 수
        let leadingDays = firstWeekday - 1
        // 채울 배열
        var days: [MDate] = []
        // 앞 부분 채우기
        if leadingDays > 0,
           let previousMonth = calendar.date(byAdding: .month, value: -1, to: date),
           let previousMonthDays = calendar.range(of: .day, in: .month, for: previousMonth) {
            let startDay = previousMonthDays.count - leadingDays + 1
            for day in startDay...previousMonthDays.count {
                if let date = calendar.date(bySetting: .day, value: day, of: previousMonth) {
                    days.append(MDate(date:date))
                }
            }
        }
        // 이 달의 일 수
        let numberOfDays = calendar.range(of: .day, in: .month, for: date)!.count
        // 해당 월 날짜 채우기
        for day in 1...numberOfDays {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay) {
                days.append(MDate(date:date))
            }
        }
        // 뒷 부분 채우기
        let remaining = 7 - (days.count % 7)
        if remaining < 7 {
            if let nextMonth = calendar.date(byAdding: .month, value: 1, to: date) {
                for day in 1...remaining {
                    if let date = calendar.date(bySetting: .day, value: day, of: nextMonth) {
                        days.append(MDate(date:date))
                    }
                }
            }
        }
        let log = """
            [MonthView dateList(days)]-----------------------
            days.count: \(days.count)
            <days.childs>(UTC 기준) 
            \(days)
            <end days.childs>
            -------------------------------------------------
            """
        print(log)
        return days
    }
    
    private func isSelectedMonth(_ date: Date) -> Bool {
        return calendar.isDate(date, equalTo: month, toGranularity: .month)
    }
    
    private func isFuture(_ date: Date) -> Bool {
        return calendar.startOfDay(for: date) > calendar.startOfDay(for: Date())
    }
    
    private func selectwritedDiaryListFor(month: Date) {
        let req = NSFetchRequest<NSDictionary>(entityName: "Diary")
        req.resultType = .dictionaryResultType
        req.propertiesToFetch = ["date"]
        req.predicate = NSPredicate(format: "date BEGINSWITH %@", month.formatted(format: "yyyyMM"))
        req.sortDescriptors = [NSSortDescriptor(keyPath: \Diary.date, ascending: true)]
        do {
            let result = try viewContext.fetch(req)
            writedList = []
            writedList = result
            debugPrint(writedList)
        } catch {
            print(error)
            writedList.removeAll()
        }
    }
    
    private func isWritedDiaryAt(_ date: Date)-> Bool {
        var result: Bool = false
        writedList.forEach { wi in
            if let wiDate = wi["date"] as? String,
               date.formatted(format: "yyyyMMdd") == wiDate {
                 result = true
            }
        }
        return result
    }
}

#Preview {
    @Previewable @State var currentMonth: Date = Date()
    
    MonthView(month: $currentMonth) { d in
    }
}
