//
//  Firebas Service.swift
//  Authentication block
//
//  Created by Алексей Коваленко on 13.10.2022.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import FBSDKLoginKit

protocol FirebaseServiceProtocol: AnyObject {
    func tryToRegister(userName: String, email: String, password: String, completion: @escaping (Result<String, FireBaseError>) -> ())
    func tryToLogIn(email: String, password: String, completion: @escaping (Result<String, FireBaseError>) -> ())
    func logOut()
    func findNameOfUser(completion: @escaping (String) -> ())
    func reauthenticateAndDeleteUser(password: String, completion: @escaping (Result<Bool, FireBaseError>) -> ())
    func tryToDeleteAccount(completion: @escaping (Result<Bool, FireBaseError>) -> ())
    func restorePassword(email: String, completion: @escaping (Result<Bool, FireBaseError>) -> ())
    func tryToLoginWithFacebook(viewController: SignInViewProtocol, completion: @escaping (Result<String, FireBaseError>) -> ())
    func checkUserLoginnedWithFacebook() -> Bool
}

enum FireBaseError: String, Error {
    case loginError
    case wrongEmail
    case registrationError
    case deletingError
    case noSuchUserFindet
    case restoringPasswordError
    case facebookLoginError
    case facebookLoginCanselled
    case firebaseWithFacebookSignInError
}
class FirebaseService: FirebaseServiceProtocol {
    
    let database = Database.database().reference().child("users")
    let firebase = Auth.auth()
    
    func tryToRegister(userName: String, email: String, password: String, completion: @escaping (Result<String, FireBaseError>) -> ()) {
        firebase.createUser(withEmail: email, password: password) { result, error in
            print("FirebaseService: tryToSignIn", Thread.current)
            if error != nil {
                completion(.failure(.registrationError))
                return
            }
            
            if let result {
                print(result.user.uid)
                self.database.child(result.user.uid).updateChildValues(["userName": userName, "email": email, "active": "yes"])
                completion(.success(result.user.uid))
            }
        }
        // in succesfull case SceneDelegate listener will change the state of app
    }
    
    func tryToLogIn(email: String, password: String, completion: @escaping (Result<String, FireBaseError>) -> ()) {
        firebase.signIn(withEmail: email, password: password) {result, error in
            guard error == nil else {
                completion(.failure(.loginError))
                return
            }
            // in succesfull case SceneDelegate listener will change the state of app
        }
    }
    func tryToLoginWithFacebook(viewController: SignInViewProtocol, completion: @escaping (Result<String, FireBaseError>) -> ()) {
        //log in with facebook
        let login = LoginManager()
        login.logIn(permissions: ["email", "public_profile"], from: viewController as? UIViewController) { result, error in
            if result?.isCancelled ?? false {
                completion(.failure(.facebookLoginCanselled))
                return
            }
            guard error == nil else {
                completion(.failure(.facebookLoginError))
                return
            }
            // facebook graph request for registrate or log in with firebase
            GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], tokenString: AccessToken.current?.tokenString, version: nil, httpMethod: HTTPMethod(rawValue: "GET")).start() { graphRequestConnecting, result, error in
                guard error == nil else {
                    completion(.failure(.facebookLoginError))
                    return
                }
                //facebook credential
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current?.tokenString ?? "")
                //firebase sign in or log in with facebook credential
                self.firebase.signIn(with: credential) { result, error in
                    guard error == nil else {
                        completion(.failure(.firebaseWithFacebookSignInError))
                        return
                    }
                    // in succesfull case SceneDelegate listener will change the app state
                    //in sucsessfull case save new user or update facebook user data to database
                    self.database.child(result?.user.uid ?? "facebookWrongID").updateChildValues(["userName": self.firebase.currentUser?.displayName ?? "facebookWrongName", "email": self.firebase.currentUser?.email ?? "facebookWrongMail", "active": "yes"])
                }
            }
        }
    }
    
    func logOut() {
        do {
            try firebase.signOut()
        } catch {
            print("can't log out")
        }
    }
    
    func findNameOfUser(completion: @escaping (String) -> ()) {
        guard let user = firebase.currentUser else {
            return
        }
        database.queryOrderedByKey().observeSingleEvent(of: .value) { snapshot in
            let usersDictionary = snapshot.value as? NSDictionary
            let userData = usersDictionary?.object(forKey: user.uid) as? NSDictionary
            let userName = userData?.object(forKey: "userName") as? String
            guard let userName else { return }
            completion(userName)
        }
    }
    func checkUserLoginnedWithFacebook() -> Bool {
        if let providerData = firebase.currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facebook.com":
                    print("FacebookLogin")
                    return true
                default:
                    return false
                }
            }
        }
        return true
    }
    
    func reauthenticateAndDeleteUser(password: String, completion: @escaping (Result<Bool, FireBaseError>) -> ()) {
        guard let email = firebase.currentUser?.email else {
            print("email, is wrong")
            return completion(.failure(.wrongEmail))
        }
        
        //password confirmation with firebase
        let user = firebase.currentUser
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        user?.reauthenticate(with: credential) { result, error in
            if error != nil {
                print("Firebase service: logging in with email: \(email) and password: \(password) is failed")
                completion (.failure(.loginError))
            }
            if result != nil {
                //deleting
                self.tryToDeleteAccount() { deletionResult in
                    switch deletionResult {
                    case .success(_):
                        break
                        // in succesfull case SceneDelegate listener will change the state of app
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func tryToDeleteAccount(completion: @escaping (Result<Bool, FireBaseError>) -> ()) {
        guard let user = firebase.currentUser else {
            completion(.failure(.noSuchUserFindet))
            return
        }
        user.delete { error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.deletingError))
            } else {
                completion(.success(true))
                self.database.child(user.uid).updateChildValues(["active": "no"])
            }
        }
    }
    func restorePassword(email: String, completion: @escaping (Result<Bool, FireBaseError>) -> ()) {
        firebase.sendPasswordReset(withEmail: email) { error in
            if error != nil {
                completion(.failure(.restoringPasswordError))
            } else {
                completion(.success(true))
            }
        }
    }
}
