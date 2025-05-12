//
//  CoreDataManager.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/13/25.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BookData")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData 로딩 실패: \(error.localizedDescription)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("CoreData 저장 완료")
            } catch {
                print("CoreData 저장 실패: \(error.localizedDescription)")
            }
        }
    }
}
