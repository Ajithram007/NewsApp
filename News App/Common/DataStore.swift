//
//  DataStore.swift
//  News App
//
//  Created by Ajithram on 02/03/21.
//

import Foundation

@objcMembers class DataStore: NSObject {
    static let shared = DataStore()
    
    var signInResponse: SignInResponse?
    var newsData: NewsData?

    fileprivate override init() {}
    
    override func copy() -> Any {
        fatalError("You are not allowed to use copy method on singleton!")
    }
    
    func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func getNewsApi(searchKey: String) -> String {
        return "https://newsapi.org/v2/everything?q=\(searchKey)&from=\(getCurrentDate())&to=\(getCurrentDate())&sortBy=popularity&apiKey=\(Constants.Secrets.newsApiKey)"
    }
    
    func getWeatherApi(latitude: String = "23.6672204", longitude: String = "87.65575437") -> String {
        return "https://api.darksky.net/forecast/\(Constants.Secrets.weatherApiKey)/\(latitude),\(longitude)"
    }
    
}
