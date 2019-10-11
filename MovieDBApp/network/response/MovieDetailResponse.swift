//
//  MovieDetailResponse.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/6/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import Foundation
import RealmSwift
struct MovieDetailResponse : Codable {
    let adult : Bool?
	let backdrop_path : String?
//	let belongs_to_collection : String?
	let budget : Int?
	let homepage : String?
	let id : Int?
	let imdb_id : String?
	let original_language : String?
	let original_title : String?
	let overview : String?
	let popularity : Double?
	let poster_path : String?
	let release_date : String?
	let revenue : Int?
	let runtime : Int?
	let status : String?
	let tagline : String?
	let title : String?
	let video : Bool?
	let vote_average : Double?
	let vote_count : Int?
	
	
	static func convertToMovieVO(data : MovieDetailResponse, realm : Realm) -> MovieVO {
        //TODO: Write Convert Logic
        let movieVO = MovieVO()
        
        movieVO.popularity = data.popularity ?? 0.0
        movieVO.vote_count = Int(data.vote_count ?? 0)
        movieVO.video = data.video ?? false
        movieVO.poster_path = data.poster_path
        movieVO.id = Int(data.id ?? 0)
        movieVO.adult = data.adult ?? false
        movieVO.backdrop_path = data.backdrop_path
        movieVO.original_language = data.original_language
        movieVO.original_title = data.original_title
        movieVO.title = data.title
        movieVO.vote_average = data.vote_average ?? 0.0
        movieVO.overview = data.overview
        movieVO.release_date = data.release_date
        movieVO.budget = Int(data.budget ?? 0)
        movieVO.homepage = data.homepage
        movieVO.imdb_id = data.imdb_id
        movieVO.revenue = Int(data.revenue ?? 0)
        movieVO.runtime = Int(data.runtime ?? 0)
        movieVO.tagline = data.tagline

        return movieVO
    }
	
	
}
