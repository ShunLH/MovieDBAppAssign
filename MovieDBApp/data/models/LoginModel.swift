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
	
	func requestToken() {
		let url = URL(string: Routes.ROUTE_REQUEST_TOKEN)!
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			
		let response : TokenResponse? = self.responseHandler(data: data, urlResponse: response, error: error)
			if let data = response {
				UserDefaults.setValue(data.request_token, forKey: DEFAULT_REQUEST_TOKEN)
			}
		}.resume()
	}
	
	func createSession(completion :@escaping() -> Void){
		let url = URL(string: Routes.ROUTE_CREATE_SESSION)!
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			
		}
		
	}
	
	func createSessionWithLogin(completion :@escaping() -> Void) {
		let url = URL(string: Routes.ROUTE_CREATE_SESSION_LOGIN)!
		var request = URLRequest(url: url)
		request.addValue("application/json", forHTTPHeaderField: "content-type")
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			let response : TokenResponse? = self.responseHandler(data: data, urlResponse: response, error: error)
			if let data = response {
				UserDefaults.setValue(data.request_token, forKey: DEFAULT_REQUEST_TOKEN)

			}
		}
	}
}
