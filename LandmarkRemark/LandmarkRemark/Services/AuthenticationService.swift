//
//  AuthenticationService.swift
//  LandmarkRemark
//
//  Created by Danish Aziz on 20/3/21.
//

import Foundation

protocol AuthenticationServiceProvider {
    func signIn(email: String, password: String, completion: @escaping (_ isSucess: Bool,_ error: String?) -> Void)
    func signUp(userName: String, email: String, password: String, completion: @escaping (_ isSucess: Bool,_ error: String?) -> Void)
    func logout(completion: @escaping (_ isSucess: Bool,_ error: String?) -> Void)
}

class AuthenticationService: NSObject, AuthenticationServiceProvider {
  
    let firebaseAPI: FirestoreProvider
    
    init(firebaseAPI: FirestoreProvider) {
        self.firebaseAPI = firebaseAPI
    }
    
    func signIn(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        firebaseAPI.signIn(email: email, password: password) { (isSucess, error) in
            completion(isSucess, error)
        }
    }
    
    func signUp(userName: String, email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        firebaseAPI.signUp(userName: userName, email: email, password: password) { (isSucess, error) in
            completion(isSucess, error)
        }
    }
    
    func logout(completion: @escaping (Bool, String?) -> Void) {
        firebaseAPI.logout { (isSucess, error) in
            completion(isSucess, error)
        }
    }
}

