//
//  LoggedInInteractor.swift
//  Authentication block
//
//  Created by Алексей Коваленко on 23.10.2022.
//

import Foundation

protocol LoggedInInteractorProtocol {
    //VIPER protocol
    var networkService: NetworkServiceProtocol! {get set}
    var firebaseService: FirebaseServiceProtocol! {get set}
    init (networkService: NetworkServiceProtocol, firebaseService: FirebaseServiceProtocol)
    //Firebase methods
    func checkUserLoginnedWithFacebook() -> Bool
    func logOut()
    func findNameOfUser(completion: @escaping (String) -> ())
    func reauthenticateAndDeleteUser(password: String, completion: @escaping (Result<Bool, FireBaseError>) -> ())
}

class LoggedInInteractor: LoggedInInteractorProtocol {
    //MARK: VIPER protocol
    internal var networkService: NetworkServiceProtocol!
    internal var firebaseService: FirebaseServiceProtocol!
    internal required init (networkService: NetworkServiceProtocol, firebaseService: FirebaseServiceProtocol) {
        self.networkService = networkService
        self.firebaseService = firebaseService
    }
    //MARK: Firebase calls
    public func logOut() {
        firebaseService.logOut()
    }
    public func findNameOfUser(completion: @escaping (String) -> ()) {
        firebaseService.findNameOfUser(completion: completion)
    }
    public func reauthenticateAndDeleteUser(password: String, completion: @escaping (Result<Bool, FireBaseError>) -> ()) {
        firebaseService.reauthenticateAndDeleteUser(password: password, completion: completion)
    }
    public func checkUserLoginnedWithFacebook() -> Bool {
        return firebaseService.checkUserLoginnedWithFacebook()
    }
}
