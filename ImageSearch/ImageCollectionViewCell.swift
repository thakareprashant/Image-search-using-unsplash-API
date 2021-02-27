//
//  ImageCollectionViewCell.swift
//  ImageSearch
//
//  Created by prashant thakare on 22/02/21.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
     
    static let identifier = "ImageCollectionViewCell"
    
    
    
    private let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    func config(with urlString:String){
        
        guard let url = URL(string: urlString)else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, resp, error) in
            guard let data = data , error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.imageView.image = image
            }
        }
        task.resume()
    }
}
