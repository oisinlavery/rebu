//
//  ViewController.swift
//  Rebu
//
//  Created by Oisín Lavery on 4/7/16.
//  Copyright © 2016 Oisin Lavery. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import SwiftyJSON
import Alamofire
import OAuthSwift
import Kingfisher

class ViewController: UIViewController {

    let apiUrl = "https://sandbox-api.uber.com"
    var oauthswift: OAuth2Swift!

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPhotoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.auth()
        }
        
    }
    
    func auth() {
        
        let Uber = [
            "clientId": "uk-yYtzDkOXPzFlvVr6_bvdi-gWLojPm",
            "clientSecret": "f-8lHHJVhTp65ih3_E8R5GbP2ZgoxSdOx_kqPRmi"
        ]
        
        oauthswift = OAuth2Swift(
            consumerKey:    Uber["clientId"]!,
            consumerSecret: Uber["clientSecret"]!,
            authorizeUrl:   "https://login.uber.com/oauth/authorize",
            accessTokenUrl: "https://login.uber.com/oauth/token",
            responseType:   "code",
            contentType:    "multipart/form-data"
        )
        
        let state: String = generateStateWithLength(20) as String
        
        let redirectURL = NSURL(string: "rebu://oauth")
        
        oauthswift.authorize_url_handler = SafariURLHandler(viewController: self)
        
        oauthswift.authorizeWithCallbackURL( redirectURL!, scope: "profile history all_trips", state: state, success: {
            credential, response, parameters in
            
            print("oauth_token:\(credential)")
            
            
            }, failure: {(error:NSError!) -> Void in
                print(error.localizedDescription)
        })
    }


    @IBAction func historyButtonTapped(sender: UIButton) {

        oauthswift.client.get("\(apiUrl)/v1.2/history", success: { data, response in

            let json = JSON(data: data)
            print(json)
            }
            , failure: { error in
                print(error)
        })
    }


    @IBAction func remindersButtonTapped(sender: UIButton) {

        oauthswift.client.get("\(apiUrl)/v1/reminders", success: { data, response in

            let json = JSON(data: data)
            print(json)
            }
            , failure: { error in
                print(error)
        })
    }


    @IBAction func productsButtonTapped(sender: UIButton) {

        let parameters = [
            "server_token": "36jtHeNaS1go4_uTigIyCP-KM7P6SBrTA6PaNye_",
            "latitude": "37.775818",
            "longitude": "-122.418028",
            ]

        Alamofire.request(.GET, "\(apiUrl)/v1/products", parameters: parameters).responseJSON { response in

            if let value = response.result.value {
                let json = JSON(value)
                print(json)
            }
        }
    }

    @IBAction func meButtonTapped(sender: UIButton) {

        oauthswift.client.get("\(apiUrl)/v1/me", success: { data, response in

            let json = JSON(data: data)
            print(json)

            self.userPhotoImageView.kf_setImageWithURL(NSURL(string: json["picture"].stringValue)!)

            self.userNameLabel.text = "\(json["first_name"].stringValue) \(json["last_name"].stringValue)"

        },
        failure: { error in
            print(error)
        })
    }
}


