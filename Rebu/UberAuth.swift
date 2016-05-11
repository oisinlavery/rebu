//
//  UberAPI.swift
//  Rebu
//
//  Created by Oisín Lavery on 5/3/16.
//  Copyright © 2016 Oisin Lavery. All rights reserved.
//

import Foundation
import p2_OAuth2
import RxSwift

public class UberAuth {

    static let sharedInstance = UberAuth()

    let apiUrl = "https://sandbox-api.uber.com"

    let settings: OAuth2JSON = [
        "client_id": "uk-yYtzDkOXPzFlvVr6_bvdi-gWLojPm",
        "client_secret": "f-8lHHJVhTp65ih3_E8R5GbP2ZgoxSdOx_kqPRmi",
        "authorize_uri": "https://login.uber.com/oauth/authorize",
        "token_uri": "https://login.uber.com/oauth/token",
        "scope": "profile history all_trips request",
        "redirect_uris": ["rebu://oauth"],
        "keychain": true
    ]

    var oauth2: OAuth2!

//    var hasToken: Bool {
//        return oauth2.hasUnexpiredAccessToken()
//    }

    var rx_hasToken: Observable<Bool>!
    var rx_auth: Observable<OAuth2>!

    private init() {
        oauth2 = OAuth2CodeGrant(settings: settings)

//        Remove tokens for auth testing
//        oauth2.forgetTokens()

        setupRx()
    }

    func setupRx() {

        rx_hasToken = Observable.just(oauth2.hasUnexpiredAccessToken())

        rx_auth = Observable.create({ observer in

            self.oauth2.onAuthorize = { _ in
                observer.onNext(self.oauth2)
                observer.onCompleted()
            }
            self.oauth2.onFailure = { error in
                if let error = error {
                    print("Authorization went wrong: \(error)")
                    observer.onError(error)
                }
            }

            return AnonymousDisposable {
                self.oauth2.abortAuthorization()
            }
        })
    }

    func authorize() {
        oauth2.authorize()
    }
}





