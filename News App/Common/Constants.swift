//
//  Constants.swift
//  News App
//
//  Created by Ajithram on 02/03/21.
//

import Foundation

enum ServiceMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

struct Constants {
    private init() {}
    
    struct Secrets {
        static let newsApiKey = "5dd73b49cd4548189fa0e8428d55c481"
        static let weatherApiKey = "4a0e7548e486709905422f68855160d8"
    }
    struct Url {
        static let loginUrl = "https://testing.naviadoctors.com/demoapp/login/"
        static let updateUser = "https://testing.naviadoctors.com/demoapp/updateUser/"
    }
    struct Credentials {
        static let userName = "userName"         //demo@gmail.com
        static let password = "password"        //demo
    }
}
