//
//  EditUserViewController.swift
//  News App
//
//  Created by Ajithram on 03/03/21.
//

import UIKit

class EditUserViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.layer.cornerRadius = 12.0
        saveButton.clipsToBounds = true
        populateData()
    }

    @IBAction func didTapSaveButton(_ sender: UIButton) {
        updateUserProfiler()
    }
}

extension EditUserViewController {
    func populateData() {
        if let data = DataStore.shared.signInResponse?.data {
            firstName.text = data.first_name
            lastName.text = data.last_name
            gender.text = data.gender
            address.text = data.address
            city.text = data.city
            state.text = data.state
        }
    }
    
    func updateUserProfiler() {
        guard let url = URL(string: Constants.Url.updateUser) else {
            print("Invalid URL")
            return
        }
        let params: [String: Any] = [
            "first_name": firstName.text ?? "",
            "last_name": lastName.text ?? "",
            "gender": gender.text ?? "",
            "address": address.text ?? "",
            "city": city.text ?? "",
            "state": state.text ?? ""
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = ServiceMethod.PUT.rawValue
        do {
            let decoded = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            request.httpBody = decoded
        }
        catch {
            print(error.localizedDescription)
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let mydata = data {
                print(mydata)
            }
        }.resume()
    }
}
