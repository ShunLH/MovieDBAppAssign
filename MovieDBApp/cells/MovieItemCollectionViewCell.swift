//
//  MovieItemCollectionViewCell.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/3/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import UIKit
import SDWebImage


class MovieItemCollectionViewCell: UICollectionViewCell {

   
    @IBOutlet weak var imageViewMoviePoster : UIImageView!
    
    var data : MovieVO? {
        didSet {
            if let data = data {
                
                imageViewMoviePoster.sd_setImage(with: URL(string: "\(API.BASE_IMG_URL)\(data.poster_path ?? "")"), placeholderImage: #imageLiteral(resourceName: "icons8-movie"), options:  SDWebImageOptions.progressiveLoad, completed: nil)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
	static var identifier : String {
        return String(describing: self)
    }

}
