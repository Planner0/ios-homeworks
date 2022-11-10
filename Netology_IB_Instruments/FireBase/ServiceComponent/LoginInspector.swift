//
//  LoginInspector.swift
//  Netology_IB_Instruments
//
//  Created by ALEKSANDR POZDNIKIN on 22.05.2022.
//

import Foundation

enum AuthModel {
    case good
}
enum NetworkError: Error {
    case error(NSError)
}
final class LoginInspector: LoginViewControllerDelegate {
    

    func checkCredentials(email: String, password: String, completion: @escaping (Result<AuthModel, NetworkError>) -> Void) {
        
         
        CheckerService.shared.checkCredentials(email: email, password: password) { result, error in
            guard error == nil else {
                completion(.failure(.error(error!)))
                return
            }
            completion(.success(.good))
        }
    }
    
    func signUp(with email: String, password: String, completion: @escaping (Result<AuthModel, NetworkError>) -> Void) {
        CheckerService.shared.signUp(with: email, password: password) { result, error in
            guard error == nil else {
                completion(.failure(.error(error!)))
                return
            }
            completion(.success(.good))
        }
    }
    
}
