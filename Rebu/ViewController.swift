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
//import SwiftyJSON
import Alamofire
import OAuthSwift

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var mapView: GMSMapView!

//    let wordpressOauth2Settings = Oauth2Settings(
//        baseURL: "https://public-api.wordpress.com/rest/v1",
//        authorizeURL: "https://login.uber.com",
//        tokenURL: "https://public-api.wordpress.com/oauth2/token",
//        redirectURL: "alamofireoauth2://wordpress/oauth_callback",
//        clientID: "uk-yYtzDkOXPzFlvVr6_bvdi-gWLojPm",
//        clientSecret: "f-8lHHJVhTp65ih3_E8R5GbP2ZgoxSdOx_kqPRmi"
//    )

    override func viewDidLoad() {
        super.viewDidLoad()

//        let headers = [
//            "Authorization": "Token 36jtHeNaS1go4_uTigIyCP-KM7P6SBrTA6PaNye_",
//            "Content-Type": "application/json"
//        ]

//        Alamofire.request(.GET, "https://api.uber.com/v1/me", headers: headers)
//            .responseJSON { response in
//                print(response.request)  // original URL request
//                print(response.response) // URL response
//                print(response.data)     // server data
//                print(response.result)   // result of response serialization
//
//                if let JSON = response.result.value {
//                    print("JSON: \(JSON)")
//                }
//        }

//        locationManager.delegate = self
//        locationManager.startUpdatingLocation()

        mapView = GMSMapView()
        mapView.myLocationEnabled = true


//        let camera = GMSCameraPosition.cameraWithLatitude(-33.868,
//            longitude:151.2086, zoom:6)

//        mapView.camera = camera
//
//        mapView.camera
//            = GMSMapView.mapWithFrame(CGRectZero, camera:camera)

//        let marker = GMSMarker()
//        marker.position = camera.target
//        marker.snippet = "Hello World"
//        marker.appearAnimation = kGMSMarkerAnimationPop
//        marker.map = mapView

        self.view = mapView
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        print(locations)

//        let camera = GMSCameraPosition.cameraWithLatitude(-33.868,
//            longitude:151.2086, zoom:6)
    }
}

