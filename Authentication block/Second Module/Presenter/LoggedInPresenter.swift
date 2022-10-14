//
//  LoggedInPresenter.swift
//  Authentication block
//
//  Created by Алексей Коваленко on 13.10.2022.
//

import Foundation

//MARK: Protocol
protocol LoggedInPresenterProtocol: AnyObject {
    // MVP protocol
    var view: LoggedInViewControllerProtocol! {get set}
    var networkService: NetworkServiceProtocol! {get set}
    var router: RouterProtocol! {get set}
    init(view: LoggedInViewControllerProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, userUID: String)
    //TEMP DATA
    var userName: String! {get set}
    var userUID: String! {get set}
    // METHODS
    func deleteCurrentAccount(completion: @escaping (Result<Bool, FireBaseError>) -> ())
    func logOut()
}

//MARK: Presenter
class LoggedInPresenter: LoggedInPresenterProtocol {

    //MARK: MVP protocol
    var view: LoggedInViewControllerProtocol!
    var networkService: NetworkServiceProtocol!
    var router: RouterProtocol!
    required init(view: LoggedInViewControllerProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, userUID: String) {
        self.view = view
        self.networkService = networkService
        self.router = router
        self.userUID = userUID
        networkService.findNameOfUser() { userName in
            self.userName = userName
        }
        
    }
    //MARK: TEMP DATA
    var userName: String! {
        didSet {
            view.userNameLabel.text = "Hi " + userName
        }
    }
    var userUID: String!
    
    //MARK: METHODS
    func deleteCurrentAccount(completion: @escaping (Result<Bool, FireBaseError>) -> ()) {
        networkService.deleteCurrentAccount(completion: completion)
    }
    func logOut() {
        networkService.logOut()
    }

    

}
