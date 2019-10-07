//
//  MovieVO.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/4/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import Foundation
import RealmSwift

class MovieVO : Object {
    
    @objc dynamic var popularity : Double = 0
    @objc dynamic var vote_count : Int = 0
    @objc dynamic var video : Bool = false
    @objc dynamic var poster_path : String?
    @objc dynamic var id : Int = 0
    @objc dynamic var adult : Bool = false
    @objc dynamic var backdrop_path : String?
    @objc dynamic var original_language : String?
    @objc dynamic var original_title : String?
    @objc dynamic var title : String?
    @objc dynamic var vote_average : Double = 0
    @objc dynamic var overview : String?
    @objc dynamic var release_date : String?
    @objc dynamic var budget : Int = 0
    @objc dynamic var homepage : String?
    @objc dynamic var imdb_id : String?
    @objc dynamic var revenue : Int = 0
    @objc dynamic var runtime : Int = 0
    @objc dynamic var tagline : String?
	@objc dynamic var category : String?
    var genres = List<MovieGenreVO>()
    
//	var production_companies = List<ProductionCompanyVO>()
    //Production Companies
    //TODO: Save Production Companies
    
    //TODO: Set Primary Key
	override static func primaryKey() -> String? {
		return "id"
	}

    //TODO: Set genre_ids as ignored
	
	override static func ignoredProperties() -> [String] {
		return ["genre_ids"]
	}

}


extension MovieVO {
    static func getMovieById(movieId : Int, realm : Realm) -> MovieVO? {
        //TODO: Implement realm object fetch API
//		let predicate = NSPredicate(format: "id = %@ ", movieId)
		let movies = realm.objects(MovieVO.self).filter("id == \(movieId)")
		
		return movies[0]
    }
	
	static func getMovieByCategory(category: Category,realm : Realm) -> Results<MovieVO>? {
		let movies = realm.objects(MovieVO.self).filter("category = '\(category.rawValue)'")
		return movies
	}
}
