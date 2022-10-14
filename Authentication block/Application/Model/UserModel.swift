//
//  UserModule.swift
//  Authentication block
//
//  Created by Алексей Коваленко on 11.10.2022.
//

import Foundation

struct UserModel: Encodable, Decodable {
    var active: Bool
    var email: String
    var userName: String
}
