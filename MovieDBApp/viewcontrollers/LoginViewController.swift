//
//  LoginViewController.swift
//  MovieDBApp
//
//  Created by AcePlus Admin on 10/5/19.
//  Copyright © 2019 SLH. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	
	@IBOutlet weak var tfUsername : UITextField!
	@IBOutlet weak var tfpassword : UITextField!
	@IBOutlet weak var btnLogin : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
		btnLogin.layer.cornerRadius = 5
		btnLogin.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
		btnLogin.layer.borderWidth = 1
		tfUsername.delegate = self
		tfpassword.delegate = self
		tfUsername.text = "ShunLeiHmu"
		tfpassword.text = "shunlhshunlh"
		print ("subviews\(self.view.subviews.count)")
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let sessionId = UserDefaults.standard.string(forKey: DEFAULT_SESSION_ID){
			print("session id \(sessionId)")
			self.tabBarController?.selectedIndex = 1
		}
	}
	@IBAction func clickOnLogin(_ sender: Any) {
		let username = self.tfUsername.text ?? ""
		let password = self.tfpassword.text ?? ""
		if NetworkUtils.checkReachable() == false {
			print("No Internet connection")
			Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
			return
		}
		if validation(){
			showIndicatior("Loading...")
			LoginModel.shared.requestToken {(token) in
				LoginModel.shared.createSessionWithLogin(username: username, password: password, token: token, success: {
					DispatchQueue.main.async {
						self.hideIndicator()
						self.tabBarController?.selectedIndex = 1
					}

				}) { (err) in
					print(err)
				}

			}
		}else {
			Dialog.showAlert(viewController: self, title: "Required", message: "Please enter username and password.")
		}
	}
	func validation()->Bool{
		var result = true
		if tfUsername.text == "" || tfUsername.text!.isEmpty {
			result = false
		}
		
		if tfpassword.text == "" || tfpassword.text!.isEmpty {
			result = false
		}
		return result
	}

}
extension LoginViewController : UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		view.endEditing(true)
	}
}
