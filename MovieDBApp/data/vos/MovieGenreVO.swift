//
//  MovieGenreVO.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/4/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import Foundation
import RealmSwift

class MovieGenreVO : Object {
    @objc dynamic var id : Int = 0
    @objc dynamic var name : String = ""
    let movies = LinkingObjects(fromType: MovieVO.self, property: "genres")
    
    
    //TODO: Set "id" as primary key
	override static func primaryKey() -> String? {
		return "id"
	}

    
}


extension MovieGenreVO {
    static func getMovieGenreVOById(realm : Realm, genreId : Int) -> MovieGenreVO? {
        //TODO: Implement Realm Fetch Request for MovieGenreVO by genreID
//		let predicate = NSPredicate(format: "id ==\(genreId)")
		let movies = realm.objects(MovieGenreVO.self).filter("id ==\(genreId)")
		
		return movies[0]
    }
}

