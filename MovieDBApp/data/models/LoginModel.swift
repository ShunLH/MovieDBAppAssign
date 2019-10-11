//
//  LoginModel.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/4/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import Foundation

class LoginModel : BaseModel {
	
	static let shared = LoginModel()
	
	override private init () {}
	
	func fetchWatchMovies(session_id : String, accountId : Int, completion : @escaping ([MovieInfoResponse]) -> Void){
		print("accountId\(accountId)")
		let urlString = "\(API.BASE_URL)/account/\(accountId)/watchlist/movies?api_key=\(API.KEY)&session_id=\(session_id)"

		let route = URL(string: urlString)!
		print("fetchWatchMovies Route \(route)")
		
		URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
			let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
			if let data = response {
				completion(data.results)
			}
		}.resume()
	}
	
	func fetchRatedMovies(session_id : String, accountId : Int, completion : @escaping ([MovieInfoResponse]) -> Void){
		let urlString = "\(API.BASE_URL)/account/\(accountId)/rated/movies?api_key=\(API.KEY)&session_id=\(session_id)"

		let route = URL(string:urlString)!
		URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
			let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
			if let data = response {
				completion(data.results)
			}
		}.resume()
		
	}
	func addToWatchList(movieId : Int , session_id : String,account_id : Int,completion : @escaping (StatusResponse) -> Void){
		
		let route = "\(Routes.ROUTE_ACCOUNT)/\(account_id)/watchlist?api_key=\(API.KEY)&session_id=\(session_id)"
		print("add to watch list \(route)")
		let params = ["media_type":"movie","media_id":movieId,"watchlist":true] as [String : Any]
		guard let request = self.getURLPostRequest(route: route, param: params) else {return}
		URLSession.shared.dataTask(with: request) { (data, response, error) in
				let response : StatusResponse? = self.responseHandler(data: data, urlResponse: response, error: error)
				if let data = response {
					completion(data)
				}
			}.resume()
			

		
	}
	
	func addToRateMovies(movieId : Int , session_id : String,account_id : Int,completion : @escaping (StatusResponse) -> Void){
	
		let route = "\(Routes.ROUTE_MOVIE)/\(movieId)/rating?api_key=\(API.KEY)&session_id=\(session_id)"
		print("rate movie Route \(route)")
		let params = ["value":8.5] as [String : Any]
		guard let request = self.getURLPostRequest(route: route, param: params) else {return}
		URLSession.shared.dataTask(with: request) { (data, response, error) in
				let response : StatusResponse? = self.responseHandler(data: data, urlResponse: response, error: error)
				if let data = response {
					completion(data)
				}
			}.resume()
			

		
	}
	
	func requestToken(completion :@escaping(String) -> Void) {
		let url = URL(string: Routes.ROUTE_REQUEST_TOKEN)!
		print("url \(Routes.ROUTE_REQUEST_TOKEN)")
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			
			let response : TokenResponse? = self.responseHandler(data: data, urlResponse: response, error: error)
			if let data = response {
				print("request token \(data.request_token)")
				
				guard let token = data.request_token else {return}
				UserDefaults.standard.set(token, forKey: DEFAULT_REQUEST_TOKEN)
				completion(token)
			}
		}.resume()
	}
	
	func createSession(token: String,success :@escaping() -> Void,failure :@escaping(String) -> Void){
		let route = Routes.ROUTE_CREATE_SESSION
		let token = UserDefaults.standard.string(forKey: DEFAULT_REQUEST_TOKEN)
		let param = ["request_token":token]
		guard let request = self.getURLPostRequest(route: route, param: param) else {return}
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			let result : SessionResponse? = self.responseHandler(data: data, urlResponse :response , error : error)
			if let result = result {
				UserDefaults.standard.setValue(result.session_id, forKey : DEFAULT_SESSION_ID)
				success()
			}else {
				guard let data = data else {return}
				let errResponse = try? JSONDecoder().decode(StatusResponse.self, from: data)
				print(errResponse?.status_message ?? "Session create error")
				failure(errResponse?.status_message ?? "Session create error")
				return
				
			}
			
		}.resume()
	}
	
	func createSessionWithLogin(username:String,
								password:String,
								token:String,
								success :@escaping() -> Void,
								failure :@escaping(String) -> Void) {
		let route = Routes.ROUTE_CREATE_SESSION_LOGIN
		let token = UserDefaults.standard.string(forKey: DEFAULT_REQUEST_TOKEN)
		let params = ["username":username ,"password":password ,"request_token":token] 

		guard let request = getURLPostRequest(route: route, param: params) else {return}
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			let response : TokenResponse? = self.responseHandler(data: data, urlResponse: response, error: error)
			if let data = response {
				UserDefaults.standard.set(data.request_token, forKey: DEFAULT_REQUEST_TOKEN)
				self.createSession(token: data.request_token ?? "", success: {
					success()
				}) { (error) in
					print(error)
				}
				
			}else {
				guard let data = data else {return}
				let errResponse = try? JSONDecoder().decode(StatusResponse.self, from: data)
				failure(errResponse?.status_message ?? "Network Error")
				return
				
			}
			
		}.resume()
	}
	
	func getUserDetail(success :@escaping(LoginResponse) -> Void,
					   failure :@escaping(String) -> Void) {
		guard let session = UserDefaults.standard.string(forKey: DEFAULT_SESSION_ID) else {return}
		guard let route = URL(string: ("\(Routes.ROUTE_GET_DETAILS)\(session)")) else { return }

		URLSession.shared.dataTask(with: route) { (data, response, error) in
			let response : LoginResponse? = self.responseHandler(data: data, urlResponse: response, error: error)
			if let data = response {
				UserDefaults.standard.set(data.id, forKey: DEFAULT_ACCOUNT_ID)
				print("Login success\(data.username ?? "")")
					success(data)
				}
			}.resume()
	}
	
}
