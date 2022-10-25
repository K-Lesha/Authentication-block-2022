//
//  LoggedInPresenter.swift
//  Authentication block
//
//  Created by Алексей Коваленко on 13.10.2022.
//

import Foundation

//MARK: Protocol
protocol LoggedInPresenterProtocol: AnyObject {
    // VIPER protocol
    var view: LoggedInViewControllerProtocol! {get set}
    var interactor: LoggedInInteractorProtocol! {get set}
    var router: RouterProtocol! {get set}
    init(view: LoggedInViewControllerProtocol, interactor: LoggedInInteractorProtocol, router: RouterProtocol, userUID: String)
    //TEMP DATA
    var userName: String! {get set}
    var userUID: String! {get set}
    // METHODS
    func logOutWithFirebase()
    func reauthenticateAndDeleteUserWithFirebase(password: String, completion: @escaping (Result<Bool, FireBaseError>) -> ())
    func checkUserLoginnedWithFacebook() -> Bool
}

//MARK: Presenter
class LoggedInPresenter: LoggedInPresenterProtocol {
    //MARK: VIPER protocol
    internal weak var view: LoggedInViewControllerProtocol!
    internal weak var router: RouterProtocol!
    internal var interactor: LoggedInInteractorProtocol!
    required init(view: LoggedInViewControllerProtocol, interactor: LoggedInInteractorProtocol, router: RouterProtocol, userUID: String) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.userUID = userUID
        interactor.findUsernameWithFirebaseDatabase() { userName in
            self.userName = userName
        }
    }
    //MARK: TEMP DATA
    internal var userName: String! {
        didSet {
            view.setNewValueForUserNamelabel(newUserName: userName)
        }
    }
    internal var userUID: String!
    
    //MARK: METHODS
    public func logOutWithFirebase() {
        interactor.logOutWithFirebase()
    }
    public func reauthenticateAndDeleteUserWithFirebase(password: String, completion: @escaping (Result<Bool, FireBaseError>) -> ()) {
        interactor.reauthenticateAndDeleteUserWithFirebase(password: password, completion: completion)
    }
    public func checkUserLoginnedWithFacebook() -> Bool {
        return interactor.checkUserLoginnedWithFacebook()
    }

}
