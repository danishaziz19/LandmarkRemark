//
//  SearchCoordinator.swift
//  LandmarkRemark
//
//  Created by Danish Aziz on 20/3/21.
//

import UIKit

class SearchCoordinator: BaseCoordinator {

    var navigation: UINavigationController
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func start() {
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController : SearchRemarkViewController = mainStoryboard.instantiateViewController(withIdentifier: "SearchRemarkViewController") as! SearchRemarkViewController
        navigation.pushViewController(initialViewController, animated: true)
    }
}
