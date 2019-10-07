//
//  MovieModel.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/4/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import Foundation
import RealmSwift

class MovieModel {
	static let shared = MovieModel()
	
	private init() {}
//		movie/{movie_id}/similar?api_key=<<api_key>>&language=en-US&page=1
	func fetchMoviesByName(movieName : String, completion : @escaping ([MovieInfoResponse]) -> Void) {
        let route = URL(string: "\(Routes.ROUTE_SEACRH_MOVIES)?api_key=\(API.KEY)&query=\(movieName.replacingOccurrences(of: " ", with: "%20") )")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data.results)
            }
        }.resume()
    }
	
	func fetchMovieDetails(movieId : Int, completion: @escaping (MovieDetailResponse) -> Void) {
		   let route = URL(string: "\(Routes.ROUTE_MOVIE_DETAILS)/\(movieId)?api_key=\(API.KEY)")!
		   URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
			   let response : MovieDetailResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
			   if let data = response {
				   completion(data)
			   }
		   }.resume()
	   }
	func fetchSimilarMovies(movieId : Int,pageId : Int = 1, completion : @escaping ([MovieInfoResponse]) -> Void) {
        let route = URL(string: "\(Routes.ROUTE_MOVIE_DETAILS)/\(movieId)/similar?api_key=\(API.KEY)&page=\(pageId)")!
		print("route = \(route)")
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data.results)
            }
        }.resume()
    }
	func fetchNowPlayingMovies(pageId : Int = 1, completion: @escaping(([MovieInfoResponse])->Void)){
		let route = URL(string:"\(Routes.ROUTE_NOW_PLAYING_MOVIES)&page=\(pageId)")!
		
		print("url\(Routes.ROUTE_NOW_PLAYING_MOVIES)&page=\(pageId)")
		URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
			let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
			if let data = response {
				completion(data.results)
			}else {
				completion([MovieInfoResponse]())
			}
		}.resume()
	}
	
	func fetchTopRatedMovies(pageId : Int = 1, completion : @escaping (([MovieInfoResponse]) -> Void) )  {
		let route = URL(string: "\(Routes.ROUTE_TOP_RATED_MOVIES)&page=\(pageId)")!
		URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
			let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
			if let data = response {
				//                print(data.results.count)
				completion(data.results)
				
			} else {
				completion([MovieInfoResponse]())
			}
		}.resume()
		
	}
	
	func fetchPopularMovies(pageId : Int = 1, completion : @escaping (([MovieInfoResponse]) -> Void) )  {
		let route = URL(string: "\(Routes.ROUTE_POPULAR_MOVIES)&page=\(pageId)")!
		URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
			let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
			if let data = response {
				//                print(data.results.count)
				completion(data.results)
				
			} else {
				completion([MovieInfoResponse]())
			}
		}.resume()
		
	}
	func fetchUpcomingMovies(pageId : Int = 1, completion : @escaping (([MovieInfoResponse]) -> Void) )  {
		let route = URL(string: "\(Routes.ROUTE_UPCOMING_MOVIES)&page=\(pageId)")!
		URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
			let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
			if let data = response {
				//                print(data.results.count)
				completion(data.results)
				
			} else {
				completion([MovieInfoResponse]())
			}
		}.resume()
		
	}
	
	func fetchMovieGenres(completion : @escaping([MovieGenreResponse]) -> Void){
		let route = URL(string: "\(Routes.ROUTE_MOVIE_GENRES)")!
		let task = URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieGenreListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data.genres)
            }
        }
        task.resume()
	}
	func responseHandler<T : Decodable>(data : Data?, urlResponse : URLResponse?, error : Error?) -> T? {
		let TAG = String(describing: T.self)
		if error != nil {
			print("\(TAG): failed to fetch data : \(error!.localizedDescription)")
			return nil
		}
		
		let response = urlResponse as! HTTPURLResponse
		
		if response.statusCode == 200 {
			guard let data = data else {
				print("\(TAG): empty data")
				return nil
			}
			
			if let result = try? JSONDecoder().decode(T.self, from: data) {
				return result
			} else {
				print("\(TAG): failed to parse data")
				return nil
			}
		} else {
			print("\(TAG): Network Error - Code: \(response.statusCode)")
			return nil
		}
	}
	
}
