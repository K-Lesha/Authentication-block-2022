//
//  AuthInteractor.swift
//  Authentication block
//
//  Created by Алексей Коваленко on 23.10.2022.
//

import Foundation

protocol AuthInteractorProtocol {
    //VIPER protocol
    var networkService: NetworkServiceProtocol! {get set}
    var firebaseService: FirebaseServiceProtocol! {get set}
    init (networkService: NetworkServiceProtocol, firebaseService: FirebaseServiceProtocol)
    //Network methods
    func checkInternetConnection() -> Bool
    func downloadImage(urlString: String, completionBlock: @escaping (Result<Data, NetworkError>) -> Void)
    // Firebase methods
    func tryToRegister(userName: String, email: String, password: String, completion: @escaping (Result<String, FireBaseError>) -> ())
    func tryToLogIn(email: String, password: String, completion: @escaping (Result<String, FireBaseError>) -> ())
    func tryToLoginWithFacebook(viewController: SignInViewProtocol, completion: @escaping (Result<String, FireBaseError>) -> ())
    func tryToLoginWithGoogle(viewController: SignInViewProtocol, completion: @escaping (Result<String, FireBaseError>) -> ())
    func restorePassword(email: String, completion: @escaping (Result<Bool, FireBaseError>) -> ())
}

class AuthInteractor: AuthInteractorProtocol {

    //MARK: VIPER protocol
    internal var networkService: NetworkServiceProtocol!
    internal var firebaseService: FirebaseServiceProtocol!
    internal required init (networkService: NetworkServiceProtocol, firebaseService: FirebaseServiceProtocol) {
        self.networkService = networkService
        self.firebaseService = firebaseService
    }
    //MARK: Network methods
    internal func checkInternetConnection() -> Bool {
        networkService.checkInternetConnection()
    }
    internal func downloadImage(urlString: String, completionBlock: @escaping (Result<Data, NetworkError>) -> Void) {
        networkService.downloadImage(urlString: urlString, completionBlock: completionBlock)
    }
    //MARK: Firebase calls
    internal func tryToRegister(userName: String, email: String, password: String, completion: @escaping (Result<String, FireBaseError>) -> ()) {
        firebaseService.tryToRegister(userName: userName, email: email, password: password, completion: completion)
    }
    internal func tryToLogIn(email: String, password: String, completion: @escaping (Result<String, FireBaseError>) -> ()) {
        firebaseService.tryToLogIn(email: email, password: password, completion: completion)
    }
    internal func tryToLoginWithFacebook(viewController: SignInViewProtocol, completion: @escaping (Result<String, FireBaseError>) -> ()) {
        firebaseService.tryToLoginWithFacebook(viewController: viewController, completion: completion)
    }
    internal func restorePassword(email: String, completion: @escaping (Result<Bool, FireBaseError>) -> ()) {
        firebaseService.restorePassword(email: email, completion: completion)
    }
    internal func tryToLoginWithGoogle(viewController: SignInViewProtocol, completion: @escaping (Result<String, FireBaseError>) -> ()) {
        firebaseService.tryToLoginWithGoogle(viewController: viewController, completion: completion)
    }

}
