//
//  LoginViewController.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/5/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	
	@IBOutlet weak var tfemail : UITextField!
	@IBOutlet weak var tfpassword : UITextField!
	@IBOutlet weak var btnLogin : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
		btnLogin.layer.cornerRadius = 5
		btnLogin.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
		btnLogin.layer.borderWidth = 1

        // Do any additional setup after loading the view.
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
