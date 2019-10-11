//
//  TokenResponse.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/9/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import Foundation

struct TokenResponse : Codable {
	var success : Bool?
	var expires_at : String?
	var request_token : String?
}
