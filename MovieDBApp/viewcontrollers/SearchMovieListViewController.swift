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
    @IBOutlet weak var lblMovieNotFound : UILabel!

	
	static var identifier : String {
		return String(describing: self)
	}
	
	lazy var activityIndicator : UIActivityIndicatorView = {
		let ui = UIActivityIndicatorView()
		ui.translatesAutoresizingMaskIntoConstraints = false
		ui.stopAnimating()
		ui.isHidden = true
		ui.style = UIActivityIndicatorView.Style.whiteLarge
		return ui
	}()
	
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
		collectionViewSearchMovieList.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
		
		self.view.addSubview(activityIndicator)
		activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
		activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
		
	}
	
}

extension SearchMovieListViewController : UISearchBarDelegate {
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		activityIndicator.startAnimating()
		let searchedMovie = searchBar.text ?? ""
		MovieModel.shared.fetchMoviesByName(movieName: searchedMovie) { [weak self] results in
			self?.searchedResult = results
			
			DispatchQueue.main.async {
				
				results.forEach({ [weak self] (movieInfo) in
					MovieInfoResponse.saveMovie(data: movieInfo, realm: self!.realm,catgory: nil)
				})
				
				if results.isEmpty {
					self?.lblMovieNotFound.text = "No movie found with name \"\(searchedMovie)\" "
					return
				}
				
				self?.lblMovieNotFound.text = ""
				self?.collectionViewSearchMovieList.reloadData()
				
				self?.activityIndicator.stopAnimating()
			}
		}
	}
}

extension SearchMovieListViewController : UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 4
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieItemCollectionViewCell.identifier, for: indexPath) as? MovieItemCollectionViewCell else {
			return UICollectionViewCell()
		}
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
