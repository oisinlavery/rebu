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

        // Do any additional setup after loading the view.
    }


    @IBAction func authenticateButtonTapped(sender: UIButton) {

        uberAuth.authorize()

        uberAuth.rx_auth
        .subscribeNext { oauth2 in
            print(oauth2.hasUnexpiredAccessToken())
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        .addDisposableTo(disposeBag)

//        uberAuth.oauth2.authorize()
//        uberAuth.oauth2.onAuthorize = { parameters in
//            print("Did authorize with parameters: \(parameters)")
//
//            self.dismissViewControllerAnimated(true, completion: nil)
//        }
    }

    @IBAction func closeButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
