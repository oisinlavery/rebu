//
//  AuthViewController.swift
//  Rebu
//
//  Created by Oisín Lavery on 5/2/16.
//  Copyright © 2016 Oisin Lavery. All rights reserved.
//

import UIKit
import RxSwift

class AuthViewController: UIViewController {

    let disposeBag = DisposeBag()
    let uberAuth = UberAuth.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func authenticateButtonTapped(sender: UIButton) {

        uberAuth.authorize()

        uberAuth.rx_auth
        .subscribeNext { oauth2 in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        .addDisposableTo(disposeBag)
    }
}
