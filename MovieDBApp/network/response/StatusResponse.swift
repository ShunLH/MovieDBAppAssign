//
//  ErrorResponse.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/9/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import Foundation

struct StatusResponse : Codable {
	
	var status_code : Int?
	var status_message : String?
}
