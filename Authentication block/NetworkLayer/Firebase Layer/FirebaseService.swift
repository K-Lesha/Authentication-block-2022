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


protocol FirebaseServiceProtocol: AnyObject {
    func tryToSignIn(userName: String, email: String, password: String, completion: @escaping (Result<String, FireBaseError>) -> ())
    func tryToLogIn(email: String, password: String, completion: @escaping (Result<String, FireBaseError>) -> ())
    func deleteCurrentAccount(completion: @escaping (Result<Bool, FireBaseError>) -> ())
    func logOut()
    func findNameOfUser(completion: @escaping (String) -> ())
    func reauthenticateAndDeleteUser(password: String)
}

enum FireBaseError: Error {
    case loginError
    case registrationError
    case deletingError
    case noSuchUserFindet
}
class FirebaseService: FirebaseServiceProtocol {
    
    let database = Database.database().reference().child("users")
    
    func tryToSignIn(userName: String, email: String, password: String, completion: @escaping (Result<String, FireBaseError>) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
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
        // in succesfull case -> SceneDelegate {Auth.auth().addStateDidChangeListener} -> will change the state of app
    }
    
    func tryToLogIn(email: String, password: String, completion: @escaping (Result<String, FireBaseError>) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) {result, error in
            guard error == nil else {
                completion(.failure(.loginError))
                return
            }
            // in succesfull case -> SceneDelegate {Auth.auth().addStateDidChangeListener} -> will change the state of app
        }
    }

    func deleteCurrentAccount(completion: @escaping (Result<Bool, FireBaseError>) -> ()) {
        guard let user = Auth.auth().currentUser else {
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
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("can't deloggin")
        }
    }

    func findNameOfUser(completion: @escaping (String) -> ()) {
        guard let user = Auth.auth().currentUser else {return}
        database.queryOrderedByKey().observeSingleEvent(of: .value) { snapshot in
            let usersDictionary = snapshot.value as? NSDictionary
            let userData = usersDictionary?.object(forKey: user.uid) as? NSDictionary
            let userName = userData?.object(forKey: "userName") as? String
            guard let userName else { return }
            completion(userName)
        }
    }
    func reauthenticateAndDeleteUser(password: String) {
        guard let email = Auth.auth().currentUser?.email else {return}
        self.tryToLogIn(email: email, password: password) { _ in }
        self.deleteCurrentAccount() {_ in }
    }
}
