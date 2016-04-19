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
        
        oauthswift.authorizeWithCallbackURL( redirectURL!, scope: "profile", state: state, success: {
            credential, response, parameters in
            
            print("oauth_token:\(credential)")
            
            
            }, failure: {(error:NSError!) -> Void in
                print(error.localizedDescription)
        })
    }
    
    func getMe() {
        
        
        oauthswift.client.get("https://api.uber.com/v1/me",
          success: {
            data, response in
            
            let json = JSON(data: data)
            print(json)
            
            self.userPhotoImageView.kf_setImageWithURL(NSURL(string: json["picture"].stringValue)!)
            
            self.userNameLabel.text = "\(json["first_name"].stringValue) \(json["last_name"].stringValue)"
            
            }
            , failure: { error in
                print(error)
            }
        )
    }
    
    
    func getProducts() {
        
        let parameters = [
            "server_token": "36jtHeNaS1go4_uTigIyCP-KM7P6SBrTA6PaNye_",
            "latitude": "37.775818",
            "longitude": "-122.418028",
            ]
        
        Alamofire.request(.GET, "https://api.uber.com/v1/products", parameters: parameters).responseJSON { response in
            
//            print(response.request)  // original URL request
//            print(response.response) // URL response
//            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
    }
    @IBAction func getProductsButtonTapped(sender: UIButton) {
        getProducts()
    }
    @IBAction func getMeButtonTapped(sender: UIButton) {
        getMe()
    }
}


//let headers = [
//    "Authorization": "Token \(credential.oauth_token)",
//    "Content-Type": "application/json"
//]
//
//Alamofire.request(.GET, "https://api.uber.com/v1/me", headers: headers).responseJSON { response in
//    
//    print(response.request)  // original URL request
//    print(response.response) // URL response
//    print(response.data)     // server data
//    print(response.result)   // result of response serialization
//    
//    if let JSON = response.result.value {
//        print("JSON: \(JSON)")
//    }
//}
//


