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
	var moviesList : Results<MovieVO>? {
		didSet {
			collectionViewMovieList.reloadData()
		}
	}
	var movieVOList : [MovieVO]? {
		didSet {
			collectionViewMovieList.reloadData()
		}
	}
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
		if let movieList = moviesList {
			return movieList.count
		}else {
			return movieVOList?.count ?? 0
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieItemCollectionViewCell.identifier, for: indexPath) as? MovieItemCollectionViewCell else { return UICollectionViewCell() }
		if let movieList = moviesList {
			cell.data = movieList[indexPath.row]
		}else {
			cell.data = movieVOList?[indexPath.row]
		}
		return cell
	}
	
	
}

extension MovieListTableViewCell : UICollectionViewDelegate{
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let movieList = moviesList {
			let movie = movieList[indexPath.row]
			delegate?.showMovieDetail(movieID: movie.id)
			print("movie Id = \(movie.id)")
			return

		}else {
			guard let movie = movieVOList?[indexPath.row] else {return}
			delegate?.showMovieDetail(movieID: movie.id)
			print("movie Id = \(movie.id)")
			return
		}
	}
		

}
//extension MovieListTableViewCell : UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = (collectionView.bounds.width / 3) - 10;
//        return CGSize(width: 120, height: 200)
//    }
//}

//	func initNofificier() {
//
//		let mvList = MovieVO.getMovieByCategory(category: .NowPlaying, realm: realm)
//
//			movieListNotifierToken = mvList?.observe{ [weak self] (changes : RealmCollectionChange) in
//				switch changes {
//				case .initial:
//					// Results are now populated and can be accessed without blocking the UI
//					self?.collectionViewMovieList.reloadData()
//					break
//				case .update(_, let deletions, let insertions, let modifications):
//					self?.collectionViewMovieList.performBatchUpdates({
//						self?.collectionViewMovieList.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0)}))
//						self?.collectionViewMovieList.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
//						self?.collectionViewMovieList.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
//					}, completion: nil)
//
//					break
//
//
//
//					break
//				case .error(let error):
//					// An error occurred while opening the Realm file on the background worker thread
//					fatalError("\(error)")
//					break;
//				}
//			}
//	}

