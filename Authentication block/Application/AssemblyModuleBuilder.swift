//
//  AssemblyModuleBuilder.swift
//  Authentication block
//
//  Created by Алексей Коваленко on 11.10.2022.
//

import Foundation
import UIKit

protocol AssemblyBuilderProtocol {
    //METHODS
     func createMainModule(router: RouterProtocol) -> UIViewController
     func createSignInViewController(router: RouterProtocol, userUID: String) -> UIViewController
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    
    //MARK: METHODS
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let view = StartHereViewController()
        let presenter = StartHerePresenter(view: view, networkService: router.networkService, router: router)
        view.presenter = presenter
        return view
    }
    func createSignInViewController(router: RouterProtocol, userUID: String) -> UIViewController {
        let view = LoggedInViewController()
        let presenter = LoggedInPresenter(view: view, networkService: router.networkService, router: router, userUID: userUID)
        view.presenter = presenter
        return view
    }
}
