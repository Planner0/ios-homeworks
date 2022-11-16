//
//  DatabaseCoorinatable.swift
//  Netology_IB_Instruments
//
//  Created by ALEKSANDR POZDNIKIN on 08.11.2022.
//

import Foundation

//enum DatabaseError: Error {
//    /// Не найдена модель объекта.
//    case wrongModel
//    /// Кастомная ошибка.
//    case error(desription: String)
//    /// Неизвестная ошибка.
//    case unknown
//}
enum DatabaseError: Error {
    /// Невозможно добавить хранилище.
    case store(model: String)
    /// Не найден momd файл.
    case find(model: String, bundle: Bundle?)
    /// Не найдена модель объекта.
    case wrongModel
    /// Кастомная ошибка.
    case error(desription: String)
    /// Неизвестная ошибка.
    case unknown(error: Error)
}
enum Success {
    case save
}

protocol DatabaseCoordinatable {
    /// Создание объекта заданного типа.
    func create<T: Storable>(_ model: T.Type, createModel: AuthorizationModel, completion: @escaping (Result<Success, DatabaseError>) -> Void)
    func check(checkModel: AuthorizationModel, completion: @escaping (Result<Success, DatabaseError>) -> Void)
//    /// Обновление объекта заданного типа с помощью предиката.
//    func update<T: Storable>(_ model: T.Type, predicate: NSPredicate?, keyedValues: [String: Any], completion: @escaping (Result<[T], DatabaseError>) -> Void)
//    /// Удаление объектов заданного типа с помощью предиката.
//    func delete<T: Storable>(_ model: T.Type, predicate: NSPredicate?, completion: @escaping (Result<[T], DatabaseError>) -> Void)
//    /// Удаление всех объектов заданного типа.
//    func deleteAll<T: Storable>(_ model: T.Type, completion: @escaping (Result<[T], DatabaseError>) -> Void)
//    /// Получение объектов заданного типа с помощью предиката.
//    func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate?, completion: @escaping (Result<[T], DatabaseError>) -> Void)
//    /// Получение объектов заданного типа.
//    func fetchAll<T: Storable>(_ model: T.Type, completion: @escaping (Result<[T], DatabaseError>) -> Void)
}
