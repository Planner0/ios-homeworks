//
//  Checker.swift
//  Netology_IB_Instruments
//
//  Created by ALEKSANDR POZDNIKIN on 12.05.2022.
//

import Foundation
import FirebaseAuth
import UIKit

protocol CheckerServiceProtocol {
    func checkCredentials(email: String, password: String, completion: @escaping (AuthDataResult?, NSError?) -> Void)
    func signUp(with email: String, password: String, completion: @escaping (AuthDataResult?, NSError?) -> Void)
}

class CheckerService: CheckerServiceProtocol {

    
    static let shared = CheckerService()
    
    private init(){}
    
    func checkCredentials(email: String, password: String, completion callback: @escaping (AuthDataResult?, NSError?) -> Void) {
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard error == nil else {
                print(error!.localizedDescription)
                callback(nil, error as NSError?)
                return
            }
            print("вход")
            print(authResult!)
            callback(authResult, nil)
        }
    }
        
    func signUp(with email: String, password: String, completion: @escaping (AuthDataResult?, NSError?) -> Void) {
        guard FirebaseAuth.Auth.auth().currentUser != nil else { return }
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { createResult, error in
            guard error == nil else {
                print(error!)
                completion(nil, error as NSError?)
                return
            }
            print("вход")
            print(createResult!)
            completion(createResult, nil)
        }
    }
}


