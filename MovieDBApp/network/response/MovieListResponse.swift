//
//  MovieListResponse.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/4/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import Foundation

struct MovieListResponse : Codable {
    let page : Int
    let total_results : Int
    let total_pages : Int
    let results : [MovieInfoResponse]
}
