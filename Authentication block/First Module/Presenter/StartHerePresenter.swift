//
//  StartHerePresenter.swift
//  Authentication block
//
//  Created by Алексей Коваленко on 11.10.2022.
//

import Foundation

//MARK: Protocol
protocol StartHerePresenterProtocol: AnyObject {
    // MVP protocol
    var view: StartHereViewProtocol! {get set}
    var networkService: NetworkServiceProtocol! {get set}
    var router: RouterProtocol! {get set}
    init(view: StartHereViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    //TEMP DATA
    var userName: String  {get set}
    var password: String  {get set}
    var email: String {get set}
    // METHODS
    func setBackgroundImage(width: CGFloat, height: CGFloat, completion: @escaping (Result<Data, NetworkError>) -> Void)
    func tryToRegister(completion: @escaping (Result<String, FireBaseError>) -> ())
    func tryToLogin(completion: @escaping (Result<String, FireBaseError>) -> ())
    func checkInternetConnection() -> Bool
}

//MARK: Presenter
class StartHerePresenter: StartHerePresenterProtocol {

    //MARK: MVP protocol
    weak var view: StartHereViewProtocol!
    var networkService: NetworkServiceProtocol!
    var router: RouterProtocol!
    required init(view: StartHereViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
    }
    //MARK: TEMP DATA
    var userName: String = "" {
        didSet {
            print(userName)
        }
    }
    var password: String = "" {
        didSet {
            print(password)
        }
    }
    var email: String = "" {
        didSet {
            print(email)
        }
    }
    //MARK: METHODS
    func setBackgroundImage(width: CGFloat, height: CGFloat, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let urlString = "https://source.unsplash.com/random/\(Int(width))x\(Int(height))?sig=1"
        print("presenter, setBackgroundImage", Thread.current)
        self.networkService.downloadImage(urlString: urlString, completionBlock: completion)
    }
    func tryToRegister(completion: @escaping (Result<String, FireBaseError>) -> ()) {
        networkService.tryToRegister(userName: self.userName, email: self.email, password: self.password, completion: completion)
    }
    func tryToLogin(completion: @escaping (Result<String, FireBaseError>) -> ()) {
        networkService.tryToLogIn(email: self.email, password: self.password, completion: completion)
    }
    func checkInternetConnection() -> Bool {
        return networkService.checkInternetConnection()
    }
}
