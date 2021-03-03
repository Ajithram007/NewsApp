//
//  NewsListViewController.swift
//  News App
//
//  Created by Ajithram on 02/03/21.
//

import UIKit
class NewsListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var baseCollectionView: UICollectionView!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    var data: NewsData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createActivityIndicator()
        initialSetup()
        makeSearchApi(searchKey: "Movies")
    }
    
    func initialSetup() {
        baseCollectionView.delegate = self
        baseCollectionView.dataSource = self
        self.baseCollectionView.backgroundColor = .lightGray
        registerCells()
        createEditButton()
    }
    
    func registerCells() {
        baseCollectionView.register(UINib(nibName: "NewsItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewsItemCollectionViewCell")
    }
    
    func createEditButton() {
        let editButton = UIButton()
        editButton.frame = CGRect(x:0, y:0, width:70, height:30)
        editButton.setTitleColor(.red, for: .normal)
        editButton.setTitle("Edit", for: .normal)

        editButton.addTarget(self, action: #selector(didTapEditButtonButton), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editButton)
    }
    
    @objc func didTapEditButtonButton() {
        let editView = EditProfileViewController()
        editView.modalPresentationStyle = .fullScreen
        self.present(editView, animated: true, completion: nil)
        
    }
    
    @IBAction func didTapSearchButton(_ sender: UIButton) {
        makeSearchApi(searchKey: searchTextField.text)
    }
    
}

extension NewsListViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data?.articles.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsItemCollectionViewCell", for: indexPath as IndexPath) as? NewsItemCollectionViewCell {
            cell.articlesData = data?.articles[indexPath.row]
            cell.populateData()
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? NewsItemCollectionViewCell {
            let customWebview = CustomWkwebViewController()
            customWebview.loadUrl = cell.articlesData?.url
            self.navigationController?.present(customWebview, animated: true, completion: nil)
        }
    }
}

extension NewsListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (UIScreen.main.bounds.width/2) - 8
        return CGSize(width: cellWidth, height: 250)
    }
}


extension NewsListViewController {
    func makeSearchApi(searchKey: String? = "") {
        guard let url = URL(string: DataStore.shared.getNewsApi(searchKey: searchKey ?? "")) else {
            print("Invalid URL")
            return
        }
        self.startAnimating()
        var request = URLRequest(url: url)
        request.httpMethod = ServiceMethod.GET.rawValue
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let mydata = data {
                if let newsData = try? JSONDecoder().decode(NewsData.self, from: mydata){
                    DispatchQueue.main.async {
                        DataStore.shared.newsData = newsData
                        self.data = DataStore.shared.newsData
                        self.baseCollectionView.reloadData()
                        self.stopAnimating()
                    }
                    return
                }
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                self.stopAnimating()
            }
        }.resume()
    }
}

extension NewsListViewController {
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
        baseCollectionView.isUserInteractionEnabled = false
    }
    
    func stopAnimating(){
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        baseCollectionView.isUserInteractionEnabled = true
    }
}
