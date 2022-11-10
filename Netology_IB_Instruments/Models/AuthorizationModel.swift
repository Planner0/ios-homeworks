//
//  AuthorizationModel.swift
//  Netology_IB_Instruments
//
//  Created by ALEKSANDR POZDNIKIN on 08.11.2022.
//

import Foundation
import RealmSwift

final class AuthorizationModel: Object {
    @objc dynamic var email: String = ""
    @objc dynamic var password: String = ""
    @objc dynamic var isAuthorized: Bool = false
//    @objc dynamic var content: String?
//    @objc dynamic var title: String = ""
//    @objc dynamic var specification: String?
//    @objc dynamic var url: String = ""
//    @objc dynamic var publishedAt: String = ""
//    @objc dynamic var isFavorite: Bool = false
//    @objc dynamic var id = 0

//      override static func primaryKey() -> String? {
//         return "id"
//      }
    override static func primaryKey() -> String? {
        return "email"
    }
//
    convenience required init(email: String, password: String) {
        self.init()
        self.email = email
        self.password = password
    }
}
