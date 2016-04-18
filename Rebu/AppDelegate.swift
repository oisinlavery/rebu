//
//  AppDelegate.swift
//  Rebu
//
//  Created by Oisín Lavery on 4/7/16.
//  Copyright © 2016 Oisin Lavery. All rights reserved.
//

import UIKit
import GoogleMaps
import OAuthSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        GMSServices.provideAPIKey("AIzaSyDLoSNeZB1RgJgcHAr7LLywkJWgs6snWxo")

        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        applicationHandleOpenURL(url)
        return true
    }

    func applicationHandleOpenURL(url: NSURL) {
        if (url.host == "oauth-callback") {
            OAuthSwift.handleOpenURL(url)
        } else {
            // Google provider is the only one wuth your.bundle.id url schema.
            OAuthSwift.handleOpenURL(url)
        }
    }


}

