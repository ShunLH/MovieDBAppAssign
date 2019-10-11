//
//  YTPlayerViewController.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/8/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class YTPlayerViewController: UIViewController {
	
	@IBOutlet weak var playerView : YTPlayerView!
	var key : String?

    override func viewDidLoad() {
        super.viewDidLoad()
		print("key\(key)")
		if let key = key {
			playerView.load(withVideoId:key)

		}
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
