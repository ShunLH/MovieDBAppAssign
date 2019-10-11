//
//  ProfileViewController.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/9/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import UIKit
import RealmSwift
class ProfileViewController: UIViewController {
	
	@IBOutlet weak var lblName: UILabel!
	
	@IBOutlet weak var profileTableView: UITableView!
	var selectedMovieId : Int = 0
	var watchMoviesList : [MovieVO]!
	var ratedMoviesList : [MovieVO]!
	var realm = try! Realm()
	var userVO = UserVO()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		profileTableView.delegate = self
		profileTableView.dataSource = self
	
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let sessionId = UserDefaults.standard.string(forKey: DEFAULT_SESSION_ID) {
			watchMoviesList = [MovieVO]()
			ratedMoviesList = [MovieVO]()
			getAccountDetails(session_id: sessionId)
		}
	}
	
	static var identifier : String {
		return String(describing: self)
	}
	fileprivate func getAccountDetails(session_id : String) {
		LoginModel.shared.getUserDetail(success: { (response) in
			self.userVO = LoginResponse.converUserVO(user: response)
			self.fetchWatchMoviesList(session_id: session_id, account_id:self.userVO.accountId) {
				self.fetchRatedMoviesList(session_id: session_id,account_id:self.userVO.accountId) {
					DispatchQueue.main.async {
						LoginResponse.saveUserVO(user: response, ratedMovies: self.ratedMoviesList, watchMovies: self.watchMoviesList, realm: self.realm)
						self.bindData()

					}
				}
			}
			
		}) { (error) in
			print(error)
		}

	}
	fileprivate func bindData(){
		lblName.text = userVO.userName
		self.profileTableView.reloadData()
	}
	fileprivate func fetchWatchMoviesList(session_id : String,account_id : Int,completion:@escaping()->Void) {
		
		LoginModel.shared.fetchWatchMovies(session_id: session_id, accountId: account_id, completion: { [weak self] results in
			print("results count \(results.count)")
			
			if results.isEmpty {
				print("No watch movie list found!")
				return
			}else {
				results.forEach({ [weak self] (movieInfo) in
					self?.watchMoviesList.append(MovieInfoResponse.convertToMovieVO(data: movieInfo, realm: self!.realm))
				})
				print("Watch Movies\(results.count)")
			}
			completion()

		})
	}
	
	fileprivate func fetchRatedMoviesList(session_id : String,account_id : Int,completion:@escaping()->Void) {
		
		LoginModel.shared.fetchRatedMovies(session_id: session_id, accountId: account_id, completion: { [weak self] results in
			print("results count \(results.count)")
				
				
				if results.isEmpty {
					print("No rated movies list found!")
					return
				}else {
					results.forEach({ [weak self] (movieInfo) in
						self?.ratedMoviesList.append(MovieInfoResponse.convertToMovieVO(data: movieInfo, realm: self!.realm))
					})
					print("Similar Movies\(results.count)")

				}
			completion()

		})
	}
	
	@IBAction func clickOnLogout(_ sender: Any) {
		let accountId = UserDefaults.standard.integer(forKey: DEFAULT_ACCOUNT_ID)
		UserDefaults.standard.removeObject(forKey: DEFAULT_ACCOUNT_ID)
		UserDefaults.standard.removeObject(forKey: DEFAULT_SESSION_ID)
		UserDefaults.standard.removeObject(forKey: DEFAULT_REQUEST_TOKEN)

		self.tabBarController?.selectedIndex = 0

	

	}
	
}
extension ProfileViewController : UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieListTableViewCell.identifier, for: indexPath) as? MovieListTableViewCell else {return UITableViewCell()}
		switch indexPath.section {
		case 0 :
			cell.movieVOList = watchMoviesList
			break
		case 1 :
			cell.movieVOList = ratedMoviesList
			break
		default :
			break
			
		}
		cell.delegate = self
		return cell
	}
	
	
}


extension ProfileViewController : UITableViewDelegate , MovieListTableViewCellDelegate{
	func showMovieDetail(movieID: Int) {
		selectedMovieId = movieID
		performSegue(withIdentifier: "movie_detail_sb_segue", sender: self)
		
		
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0 :
			return "Watch Movies List"
		case 1 :
			return "Rated Movies List"
			
		default :
			return ""
			
		}
		
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let vc = segue.destination as? MovieDetailViewController {
			vc.movieId = selectedMovieId
		}
	}
}
