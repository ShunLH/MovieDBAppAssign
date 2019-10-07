//
//  MovieGenreResponse.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/4/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import Foundation
import RealmSwift

struct MovieGenreResponse : Codable {
    let id : Int
    let name : String
    
    static func saveMovieGenre(data : MovieGenreResponse, realm: Realm) {
        
        //TODO: Implement Save Realm object MovieGenreVO
		let movieGenreVO = MovieGenreVO()
		movieGenreVO.id = data.id
		movieGenreVO.name = data.name
		do {
			try realm.write {
				realm.add(movieGenreVO, update: .modified)
				
			}
		}catch {
			print("Failed to save MovieGenre \(error.localizedDescription)")
		}
        
    }
}
