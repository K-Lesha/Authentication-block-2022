//
//  Router.swift
//  Authentication block
//
//  Created by Алексей Коваленко on 11.10.2022.
//

import Foundation
import UIKit


protocol RouterProtocol {
    //MVP protocol
    var navigationController: UINavigationController! { get set }
    var assemblyBuilder: AssemblyBuilderProtocol! { get set }
    var networkService: NetworkServiceProtocol! {get set}
    //METHODS
    func showFirstModule()
    func showSecondModule(userUID: String)
    func popToRoot()
}

class Router: RouterProtocol {
    //MARK: Protocol
    var navigationController: UINavigationController!
    var assemblyBuilder: AssemblyBuilderProtocol!
    var networkService: NetworkServiceProtocol! 
    //MARK: INIT
    init (navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol, networkService: NetworkServiceProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
        self.networkService = networkService
    }
    //MARK: METHODS
    func showFirstModule() {
        if let navigationController = navigationController {
            guard let startHereViewController = assemblyBuilder?.createMainModule(router: self) else { return }
            navigationController.viewControllers = [startHereViewController]
        }
    }
    func showSecondModule(userUID: String) {
        if let navigationController = navigationController {
            guard let loggedInViewController = assemblyBuilder?.createSignInViewController(router: self, userUID: userUID) else { return }
            navigationController.viewControllers = [loggedInViewController]
        }
    }
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
