//
//  MovieDetailResponse.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/6/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import Foundation

struct MovieDetailResponse : Codable {
    let adult : Bool?
	let backdrop_path : String?
	let belongs_to_collection : String?
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

}
