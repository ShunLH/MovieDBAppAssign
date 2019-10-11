//
//  MovieInfoResponse.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/4/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import Foundation
import RealmSwift

struct MovieInfoResponse : Codable {
    
    let popularity : Double?
    let vote_count : Int?
    let video : Bool?
    let poster_path : String?
    let id : Int?
    let adult : Bool?
    let backdrop_path : String?
    let original_language : String?
    let original_title : String?
    let genre_ids: [Int]?
    let title : String?
    let vote_average : Double?
    let overview : String?
    let release_date : String?
    let budget : Int?
    let homepage : String?
    let imdb_id : String?
    let revenue : Int?
    let runtime : Int?
    let tagline : String?
	let rating : Double?
    
    enum CodingKeys:String,CodingKey {
        case popularity
        case vote_count
        case video
        case poster_path
        case id
        case adult
        case backdrop_path
        case original_language
        case original_title
        case genre_ids
        case title
        case vote_average
        case overview
        case release_date
        case budget
        case homepage
        case imdb_id
        case revenue
        case runtime
        case tagline = "tagline"
		case rating
    }
    
	static func saveMovie(data : MovieInfoResponse, realm : Realm, catgory : Category?) {
        //TODO: Implement Realm Save Movie Logic
		guard let id = data.id, id > 0 else {
            print("failed to save MovieInfoResponse")
            return
        }
		
        let movieEntity = MovieVO()
        movieEntity.popularity = data.popularity ?? 0.0
        movieEntity.vote_count = Int(data.vote_count ?? 0)
        movieEntity.video = data.video ?? false
        movieEntity.poster_path = data.poster_path
        movieEntity.id = Int(data.id ?? 0)
        movieEntity.adult = data.adult ?? false
        movieEntity.backdrop_path = data.backdrop_path
        movieEntity.original_language = data.original_language
        movieEntity.original_title = data.original_title

        if let genre_ids = data.genre_ids, !genre_ids.isEmpty {
            genre_ids.forEach{ id in
				if let movieGenreVO = MovieGenreVO.getMovieGenreVOById(realm : realm, genreId: id) {
					movieEntity.genres.append(movieGenreVO)
                }
            }
        }
        movieEntity.title = data.title
        movieEntity.vote_average = data.vote_average ?? 0.0
        movieEntity.overview = data.overview
        movieEntity.release_date = data.release_date
        movieEntity.budget = Int(data.budget ?? 0)
        movieEntity.homepage = data.homepage
        movieEntity.imdb_id = data.imdb_id
        movieEntity.revenue = Int(data.revenue ?? 0)
        movieEntity.runtime = Int(data.runtime ?? 0)
        movieEntity.tagline = data.tagline
		movieEntity.rating = data.rating ?? 0.0
		if let category = catgory {
			movieEntity.category = category.rawValue
		}
		
		do {
			try realm.write {
				realm.add(movieEntity, update: .modified)
			}
		}catch {
			print("Failed to save movie info response \(error)")
		}
    }

    static func convertToMovieVO(data : MovieInfoResponse, realm : Realm) -> MovieVO {
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
		movieVO.rating = data.rating ?? 0.0
        return movieVO
    }
    
}
