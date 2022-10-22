//
//  DispatchSemaphoreMain.swift
//  Authentication block
//
//  Created by Алексей Коваленко on 14.10.2022.
//

import Foundation

//MARK: Dispatch semaphore
class AuthenticationSemaphore {
    static let shared = DispatchSemaphore(value: 0)
    private init() {}
}
