//
//  File.swift
//  nn
//
//  Created by JUNGGWAN KIM on 8/21/25.
//

import Foundation
import CoreData
import SwiftUI

class ConfigServicer {
    static let shared = ConfigServicer()
    
    func search(_ viewContext: NSManagedObjectContext) -> Config? {
        print("[searchConfig]------------------")
        let req: NSFetchRequest<Config> = Config.fetchRequest()
        req.fetchLimit = 1
        do {
            let result = try viewContext.fetch(req)
            print("success")
            print("useYnBio: \(String(describing: result.first?.useYnBio))")
            print("useYnPw: \(String(describing: result.first?.useYnPw))")
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
    
    func write(_ viewContext: NSManagedObjectContext) {
        print("[writeConfig]------------------")
        let c = Config(context: viewContext)
        c.useYnBio = "N"
        c.useYnPw = "N"
        c.revisionDate = Date().formatted(format: "yyyyMMddHHmmss")
        c.registrationDate = Date().formatted(format: "yyyyMMddHHmmss")
        print("useYnBio: \(String(describing: c.useYnBio))")
        print("useYnPw: \(String(describing: c.useYnPw))")
        print("revisionDate: \(String(describing: c.revisionDate))")
        print("registrationDate: \(String(describing: c.registrationDate))")
        do {
            try viewContext.save()
            print("success")
        } catch {
            print("fail")
            print("error: \(error)")
        }
        print("-------------------------------")
    }
    func updateBio(_ isUse: Bool, viewContext: NSManagedObjectContext) {
        print("[updateBio]------------------")
        if let c = search(viewContext) {
            c.useYnBio = isUse ? "Y" : "N"
            c.revisionDate = Date().formatted(format: "yyyyMMddHHmmss")
            print("useYnBio: \(String(describing: c.useYnBio))")
            print("revisionDate: \(String(describing: c.revisionDate))")
        }
        do {
            try viewContext.save()
            print("success")
        } catch {
            print("fail")
            print("error: \(error)")
        }
        print("-------------------------------")
    }
    
    func updatePw(_ isUse: Bool, viewContext: NSManagedObjectContext) {
        print("[updatePw]------------------")
        if let c = search(viewContext) {
            c.useYnPw = isUse ? "Y" : "N"
            c.revisionDate = Date().formatted(format: "yyyyMMddHHmmss")
            print("useYnPw: \(String(describing: c.useYnPw))")
            print("revisionDate: \(String(describing: c.revisionDate))")
        }
        do {
            try viewContext.save()
            print("success")
        } catch {
            print("fail")
            print("error: \(error)")
        }
        print("-------------------------------")
    }
    
    func updateTheme(_ theme: String, viewContext: NSManagedObjectContext) {
        print("[updateTheme]------------------")
        if let c = search(viewContext) {
            c.theme = theme
            c.revisionDate = Date().formatted(format: "yyyyMMddHHmmss")
            print("theme: \(String(describing: c.theme))")
            print("revisionDate: \(String(describing: c.revisionDate))")
        }
        do {
            try viewContext.save()
            print("success")
        } catch {
            print("fail")
            print("error: \(error)")
        }
        print("-------------------------------")
    }
}
