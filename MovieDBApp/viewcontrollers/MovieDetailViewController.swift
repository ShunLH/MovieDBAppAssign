//
//  MovieDetailViewController.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/3/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift
class MovieDetailViewController: UIViewController {
	@IBOutlet weak var ivPoster : UIImageView!
//	@IBOutlet weak var lblName : UILabel!
	@IBOutlet weak var lblAdult : UILabel!
	@IBOutlet weak var lblDuration : UILabel!
	@IBOutlet weak var lblOverview : UILabel!
	@IBOutlet weak var lblMore : UILabel!
	@IBOutlet weak var btnPlay : UIButton!
	@IBOutlet weak var collectionViewSimilarMovieList : UICollectionView!
	static var identifier : String {
		return String(describing : self)
	}
	var movieId : Int = -1
	var similarMoviesResults = [MovieInfoResponse]()
	let realm  = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
		collectionViewSimilarMovieList.delegate = self
		collectionViewSimilarMovieList.dataSource = self
        // Do any additional setup after loading the view.
		
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		fetchMovieDetails(movieId: movieId)
		fetchSimilarMovies(movieId: movieId)
	}
    

    fileprivate func fetchMovieDetails(movieId : Int) {
        
        MovieModel.shared.fetchMovieDetails(movieId: movieId) { [weak self] movieDetails in
            
            DispatchQueue.main.async {
                self?.bindData(data: movieDetails)
            }
        }
        
    }
	
	fileprivate func fetchSimilarMovies(movieId : Int) {
        
		MovieModel.shared.fetchSimilarMovies(movieId: movieId,pageId : 1) { [weak self] results in
			self?.similarMoviesResults = results
            DispatchQueue.main.async {
//				results.forEach({ [weak self] (movieInfo) in
//					MovieInfoResponse.saveMovie(data: movieInfo, realm: self!.realm,catgory: nil)
//				})
				
				if results.isEmpty {
					 print("No movie found with name \"\(movieId)\" ")
					return
				}else {
					print("Similar Movies\(results.count)")
					self?.collectionViewSimilarMovieList.reloadData()

				}
            }
        }
        
    }

	fileprivate func bindData(data : MovieDetailResponse){
		if let urlStr = data.poster_path {
			ivPoster?.sd_setImage(with: URL(string: "\(API.BASE_IMG_URL)\(urlStr)"), placeholderImage: #imageLiteral(resourceName: "icons8-movie"), completed: nil)
		}
//		lblName.text = data.original_title
		lblAdult.text = (data.adult ?? false) ? "18 +" : " "
		if let duration = data.runtime {
			let hr : Int = duration/60
			let min : Int = duration%60
			lblDuration.text = "\(hr == 0 ? "":"\(hr)") hour : \(min) min"
			lblOverview.text = data.overview
			lblMore.text = "MORE LIKE THIS"

		}
		
		
		
	}
    

}
extension MovieDetailViewController : UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return similarMoviesResults.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieItemCollectionViewCell.identifier, for: indexPath) as? MovieItemCollectionViewCell else {
			return UICollectionViewCell()
		}
		let movieVO = MovieInfoResponse.convertToMovieVO(data: similarMoviesResults[indexPath.row], realm: realm)
		cell.data = movieVO
		return cell
		
	}
	
	
}
extension MovieDetailViewController : UICollectionViewDelegate {
	
}
