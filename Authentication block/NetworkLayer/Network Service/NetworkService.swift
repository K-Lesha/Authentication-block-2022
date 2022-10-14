//
//  NetworkLayer.swift
//  Authentication block
//
//  Created by Алексей Коваленко on 11.10.2022.
//

import Foundation

// MARK: Protocol
protocol NetworkServiceProtocol: AnyObject {
    //MVP protocol
    var firebaseServise: FirebaseServiceProtocol! {get set}
    init(firebaseServise: FirebaseServiceProtocol)
    // METHODS
    func downloadImage(urlString: String, completionBlock: @escaping (Result<Data, NetworkError>) -> Void)
    func tryToRegister(userName: String, email: String, password: String, completion: @escaping (Result<String, FireBaseError>) -> ())
    func tryToLogIn(email: String, password: String, completion: @escaping (Result<String, FireBaseError>) -> ())
    func deleteCurrentAccount(completion: @escaping (Result<Bool, FireBaseError>) -> ())
    func logOut()
    func findNameOfUser(completion: @escaping (String) -> ())
}

// MARK: Service
//Erorrs
enum NetworkError: Error {
    case noError
    case badURL
    case downloadingFailed
    case noDataFromServer
}

//Dispatch semaphore
class AuthenticationSemaphore {
    static let shared = DispatchSemaphore(value: 0)
    private init() {}
}
//NetworkService
class NetworkService: NetworkServiceProtocol {
    //MARK: MVP protocol
    internal var firebaseServise: FirebaseServiceProtocol!
    required init(firebaseServise: FirebaseServiceProtocol) {
        self.firebaseServise = firebaseServise
    }
    
    //MARK: METHODS
    func downloadImage(urlString: String, completionBlock: @escaping (Result<Data, NetworkError>) -> Void)  {
        guard let imageUrl = URL(string: urlString) else {
            completionBlock(.failure(.badURL))
            return
        }
        
        let request = URLRequest(url: imageUrl)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionBlock(.failure(.downloadingFailed))
                return
            }
            if let imageData = data {
                completionBlock(.success(imageData))
                AuthenticationSemaphore.shared.signal()
            } else {
                completionBlock(.failure(.noDataFromServer))
                return
            }
        }.resume()
    }
    func tryToRegister(userName: String, email: String, password: String, completion: @escaping (Result<String, FireBaseError>) -> ()) {
        firebaseServise.tryToSignIn(userName: userName, email: email, password: password, completion: completion)
    }
    func tryToLogIn(email: String, password: String, completion: @escaping (Result<String, FireBaseError>) -> ()) {
        firebaseServise.tryToLogIn(email: email, password: password, completion: completion)
    }
    func deleteCurrentAccount(completion: @escaping (Result<Bool, FireBaseError>) -> ()) {
        firebaseServise.deleteCurrentAccount(completion: completion)
    }
    func logOut() {
        firebaseServise.logOut()
    }
    func findNameOfUser(completion: @escaping (String) -> ()) {
        firebaseServise.findNameOfUser(completion: completion)
    }
}

