//
//  CoreDataCoordinator.swift
//  Netology_IB_Instruments
//
//  Created by ALEKSANDR POZDNIKIN on 16.11.2022.
//

import Foundation
import CoreData

final class CoreDataCoordinator {
    
    let modelName: String

    private let model: NSManagedObjectModel
    private let persistentStoreCoordinator: NSPersistentStoreCoordinator

    private lazy var mainContext: NSManagedObjectContext = {
        let mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return mainContext
    }()

    private init(url: URL) throws {
        let pathExtension = url.pathExtension
        
        guard let name = try? url.lastPathComponent.replace(pathExtension, replacement: "") else {
            throw DatabaseError.error(desription: "")
        }

        guard let model = NSManagedObjectModel(contentsOf: url) else {
            throw DatabaseError.error(desription: "")
        }

        self.modelName = name
        print(name)
        self.model = model
        self.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
    }

//    private convenience init(name: String, bundle: Bundle? = nil) throws {
//        let fileExtension = "momd"
//
//        if
//           let bundle = bundle,
//           let url = bundle.url(forResource: name, withExtension: fileExtension) {
//            try self.init(url: url)
//        } else if let url = Bundle.main.url(forResource: name, withExtension: fileExtension) {
//            try self.init(url: url)
//        } else {
//            throw DatabaseError.find(model: name, bundle: bundle)
//        }
//    }

    static func create(url modelUrl: URL) -> Result<CoreDataCoordinator, DatabaseError> {
        do {
            let coordinator = try CoreDataCoordinator(url: modelUrl)
            return Self.setup(coordinator: coordinator)
        } catch let error as DatabaseError {
            return .failure(error)
        } catch {
            return .failure(.unknown(error: error))
        }
    }

    private static func setup(coordinator: CoreDataCoordinator) -> Result<CoreDataCoordinator, DatabaseError> {
        let storeCoordinator = coordinator.persistentStoreCoordinator

        let fileManager = FileManager.default
        let storeName = "\(coordinator.modelName)" + "sqlite"

        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let persistentStoreURL = documentsDirectoryURL?.appendingPathComponent(storeName)
        print("⭐️ \(persistentStoreURL)")

        var databaseError: DatabaseError?
        do {
            let options = [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]

            try storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                    configurationName: nil,
                                                    at: persistentStoreURL,
                                                    options: options)
        } catch {
            databaseError = .store(model: coordinator.modelName)
        }

        if let error = databaseError {
            return .failure(error)
        }
        
        return .success(coordinator)
    }
}

extension String {
    func replace(_ pattern: String, replacement: String) throws -> String {
        let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
        return regex.stringByReplacingMatches(in: self,
                                              options: [.withTransparentBounds],
                                              range: NSRange(location: 0, length: self.count),
                                              withTemplate: replacement)
    }
}

extension CoreDataCoordinator: DatabaseCoordinatable {
//    func create<T>(_ model: T.Type, createModel: AuthorizationModel, completion: @escaping (Result<Success, DatabaseError>) -> Void) where T : Storable {
//
//    }
    func create<T>(_ model: T.Type, keyedValues: [[String : Any]], completion: @escaping (Result<[T], DatabaseError>) -> Void) where T : Storable {
        self.mainContext.perform { [weak self] in
            guard let self = self else { return }
            
            var entities: [Any] = Array(repeating: true, count: keyedValues.count)
            
            keyedValues.enumerated().forEach { (index, keyedValues) in
                guard let entityDescription = NSEntityDescription.entity(forEntityName: String(describing: model.self),
                                                                         in: self.mainContext)
                else {
                    completion(.failure(.wrongModel))
                    return
                }
                
                let entity = NSManagedObject(entity: entityDescription,
                                             insertInto: self.mainContext)
                entity.setValuesForKeys(keyedValues)
                entities[index] = entity
            }
            
            guard let objects = entities as? [T] else {
                completion(.failure(.wrongModel))
                return
            }
            
            guard self.mainContext.hasChanges else {
                completion(.failure(.store(model: String(describing: model.self))))
                return
            }
            
            do {
                try self.mainContext.save()
                completion(.success(objects))
            } catch let error {
                completion(.failure(.error(desription: "Unable to save changes of main context.\nError - \(error.localizedDescription)")))
            }
        }
    }
//    func check(checkModel: AuthorizationModel, completion: @escaping (Result<Success, DatabaseError>) -> Void) {
//
//    }
    func fetch<T>(_ model: T.Type, predicate: NSPredicate?, completion: @escaping (Result<[T], DatabaseError>) -> Void) where T : Storable {
        guard let model = model as? NSManagedObject.Type else {
            completion(.failure(.wrongModel))
            return
        }
        
        self.mainContext.perform {
            let request = model.fetchRequest()
            request.predicate = predicate
            guard
                let fetchRequestResult = try? self.mainContext.fetch(request),
                let fetchedObjects = fetchRequestResult as? [T]
            else {
                completion(.failure(.wrongModel))
                return
            }
            
            completion(.success(fetchedObjects))
        }
    }
    func fetchAll<T>(_ model: T.Type, completion: @escaping (Result<[T], DatabaseError>) -> Void) where T : Storable {
        self.fetch(model, predicate: nil, completion: completion)
    }
    func delete<T>(_ model: T.Type, predicate: NSPredicate?, completion: @escaping (Result<[T], DatabaseError>) -> Void) where T : Storable {
        self.fetch(model, predicate: predicate) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let fetchedObjects):
                guard let fetchedObjects = fetchedObjects as? [NSManagedObject] else {
                    completion(.failure(.wrongModel))
                    return
                }

                self.mainContext.perform {
                    fetchedObjects.forEach { fetchedObject in
                        self.mainContext.delete(fetchedObject)
                    }
                    let deletedObjects = fetchedObjects as? [T] ?? []
                    
                    guard self.mainContext.hasChanges else {
                        completion(.failure(.store(model: String(describing: model.self))))
                        return
                    }
                    
                    do {
                        try self.mainContext.save()
                        completion(.success(deletedObjects))
                    } catch let error {
                        completion(.failure(.error(desription: "Unable to save changes of main context.\nError - \(error.localizedDescription)")))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteAll<T>(_ model: T.Type, completion: @escaping (Result<[T], DatabaseError>) -> Void) where T : Storable {
        self.delete(model, predicate: nil, completion: completion)
    }
}
