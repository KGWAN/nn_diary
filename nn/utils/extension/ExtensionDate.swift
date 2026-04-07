//
//  ExtensionDate.swift
//  nn
//
//  Created by JUNGGWAN KIM on 8/4/25.
//

import Foundation

extension Date {
    func formatted(format: String)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func getYear()-> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: self)
        return components.year ?? 0
    }
    
    func changeMonthTo(_ month: Int, year: Int)-> Date? {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: self)
        components.month = month
        components.year = year
        if let new = calendar.date(from: components) {
            return new
        }
        return nil
    }
    
    func getOffsetMonth(_ offset: Int)-> Date? {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(byAdding: .month, value: offset, to: self)
    }
    
    func getPrevMonth()-> Date? {
        return getOffsetMonth(-1)
    }
    
    func getNextMonth()-> Date? {
        return getOffsetMonth(1)
    }
    
    func getPrevYear()-> Date? {
        return getOffsetMonth(-12)
    }
    
    func getNextYear()-> Date? {
        return getOffsetMonth(12)
    }
}
