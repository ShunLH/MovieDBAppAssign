//
//  SessionResponse.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/9/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import Foundation

struct SessionResponse : Codable {
	var success : Bool?
	var session_id : String
}
