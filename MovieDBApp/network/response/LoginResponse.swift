//
//  LoginResponse.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/4/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import Foundation
import RealmSwift
struct LoginResponse : Codable {
	
	var id : Int
	var include_adult : Bool?
	var name : String?
	var username : String?
	
	static func converUserVO(user:LoginResponse)->UserVO{
		let userVO = UserVO()
		userVO.accountId = user.id
		userVO.userName = user.username
	
		return userVO

	}
	static func saveUserVO(user:LoginResponse,ratedMovies:[MovieVO]?,watchMovies:[MovieVO]?,realm:Realm){
		let userVO = UserVO()
		userVO.accountId = user.id
				userVO.userName = user.username
		ratedMovies?.forEach({ (movie) in
			userVO.ratedMovies.append(movie)

		})
		watchMovies?.forEach({ (movie) in
			userVO.watchedMovies.append(movie)

		})
		do {
			try realm.write {
				realm.add(userVO, update: .modified)
			}
		}catch let error {
			print("Failed to save userVO \(user.name ?? "") error \(error.localizedDescription)")
		}
	}

	
}
