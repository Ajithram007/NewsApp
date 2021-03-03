//
//  ViewController.swift
//  News App
//
//  Created by Ajithram on 02/03/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        initialSetUp()
    }
    
    func initialSetUp() {
        let userName = UserDefaults.standard.object(forKey: Constants.Credentials.userName) as? String
        let password = UserDefaults.standard.object(forKey: Constants.Credentials.password) as? String
        userNameField.text = userName
        passwordField.text = password
        self.view.backgroundColor = .green
        attributeSignInButton()
        createActivityIndicator()
    }
    
    func attributeSignInButton(){
        signInButton.backgroundColor = .darkGray
        signInButton.layer.cornerRadius = 10.0
        signInButton.clipsToBounds = true
    }

    @IBAction func didTapSignIn(_ sender: UIButton) {
        makeApiService()
    }
    
}

extension ViewController {
    func makeApiService() {
        guard let url = URL(string: Constants.Url.loginUrl) else {
            print("Invalid URL")
            return
        }
        let params: [String: Any] = [
            "email": userNameField.text ?? "",
            "password": passwordField.text ?? ""
        ]
        var request = URLRequest(url: url)
        request.httpMethod = ServiceMethod.POST.rawValue
        do {
            let decoded = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            request.httpBody = decoded
        }
        catch {
            print(error.localizedDescription)
        }
        startAnimating()
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let mydata = data {
                if let signInResponse = try? JSONDecoder().decode(SignInResponse.self, from: mydata){
                    DispatchQueue.main.async {
                        DataStore.shared.signInResponse = signInResponse
                        self.navigateOnSignInSuccess()
                    }
                    return
                }
                self.stopAnimating()
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }
    
    func navigateOnSignInSuccess() {
        stopAnimating()
        UserDefaults.standard.set(userNameField.text, forKey: Constants.Credentials.userName)
        UserDefaults.standard.set(passwordField.text, forKey: Constants.Credentials.password)
        self.navigationController?.pushViewController(NewsListViewController(), animated: true)
    }
}

extension ViewController {
    func createActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activityIndicator.style = .medium
        activityIndicator.center = self.view.center
        activityIndicator.isHidden = true
        self.view.addSubview(activityIndicator)
    }
    
    func startAnimating(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
    }
    
    func stopAnimating(){
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
    }
}
