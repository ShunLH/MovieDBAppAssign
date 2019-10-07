//
//  MovieGenreResponse.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/4/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import Foundation
struct MovieGenreListResponse: Codable {
    let genres : [MovieGenreResponse]
}
