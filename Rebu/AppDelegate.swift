//
//  AppDelegate.swift
//  Rebu
//
//  Created by Oisín Lavery on 4/7/16.
//  Copyright © 2016 Oisin Lavery. All rights reserved.
//

import UIKit
import GoogleMaps
import p2_OAuth2

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let uberAuth = UberAuth.sharedInstance

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        GMSServices.provideAPIKey("AIzaSyDLoSNeZB1RgJgcHAr7LLywkJWgs6snWxo")

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let mainViewController = MainViewController(nibName: "MainViewController", bundle: nil)
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()

        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {

        if (url.host == "oauth") {
            do {
                try uberAuth.oauth2.handleRedirectURL(url)
            } catch {
                print("error")
            }
        }

        return true
    }
}

