//
//  AssemblyModuleBuilder.swift
//  Authentication block
//
//  Created by Алексей Коваленко on 11.10.2022.
//

import Foundation
import UIKit

protocol AssemblyBuilderProtocol {
    //Builder properties
    var networkService: NetworkServiceProtocol! {get set}
    var firebaseService: FirebaseServiceProtocol! {get set}
    init(networkService: NetworkServiceProtocol, firebaseService: FirebaseServiceProtocol)
    //METHODS
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createSignInViewController(router: RouterProtocol, userUID: String) -> UIViewController
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    //MARK: Builder properties
    internal var networkService: NetworkServiceProtocol!
    internal var firebaseService: FirebaseServiceProtocol!
    required init(networkService: NetworkServiceProtocol, firebaseService: FirebaseServiceProtocol) {
        self.networkService = networkService
        self.firebaseService = firebaseService
    }
    
    //MARK: METHODS
    internal func createMainModule(router: RouterProtocol) -> UIViewController {
        let view = StartHereViewController()
        let interactor = AuthInteractor(networkService: self.networkService, firebaseService: self.firebaseService)
        let presenter = AuthPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        return view
    }
    internal func createSignInViewController(router: RouterProtocol, userUID: String) -> UIViewController {
        let view = LoggedInViewController()
        let interactor = LoggedInInteractor(networkService: self.networkService, firebaseService: self.firebaseService)
        let presenter = LoggedInPresenter(view: view, interactor: interactor, router: router, userUID: userUID)
        view.presenter = presenter
        return view
    }
}
