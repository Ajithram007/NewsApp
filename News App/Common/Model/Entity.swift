//
//  Entity.swift
//  News App
//
//  Created by Ajithram on 02/03/21.
//

import Foundation

struct SignInResponse: Codable {
    var result: String?
    var data: UserData?
}

struct UserData: Codable {
    var first_name: String?
    var last_name: String?
    var gender: String?
    var address: String?
    var city: String?
    var state: String?
}


struct NewsData: Codable {
    var status: String?
    var articles: [Article]
}

struct Article: Codable {
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
}



struct WeatherData: Codable {
    var timezone: String?
    var currently: CurrentWeather?
}

struct CurrentWeather: Codable {
    var time: Double?
    var temperature: Double?
}
