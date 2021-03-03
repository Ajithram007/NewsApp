//
//  NewsItemCollectionViewCell.swift
//  News App
//
//  Created by Ajithram on 02/03/21.
//

import UIKit

class NewsItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var displayImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorName: UILabel!
    
    var articlesData: Article?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 12.0
        containerView.clipsToBounds = true
        populateData()
    }
    
    func populateData() {
        downLoadImage()
        titleLabel.text = articlesData?.title
        authorName.text = articlesData?.author
    }

}

extension NewsItemCollectionViewCell {
    func downLoadImage() {
        //Image download cache mechanism needs to be done
        guard let imageURL = URL(string: articlesData?.urlToImage ?? "") else { return }
        // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.displayImage.image = image
                print("Image download")
            }
        }
    }
}
