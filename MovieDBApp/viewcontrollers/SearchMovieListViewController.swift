//
//  SearchMovieListViewController.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/3/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import UIKit
import RealmSwift

class SearchMovieListViewController: UIViewController {
	let searchController = UISearchController(searchResultsController: nil)
	
	@IBOutlet weak var collectionViewSearchMovieList : UICollectionView!
	
	static var identifier : String {
		return String(describing: self)
	}
	
	private var searchedResult = [MovieInfoResponse]()
	let realm  = try! Realm()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionViewSearchMovieList.delegate = self
		collectionViewSearchMovieList.dataSource = self
		initView()
		
	}
	
	fileprivate func initView() {
		// Setup the Search Controller
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Eg: Avengers"
		
		navigationItem.searchController = searchController
		navigationItem.largeTitleDisplayMode = .always
		definesPresentationContext = true
		
		// Setup the Scope Bar
		searchController.searchBar.delegate = self
		searchController.searchBar.barStyle = .black
		
		collectionViewSearchMovieList.dataSource = self
		collectionViewSearchMovieList.delegate = self
		
		
		
	}
	
}

extension SearchMovieListViewController : UISearchBarDelegate {
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		showIndicatior("Searching....")
		let searchedMovie = searchBar.text ?? ""
		MovieModel.shared.fetchMoviesByName(movieName: searchedMovie) { [weak self] results in
			self?.searchedResult = results
			
			DispatchQueue.main.async {
				if results.isEmpty {
					print("No movie found with name \"\(searchedMovie)\" ")
					Dialog.showAlert(viewController: self!, title: "No Movie", message: "No movie found with name \"\(searchedMovie)")
					self?.hideIndicator()
					return
				}
				results.forEach({ [weak self] (movieInfo) in
				
					MovieInfoResponse.saveMovie(data: movieInfo, realm: self!.realm,catgory: nil)
				})
				
				
				self?.collectionViewSearchMovieList.reloadData()
				self?.hideIndicator()
				
			}
		}
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.endEditing(true)
		self.hideIndicator()
	}
}

extension SearchMovieListViewController : UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return searchedResult.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieItemCollectionViewCell.identifier, for: indexPath) as? MovieItemCollectionViewCell else {
			return UICollectionViewCell()
		}
		let movieVO = MovieInfoResponse.convertToMovieVO(data: searchedResult[indexPath.row], realm: realm)
		cell.data = movieVO
		
		return cell
	}
	
	
}
extension SearchMovieListViewController : UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = (collectionView.bounds.width / 3) - 10;
		return CGSize(width: width, height: width * 1.45)
	}
}
extension SearchMovieListViewController : UICollectionViewDelegate {
	
}
