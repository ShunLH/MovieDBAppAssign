//
//  ViewController.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/2/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {
	
	@IBOutlet weak var tableViewMovieList : UITableView!
	var realm = try! Realm()
	var movieList  = [Category:Results<MovieVO>]()
	var categories : [Category] {
		return Category.allCases
		
	}
	var selectedMovieId : Int = -1
	lazy var refreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action:#selector(handleRefresh(_:)),for: .valueChanged)
		refreshControl.tintColor = UIColor.red
		return refreshControl
	}()
	
	lazy var activityIndicator : UIActivityIndicatorView = {
		let ui = UIActivityIndicatorView()
		ui.translatesAutoresizingMaskIntoConstraints = false
		ui.startAnimating()
		ui.style = UIActivityIndicatorView.Style.large
		return ui
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		tableViewMovieList.delegate = self
		tableViewMovieList.dataSource = self
		print("category \(Category.NowPlaying)")
		initGenreListFetchRequest()
		initMovieListFetchRequest()
	}
	
	fileprivate func initGenreListFetchRequest() {
		let genres = realm.objects(MovieGenreVO.self)
		if genres.isEmpty {
			MovieModel.shared.fetchMovieGenres{ genres in
				genres.forEach { [weak self] genre in
					DispatchQueue.main.async {
						MovieGenreResponse.saveMovieGenre(data: genre, realm: self!.realm)
					}
				}
			}
		}
	}
	fileprivate func initMovieListFetchRequest() {
		
		if NetworkUtils.checkReachable() == false {
			print("No Internet connection")
			
			//			Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
			return
		}
		let nowPlayingList = MovieVO.getMovieByCategory(category: Category.NowPlaying, realm: realm)
		if nowPlayingList == nil || nowPlayingList!.isEmpty {
			fetchNowPlayingMovies()
			
		}else {
			movieList[Category.NowPlaying] = nowPlayingList
		}
		let popularList = MovieVO.getMovieByCategory(category: Category.Popular, realm: realm)
		if popularList == nil || popularList!.isEmpty {
			fetchPopularMovies()
			
		}else {
			movieList[Category.Popular] = popularList
		}
		
		let topRatedList = MovieVO.getMovieByCategory(category: Category.TopRated, realm: realm)
		if topRatedList == nil || topRatedList!.isEmpty {
			fetchTopRatedMovies()
		}else {
			movieList[Category.TopRated] = topRatedList
		}
		
		let upcomingList = MovieVO.getMovieByCategory(category: Category.Upcoming, realm: realm)
		if upcomingList == nil || upcomingList!.isEmpty {
			fetchUpcomingMovies()
		}else {
			movieList[Category.Upcoming] = upcomingList
		}
		tableViewMovieList.reloadData()
	}
	
	
	fileprivate func fetchNowPlayingMovies() {
		for index in 0...2 {

			MovieModel.shared.fetchNowPlayingMovies(pageId: index) { [weak self] movies in
				DispatchQueue.main.async { [weak self] in
					movies.forEach { movie in
						MovieInfoResponse.saveMovie(data: movie, realm: self!.realm,catgory: Category.NowPlaying)

					}
					let indexPath = [IndexPath(row: 0, section: 0)]
					self?.tableViewMovieList.reloadRows(at:indexPath, with: .automatic)
					self?.activityIndicator.stopAnimating()
					self?.refreshControl.endRefreshing()
				}
				
			}
		}

	}
	
	fileprivate func fetchPopularMovies() {
		for index in 0...2 {
			MovieModel.shared.fetchPopularMovies(pageId: index) { [weak self] movies in
				DispatchQueue.main.async { [weak self] in
					
					movies.forEach{ movie in
						MovieInfoResponse.saveMovie(data: movie, realm: self!.realm,catgory: Category.Popular)
					}
					print("saving....Popular")
					let indexPath = [IndexPath(row: 0, section: 1)]
					self?.tableViewMovieList.reloadRows(at:indexPath, with: .automatic)

					self?.activityIndicator.stopAnimating()
					self?.refreshControl.endRefreshing()
				}
				
			}
		}
		movieList[Category.Popular] = MovieVO.getMovieByCategory(category: Category.Popular, realm: realm)

		
	}
	fileprivate func fetchUpcomingMovies() {
		for index in 0...2 {
			MovieModel.shared.fetchUpcomingMovies(pageId: index) { [weak self] movies in
				DispatchQueue.main.async { [weak self] in
					
					movies.forEach{ movie in
						MovieInfoResponse.saveMovie(data: movie, realm: self!.realm,catgory: Category.Upcoming)
					}
					let indexPath = [IndexPath(row: 0, section: 3)]
					self?.tableViewMovieList.reloadRows(at:indexPath, with: .automatic)

					self?.activityIndicator.stopAnimating()
					self?.refreshControl.endRefreshing()
				}
				
			}
		}
	}
	
	
	fileprivate func fetchTopRatedMovies() {
		for index in 0...2 {
			MovieModel.shared.fetchTopRatedMovies(pageId: index) { [weak self] movies in
				DispatchQueue.main.async { [weak self] in
					
					movies.forEach{ movie in
						MovieInfoResponse.saveMovie(data: movie, realm: self!.realm,catgory: Category.TopRated)
					}
					let indexPath = [IndexPath(row: 0, section: 2)]
					self?.tableViewMovieList.reloadRows(at:indexPath, with: .automatic)

					self?.activityIndicator.stopAnimating()
					self?.refreshControl.endRefreshing()
				}
				
			}
		}
	}
	
	
	@objc func handleRefresh(_ refreshControl: UIRefreshControl) {
		
		if movieList.count != 0 {
			movieList.values.forEach{ movie in
				try! realm.write {
					//					print("Deleting \(movie.original_title ?? "xxx")" )
					realm.delete(movie)
				}
			}
			
			//            self.fetchPopularMovies()
		}
		
		
	}
	
	
}

extension HomeViewController : UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return categories.count
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieListTableViewCell.identifier, for: indexPath) as? MovieListTableViewCell else {return UITableViewCell()}
		let key = categories[indexPath.section]
		let mvList = movieList[key] ?? nil
		cell.moviesList = mvList ?? nil
		cell.delegate = self
		return cell
	}
	
	
}


extension HomeViewController : UITableViewDelegate , MovieListTableViewCellDelegate{
	func showMovieDetail(movieID: Int) {
		selectedMovieId = movieID
		let storyBoard = UIStoryboard(name: "MovieDetail", bundle: nil)
		if let vc = storyBoard.instantiateViewController(withIdentifier: MovieDetailViewController.identifier) as? MovieDetailViewController {
			vc.movieId = movieID
		}
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return categories[section].rawValue
	}
}

