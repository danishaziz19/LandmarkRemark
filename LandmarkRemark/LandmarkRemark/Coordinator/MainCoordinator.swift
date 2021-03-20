//
//  MainCoordinator.swift
//  LandmarkRemark
//
//  Created by Danish Aziz on 20/3/21.
//

import UIKit
import FirebaseAuth

class MainCoordinator: BaseCoordinator {
    
    var window: UIWindow
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var initialViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
        if Auth.auth().currentUser != nil {
             initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "MapViewController") as UIViewController
        }
        
        let navigationController: UINavigationController = UINavigationController(rootViewController: initialViewController)
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
}
