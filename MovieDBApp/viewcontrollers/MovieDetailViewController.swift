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
	@IBOutlet weak var btnAddList: UIButton!
	@IBOutlet weak var btnRate: UIButton!
	@IBOutlet weak var collectionViewSimilarMovieList : UICollectionView!
	static var identifier : String {
		return String(describing : self)
	}
	var movieId : Int = -1
	var similarMoviesResults = [MovieInfoResponse]()
	let realm  = try! Realm()
	var trailerList : [Trailer]?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionViewSimilarMovieList.delegate = self
		collectionViewSimilarMovieList.dataSource = self
		// Do any additional setup after loading the view.
		
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		initView()
		fetchDetails()
	}
	func initView(){
		if let movie = MovieVO.getMovieById(movieId: movieId, realm: realm) {
			lblOverview.text = movie.overview
			ivPoster?.sd_setImage(with: URL(string: "\(API.BASE_IMG_URL)\(movie.poster_path ?? "")"), placeholderImage: #imageLiteral(resourceName: "icons8-movie"), completed: nil)
			guard let _ = UserDefaults.standard.string(forKey: DEFAULT_SESSION_ID) else {return}
			let accountId = UserDefaults.standard.integer(forKey: DEFAULT_ACCOUNT_ID)
			if let user = UserVO.getUserById(accountId: accountId, realm: realm) {
				user.watchedMovies.forEach { (watchMovie) in
					if watchMovie.id == movieId
					{
						btnAddList.isEnabled = false
					}
				}
				user.ratedMovies.forEach { (rateMovie) in
					if rateMovie.id == movieId {
						btnRate.setImage(#imageLiteral(resourceName: "icons8-thumb_up_filled"), for: .normal)
						btnRate.isEnabled = false
					}
				}
			}
		}
		
	}
	func fetchDetails(){
		if NetworkUtils.checkReachable() == false {
			print("No Internet connection")
			Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
			return
		}
		fetchMovieTrailer(movieId: movieId)
		fetchMovieDetails(movieId: movieId)
		fetchSimilarMovies(movieId: movieId)
	}
	
	fileprivate func fetchMovieTrailer(movieId : Int) {
		showIndicatior("Loading...")
		MovieModel.shared.fetchMovieVideos(movieId: movieId) { trailers in
			DispatchQueue.main.async {
				if trailers.isEmpty {
					print("NO movie trailer for movie \(movieId)")
					return
				}else {
					self.trailerList = trailers
				}
				self.hideIndicator()
				
			}
		}
	}
	
	
	fileprivate func fetchMovieDetails(movieId : Int) {
		showIndicatior("Loading...")
		MovieModel.shared.fetchMovieDetails(movieId: movieId) { [weak self] movieDetails in
			
			DispatchQueue.main.async {
				self?.hideIndicator()
				self?.bindData(data: movieDetails)
			}
		}
		
	}
	
	fileprivate func fetchSimilarMovies(movieId : Int) {
		showIndicatior("Loading...")
		MovieModel.shared.fetchSimilarMovies(movieId: movieId,pageId : 1) { [weak self] results in
			self?.similarMoviesResults = results
			DispatchQueue.main.async {
				self?.hideIndicator()
				
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
	
	@IBAction func clickOnPlayMovie(_ sender: Any) {
		if NetworkUtils.checkReachable() == false {
			print("No Internet connection")
			Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
			return
		}
		performSegue(withIdentifier: "sb-segue-ytPlayer", sender: self)
	}
	
	@IBAction func clickOnRateBtn(_ sender: UIButton) {
		
		if NetworkUtils.checkReachable() == false {
			print("No Internet connection")
			Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
			return
		}
		guard let sessionId = UserDefaults.standard.string(forKey: DEFAULT_SESSION_ID) else {
			Dialog.showAlert(viewController: self, title: "Please Enter Login", message: "")
			return
			
		}
		let accountId = UserDefaults.standard.integer(forKey: DEFAULT_ACCOUNT_ID)
		LoginModel.shared.addToRateMovies(movieId: movieId, session_id: sessionId,account_id: accountId) { (response) in
			DispatchQueue.main.async {
				self.btnRate.isEnabled = false
				Dialog.showAlert(viewController: self, title: "Rated movie", message: response.status_message ?? "")
				guard let userVO = UserVO.getUserById(accountId: accountId, realm: self.realm) else {return}
				guard let movie = MovieVO.getMovieById(movieId: self.movieId, realm: self.realm) else {return}
				MovieVO.updateMovieRating(movie: movie, rating: 8.5, realm: self.realm)
				UserVO.updateUserVO(user: userVO, movie: movie, addRated: true, addWatchList: false, realm: self.realm)
			}
			
		}
		sender.setImage(#imageLiteral(resourceName: "icons8-thumb_up_filled"), for: .normal)
		print("rated movie \(movieId)")
	}
	
	@IBAction func clickOnWatchList(_ sender: Any) {
		if NetworkUtils.checkReachable() == false {
			print("No Internet connection")
			Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
			return
		}
		guard let sessionId = UserDefaults.standard.string(forKey: DEFAULT_SESSION_ID) else {
			Dialog.showAlert(viewController: self, title: "Please Enter Login", message: "")
			return
			
		}
		let accountId = UserDefaults.standard.integer(forKey: DEFAULT_ACCOUNT_ID)
		LoginModel.shared.addToWatchList(movieId: movieId, session_id: sessionId,account_id: accountId) { (response) in
			DispatchQueue.main.async {
				self.btnAddList.isEnabled = false
				Dialog.showAlert(viewController: self, title: "Added to watch list", message: response.status_message ?? "")
				guard let userVO = UserVO.getUserById(accountId: accountId, realm: self.realm) else {return}
				guard let movie = MovieVO.getMovieById(movieId: self.movieId, realm: self.realm) else {return}
				UserVO.updateUserVO(user: userVO, movie: movie, addRated: false, addWatchList: true, realm: self.realm)
			}
			
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
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let desVC = segue.destination as? YTPlayerViewController {
			desVC.key = trailerList?[0].key
		}
	}
	
	
}
extension MovieDetailViewController : UICollectionViewDelegate {
	
//	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//		let movieVO = MovieInfoResponse.convertToMovieVO(data: similarMoviesResults[indexPath.row], realm: realm)
//
//		self.movieId = movieVO.id
//		self.viewWillAppear(true)
//
//	}
	
}
