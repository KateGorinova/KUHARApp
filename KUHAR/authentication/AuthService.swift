//
//  AuthService.swift
//  KUHAR
//
//  Created by Екатерина Горинова on 15.03.25.
//

import Foundation
import FirebaseAuth

class AuthService{
    
    static let shared = AuthService()
    
    private init() {}
    
    private let auth = Auth.auth()
    
    var currentUser: User? {
        return auth.currentUser
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> ()){
        auth.createUser(withEmail: email, password: password) { result, error in
            if let result = result {
                let newUser = NewUser(id: result.user.uid, name : "")
                DatabaseService.shared.setProfile(user: newUser) { resultDB in
                    switch resultDB{
                    case .success(_):
                        completion(.success(result.user))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                completion(.success(result.user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> ()){
        auth.signIn(withEmail: email, password: password) { result, error in
            if let result = result {
                completion(.success(result.user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
}
