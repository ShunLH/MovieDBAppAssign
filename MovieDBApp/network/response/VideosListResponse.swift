//
//  VideosListResponse.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/8/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import Foundation

struct VideoListResponse : Codable {
	var id : Int
	var results : [Trailer]
}
