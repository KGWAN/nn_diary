//
//  PersistenceController.swift
//  nn
//
//  Created by JUNGGWAN KIM on 7/29/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "nnModel") // .xcdatamodeld 파일명과 동일하게!
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        // 자동 마이그레이션 옵션 설정
        let description = container.persistentStoreDescriptions.first
        description?.shouldMigrateStoreAutomatically = true
        description?.shouldInferMappingModelAutomatically = true
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data 로딩 실패: \(error)")
            }
        }
    }
    
    func getContext() -> NSManagedObjectContext {
        return container.viewContext
    }
    
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

