//
//  AuthenticationViewModel.swift
//  LandmarkRemark
//
//  Created by Danish Aziz on 20/3/21.
//

import Foundation

class AuthenticationViewModel: NSObject {
    
    private let authenticationPresenter: AuthenticationPresenter
    let authenticationServiceProvider: AuthenticationServiceProvider = AuthenticationService(firebaseAPI: FirebaseAPI())
    
    init(authenticationPresenter: AuthenticationPresenter) {
        self.authenticationPresenter = authenticationPresenter
    }
    
    // sign In using email and password
    func signIn(email: String, password: String) {
        if !email.isEmpty && !password.isEmpty {
            MBLoader.show()
            authenticationServiceProvider.signIn(email: email, password: password) { isSucess, error in
               MBLoader.hide()
                if isSucess {
                    self.authenticationPresenter.navigateToMapView()
                } else {
                    if let error = error {
                        self.authenticationPresenter.errorAlert(error: error)
                    }
                }
            }
        } else {
            self.authenticationPresenter.errorAlert(error: "Please fill all required Fields")
        }
    }
    
    // sign up using email and password
    func signUp(userName: String, email: String, password: String) {
        if !userName.isEmpty && !email.isEmpty && !password.isEmpty {
            MBLoader.show()
            authenticationServiceProvider.signUp(userName: userName, email: email, password: password) { isSucess, error in
                MBLoader.hide()
                if isSucess {
                    self.authenticationPresenter.navigateToMapView()
                } else {
                    if let error = error {
                        self.authenticationPresenter.errorAlert(error: error)
                    }
                }
            }
        } else {
            self.authenticationPresenter.errorAlert(error: "Please fill all required Fields")
        }
    }
    
    // logout from firebase and navigate to login screen
    func logout() {
        authenticationServiceProvider.logout() { isSucess, error in
            if isSucess {
                self.authenticationPresenter.navigateToMapView()
            } else {
                if let error = error {
                    self.authenticationPresenter.errorAlert(error: error)
                }
            }
        }
    }
}
