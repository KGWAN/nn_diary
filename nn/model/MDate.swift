//
//  MDate.swift
//  nn
//
//  Created by JUNGGWAN KIM on 8/1/25.
//

import Foundation

struct MDate: Identifiable {
    var date: Date
    let id = UUID()
    
    private let formatStr: String = "yyyyMMdd"
    
    init(date: Date) {
        self.date = date
    }
    
    init?(str: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = formatStr
        if let date = formatter.date(from: str) {
            self.date = date
        } else {
            return nil
        }
    }
    
    func toString() -> String {
        return date.formatted(format: formatStr)
    }
    
//    private func toDate(str: String) -> Date? {
//        let formatter = DateFormatter()
//        formatter.dateFormat = formatStr
//        
//        if let date = formatter.date(from: str) {
//            print("변환된 날짜: \(date)")
//            return date
//        } else {
//            print("변환 실패")
//        }
//        return nil
//    }
}
