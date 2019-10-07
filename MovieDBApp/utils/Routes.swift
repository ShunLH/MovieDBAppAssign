//
//  Routes.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/3/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import Foundation
class Routes {
    static let ROUTE_MOVIE_GENRES = "\(API.BASE_URL)/genre/movie/list?api_key=\(API.KEY)"
    static let ROUTE_NOW_PLAYING_MOVIES = "\(API.BASE_URL)/movie/now_playing?api_key=\(API.KEY)"
    static let ROUTE_UPCOMING_MOVIES = "\(API.BASE_URL)/movie/upcoming?api_key=\(API.KEY)"
    static let ROUTE_TOP_RATED_MOVIES = "\(API.BASE_URL)/movie/top_rated?api_key=\(API.KEY)"
    static let ROUTE_POPULAR_MOVIES = "\(API.BASE_URL)/movie/popular?api_key=\(API.KEY)"
    static let ROUTE_MOVIE_DETAILS = "\(API.BASE_URL)/movie"
    static let ROUTE_SEACRH_MOVIES = "\(API.BASE_URL)/search/movie"
	static let ROUTE_REQUEST_TOKEN = "\(API.BASE_URL)/authentication/token/new?api_key=\(API.KEY)"
	static let ROUTE_CREATE_SESSION = "\(API.BASE_URL)/authentication/session/new?api_key=\(API.KEY)"
	static let ROUTE_CREATE_SESSION_LOGIN = "\(API.BASE_URL)/authentication/token/validate_with_login?=\(API.KEY)"

}
