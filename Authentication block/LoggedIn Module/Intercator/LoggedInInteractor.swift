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
    func logOutWithFirebase()
    func findUsernameWithFirebaseDatabase(completion: @escaping (String) -> ())
    func reauthenticateAndDeleteUserWithFirebase(password: String, completion: @escaping (Result<Bool, FireBaseError>) -> ())
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
    public func logOutWithFirebase() {
        firebaseService.logOutWithFirebase()
    }
    public func findUsernameWithFirebaseDatabase(completion: @escaping (String) -> ()) {
        firebaseService.findUsernameWithFirebaseDatabase(completion: completion)
    }
    public func reauthenticateAndDeleteUserWithFirebase(password: String, completion: @escaping (Result<Bool, FireBaseError>) -> ()) {
        firebaseService.reauthenticateAndDeleteUserWithFirebase(password: password, completion: completion)
    }
    public func checkUserLoginnedWithFacebook() -> Bool {
        return firebaseService.checkUserLoginnedWithFacebook()
    }
}
