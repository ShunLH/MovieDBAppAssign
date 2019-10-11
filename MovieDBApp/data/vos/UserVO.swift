//
//  UserVO.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/10/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import Foundation
import RealmSwift

class UserVO : Object {
	
	@objc dynamic var accountId : Int = 0
    @objc dynamic var userName : String?
    var ratedMovies = List<MovieVO>()
	var watchedMovies = List<MovieVO>()
	
	override static func primaryKey() -> String? {
        return "accountId"
    }
	
	static func getUserById(accountId : Int, realm : Realm) -> UserVO? {
			//TODO: Implement realm object fetch API
	//		let predicate = NSPredicate(format: "id = %@ ", movieId)
			let movies = realm.objects(UserVO.self).filter("accountId == \(accountId)")
			
			return movies[0]
	}
	static func updateUserVO(user:UserVO,movie:MovieVO,addRated:Bool,addWatchList:Bool,realm:Realm){
		do {
			try realm.write {
				if addRated{
				user.ratedMovies.append(movie)
				}
				if addWatchList {
				user.watchedMovies.append(movie)
				}
			}
		}catch {
			print("Failed to update User Rated movies \(error)")
		}
		
	}
	
	
}
