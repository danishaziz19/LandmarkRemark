//
//  LoginViewController.swift
//  LandmarkRemark
//
//  Created by Danish Aziz on 20/3/21.
//

import UIKit

protocol AuthenticationPresenter {
    func errorAlert(error: String)
    func navigateToMapView()
}

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    lazy var authenticationViewModel: AuthenticationViewModel = AuthenticationViewModel(authenticationPresenter: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    // setup delegates
    func setup() {
        self.title = "Sign In"
        self.txtEmail.delegate = self
        self.txtPassword.delegate = self
    }
    
    @IBAction func signInPress(_ sender: UIButton) {
        if let email = txtEmail.text, let password = txtPassword.text {
            authenticationViewModel.signIn(email: email, password: password)
        }
    }
    
    // text field delegate when press return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension LoginViewController: AuthenticationPresenter {
    func errorAlert(error: String) {
        let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func navigateToMapView() {
        if let window = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
            .filter({$0.isKeyWindow}).first {
            let mainCoordinator: MainCoordinator = MainCoordinator(window: window)
            mainCoordinator.start()
        }
    }
}
