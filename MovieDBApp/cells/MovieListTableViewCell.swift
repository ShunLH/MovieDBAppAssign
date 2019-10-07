//
//  MovieListTableViewCell.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/3/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import UIKit
import RealmSwift
protocol  MovieListTableViewCellDelegate {
	func showMovieDetail(movieID : Int)
}
class MovieListTableViewCell: UITableViewCell {
	
	@IBOutlet weak var  collectionViewMovieList : UICollectionView!
	var moviesList : Results<MovieVO>?
	var realm = try! Realm()
    private var movieListNotifierToken : NotificationToken?
	var delegate : MovieListTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		collectionViewMovieList.delegate = self
		collectionViewMovieList.dataSource = self
		
//		initNofificier()


    }
	static var identifier : String {
        return String(describing: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension MovieListTableViewCell : UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return moviesList?.count ?? 4
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieItemCollectionViewCell.identifier, for: indexPath) as? MovieItemCollectionViewCell else { return UICollectionViewCell() }
		cell.data = moviesList?[indexPath.row]
		return cell
	}
	
	
}

extension MovieListTableViewCell : UICollectionViewDelegate{
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let movie = moviesList?[indexPath.row] else {return}
		print("movie Id = \(movie.id)")
			delegate?.showMovieDetail(movieID: movie.id)
	
	}
}

