//
//  EditProfileViewController.swift
//  News App
//
//  Created by Ajithram on 03/03/21.
//

import UIKit

class EditProfileViewController: UIViewController {
    @IBOutlet weak var timeZone: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeWeatherApi()
        weatherView.layer.cornerRadius = 12.0
        weatherView.clipsToBounds = true
        attributeButton(homeButton)
        attributeButton(editProfileButton)
        attributeButton(logoutButton)
    }
    
    @IBAction func didTapMyHome(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapEditProfile(_ sender: UIButton) {
        print("Show edit option")
        self.present(EditUserViewController(), animated: true, completion: nil)
    }
    
    @IBAction func didTapLogOut(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension EditProfileViewController {
    func attributeButton(_ button: UIButton) {
        button.layer.cornerRadius = 12.0
        button.clipsToBounds = true
    }
    
    func updateWeatherView(_ data: WeatherData?) {
        timeZone.text = data?.timezone
        temperature.text = String(data?.currently?.temperature ?? 0)
        timeLabel.text = timeFormatter(time: data?.currently?.time)
    }
    
    func timeFormatter(time: Double?) -> String {
        let date = Date(timeIntervalSince1970: time ?? 0)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
    }
    
    func makeWeatherApi() {
        guard let url = URL(string: DataStore.shared.getWeatherApi()) else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = ServiceMethod.GET.rawValue
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let mydata = data {
                if let weatherData = try? JSONDecoder().decode(WeatherData.self, from: mydata){
                    DispatchQueue.main.async {
                        print(weatherData)
                        self.updateWeatherView(weatherData)
                    }
                    return
                }
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }
}
