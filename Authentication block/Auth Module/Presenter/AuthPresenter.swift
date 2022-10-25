//
//  StartHerePresenter.swift
//  Authentication block
//
//  Created by Алексей Коваленко on 11.10.2022.
//

import Foundation

//MARK: Protocol
protocol AuthPresenterProtocol: AnyObject {
    // VIPER protocol
    var view: AuthViewProtocol! {get set}
    var interactor: AuthInteractorProtocol! {get set}
    var router: RouterProtocol! {get set}
    init(view: AuthViewProtocol, interactor: AuthInteractorProtocol, router: RouterProtocol)
    //TEMP DATA
    var userName: String  {get set}
    var password: String  {get set}
    var email: String {get set}
    // METHODS
    func setBackgroundImage(width: CGFloat, height: CGFloat, completion: @escaping (Result<Data, NetworkError>) -> Void)
    func tryToRegisterWithFirebase(completion: @escaping (Result<String, FireBaseError>) -> ())
    func tryToLoginWithFirebase(completion: @escaping (Result<String, FireBaseError>) -> ())
    func tryToLoginWithFacebook(viewController: SignInViewProtocol, completion: @escaping (Result<String, FireBaseError>) -> ())
    func tryToLoginWithGoogle(viewController: SignInViewProtocol, completion: @escaping (Result<String, FireBaseError>) -> ())
    func checkInternetConnection() -> Bool
    func restorePasswordWithFirebase(completion: @escaping (Result<Bool, FireBaseError>) -> ())
}

//MARK: Presenter
class AuthPresenter: AuthPresenterProtocol {

    //MARK: VIPER protocol
    internal weak var view: AuthViewProtocol!
    internal weak var router: RouterProtocol!
    internal var interactor: AuthInteractorProtocol!
    
    required init(view: AuthViewProtocol, interactor: AuthInteractorProtocol, router: RouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    //MARK: TEMP DATA
    internal var userName: String = "" {
        didSet {
            print(userName)
        }
    }
    internal var password: String = "" {
        didSet {
            print(password)
        }
    }
    internal var email: String = "" {
        didSet {
            print(email)
        }
    }
    //MARK: METHODS
    internal func setBackgroundImage(width: CGFloat, height: CGFloat, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let urlString = "https://source.unsplash.com/random/\(Int(width))x\(Int(height))?sig=1"
        print("presenter, setBackgroundImage", Thread.current)
        self.interactor.downloadImage(urlString: urlString, completionBlock: completion)
    }
    internal func tryToRegisterWithFirebase(completion: @escaping (Result<String, FireBaseError>) -> ()) {
        self.interactor.tryToRegisterWithFirebase(userName: self.userName, email: self.email, password: self.password, completion: completion)
    }
    internal func tryToLoginWithFirebase(completion: @escaping (Result<String, FireBaseError>) -> ()) {
        self.interactor.tryToLogInWithFirebase(email: self.email, password: self.password, completion: completion)
    }
    internal func tryToLoginWithFacebook(viewController: SignInViewProtocol, completion: @escaping (Result<String, FireBaseError>) -> ()) {
        self.interactor.tryToLoginWithFacebook(viewController: viewController, completion: completion)
    }

    internal func checkInternetConnection() -> Bool {
        return self.interactor.checkInternetConnection()
    }
    internal func restorePasswordWithFirebase(completion: @escaping (Result<Bool, FireBaseError>) -> ()) {
        self.interactor.restorePasswordWithFirebase(email: self.email, completion: completion)
    }
    internal func tryToLoginWithGoogle(viewController: SignInViewProtocol, completion: @escaping (Result<String, FireBaseError>) -> ()) {
        interactor.tryToLoginWithGoogle(viewController: viewController, completion: completion)
    }
}
