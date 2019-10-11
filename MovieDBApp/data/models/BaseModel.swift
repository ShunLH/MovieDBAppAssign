//
//  BaseModel.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/9/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import Foundation


class BaseModel {
	typealias Parameters = [String:Any]
	func responseHandler<T : Decodable>(data : Data?, urlResponse : URLResponse?, error : Error?) -> T? {
		let TAG = String(describing: T.self)
		if error != nil {
			print("\(TAG): failed to fetch data : \(error!.localizedDescription)")
			return nil
		}
		
		let response = urlResponse as! HTTPURLResponse
		
		if response.statusCode == 200 || response.statusCode == 201 {
			guard let data = data else {
				print("\(TAG): empty data")
				return nil
			}
			
			if let result = try? JSONDecoder().decode(T.self, from: data) {
				return result
			} else {
				print("\(TAG): failed to parse data")
				return nil
			}
		} else {
			print("\(TAG): Network Error - Code: \(response.statusCode)")
			return nil
			
		}
	}
	
	func getURLPostRequest(route:String,
							param:Parameters) -> URLRequest? {
		guard let url = URL(string: route) else {return nil}
		var request = URLRequest(url: url)
		request.addValue("application/json", forHTTPHeaderField: "content-type")
		request.httpMethod = "POST"
		request.httpBody = try? JSONSerialization.data(withJSONObject: param, options: [])

		return request
	}
}
