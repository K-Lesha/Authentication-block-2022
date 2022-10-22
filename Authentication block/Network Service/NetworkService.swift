//
//  NetworkLayer.swift
//  Authentication block
//
//  Created by Алексей Коваленко on 11.10.2022.
//

import Foundation
import SystemConfiguration

// MARK: Protocol
protocol NetworkServiceProtocol: AnyObject {
    // Methods
    func checkInternetConnection() -> Bool
    func downloadImage(urlString: String, completionBlock: @escaping (Result<Data, NetworkError>) -> Void)
}
//MARK: Network service errors
enum NetworkError: Error {
    case noError
    case badURL
    case downloadingFailed
    case noDataFromServer
}
//MARK: NetworkService
class NetworkService: NetworkServiceProtocol {
    //MARK: METHODS
    public func checkInternetConnection() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        return ret
    }
    public func downloadImage(urlString: String, completionBlock: @escaping (Result<Data, NetworkError>) -> Void)  {
        guard let imageUrl = URL(string: urlString) else {
            completionBlock(.failure(.badURL))
            return
        }
        let request = URLRequest(url: imageUrl, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 3)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionBlock(.failure(.downloadingFailed))
                AuthenticationSemaphore.shared.signal()
                return
            }
            if let imageData = data {
                AuthenticationSemaphore.shared.signal()
                completionBlock(.success(imageData))
                
            } else {
                completionBlock(.failure(.noDataFromServer))
                AuthenticationSemaphore.shared.signal()
                return
            }
        }.resume()
    }
}

