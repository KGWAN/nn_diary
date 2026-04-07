//
//  DiaryServicer.swift
//  nn
//
//  Created by JUNGGWAN KIM on 8/28/25.
//

import Foundation
import CoreData

class DiaryServicer {
    static let shared = DiaryServicer()
    
    func search(_ viewContext: NSManagedObjectContext, date: MDate) -> Diary? {
        print("[searchDiary]------------------")
        let req: NSFetchRequest<Diary> = Diary.fetchRequest()
        req.predicate = NSPredicate(format: "date == %@", date.toString())
        req.fetchLimit = 1
        do {
            let result = try viewContext.fetch(req)
            print("success")
            print("date: \(String(describing: result.first?.date))")
            print("note: \(String(describing: result.first?.note))")
            print("revisionDate: \(String(describing: result.first?.revisionDate))")
            print("registrationDate: \(String(describing: result.first?.registrationDate))")
            print("-------------------------------")
            return result.first
        } catch {
            print("fail")
            print("error: \(error)")
            print("-------------------------------")
            return nil
        }
    }
    
    func write(
        _ viewContext: NSManagedObjectContext,
        date: MDate,
        text: String,
        callback: ((Bool, Diary) -> Void)
    ) {
        print("[writeDiary]------------------")
        let d = Diary(context: viewContext)
        d.date = date.toString()
        d.note = text
        d.revisionDate = Date().formatted(format: "yyyyMMddHHmmss")
        d.registrationDate = Date().formatted(format: "yyyyMMddHHmmss")
        print("date: \(String(describing: d.date))")
        print("note: \(String(describing: d.note))")
        print("revisionDate: \(String(describing: d.revisionDate))")
        print("registrationDate: \(String(describing: d.registrationDate))")
        do {
            try viewContext.save()
            print("success")
            callback(true, d)
            print("-------------------------------")
        } catch {
            print("fail")
            print("error: \(error)")
            callback(false, d)
            print("-------------------------------")
        }
    }
    
    func update(
        _ viewContext: NSManagedObjectContext,
        diary: Diary,
        date: MDate,
        text: String,
        callback: ((Bool, Diary) -> Void)
    ) {
        print("[updateDiary]------------------")
        diary.date = date.toString()
        diary.note = text
        diary.revisionDate = Date().formatted(format: "yyyyMMddHHmmss")
        print("date: \(String(describing: diary.date))")
        print("(updated)note: \(String(describing: diary.note))")
        print("(updated)revisionDate: \(String(describing: diary.revisionDate))")
        print("registrationDate: \(String(describing: diary.registrationDate))")
        do {
            try viewContext.save()
            print("success")
            callback(true, diary)
        } catch {
            print("fail")
            print("error: \(error)")
            callback(false, diary)
            print("-------------------------------")
        }
    }
    
    func searchAll(_ viewContext: NSManagedObjectContext) -> [Diary]? {
        print("[searchAllDiary]------------------")
        let req: NSFetchRequest<Diary> = Diary.fetchRequest()
        req.sortDescriptors = [NSSortDescriptor(keyPath: \Diary.date, ascending: true)]
        do {
            let result = try viewContext.fetch(req)
            print("success")
            print("date: \(String(describing: result.first?.date))")
            print("note: \(String(describing: result.first?.note))")
            print("revisionDate: \(String(describing: result.first?.revisionDate))")
            print("registrationDate: \(String(describing: result.first?.registrationDate))")
            print("-------------------------------")
            return result
        } catch {
            print("fail")
            print("error: \(error)")
            print("-------------------------------")
            return nil
        }
    }
    
    // isAscending: true = 최신순, false = 오래된순
    func selectFor(
        _ viewContext: NSManagedObjectContext,
        month: Date,
        isAscending: Bool = true
    ) -> [Diary]? {
        print("[searchForMonth]------------------")
        let req: NSFetchRequest<Diary> = Diary.fetchRequest()
        req.predicate = NSPredicate(format: "date BEGINSWITH %@", month.formatted(format: "yyyyMM"))
        req.sortDescriptors = [NSSortDescriptor(keyPath: \Diary.date, ascending: isAscending)]
        print("month: \(month.formatted(format: "mm"))")
        do {
            let result = try viewContext.fetch(req)
            print("count: \(result.count)")
            return if result.isEmpty { nil } else { result }
        } catch {
            print(error)
            print("fail")
            print("error: \(error)")
            print("-------------------------------")
            return nil
        }
    }
}
