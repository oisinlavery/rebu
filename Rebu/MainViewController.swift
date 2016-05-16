//
//  MainViewController.swift
//  Rebu
//
//  Created by Oisín Lavery on 5/2/16.
//  Copyright © 2016 Oisin Lavery. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

import SwiftyJSON

import GoogleMaps
import Kingfisher


class MainViewController: UIViewController, CLLocationManagerDelegate {

    let uberAuth = UberAuth.sharedInstance
    let uberAPI = UberAPI.sharedInstance

    let locationManager = CLLocationManager()

    let disposeBag = DisposeBag()
    var meObservable_: Observable<AnyObject>!

    @IBOutlet var mapView: GMSMapView!

    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var fullName: UILabel!

    @IBOutlet var currentButton: UIButton!
    @IBOutlet var requestButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        uberAuth.rx_hasToken
        .subscribeNext { hasToken in

            if hasToken {
                self.setup()
            }
            else {
                self.showAuth()
            }
        }
        .addDisposableTo(disposeBag)
    }

    func setup() {

        setupObservables()
        setupProfile()
        setupMap()
        setupLocationManager()
    }

    func setupObservables() {

//        let requestButtonTaps_ = requestButton.rx_tap
//        let currentButtonTaps_ = currentButton.rx_tap
//
//        [requestButtonTaps_, currentButtonTaps_]
//        .toObservable()
//        .merge()
//        .throttle(1, scheduler: MainScheduler.instance)
//        .subscribeNext {
//            print($0)
//            self.meObservable_.subscribeNext{ next in
//                print(next)
//            }
//            .addDisposableTo(self.disposeBag)
//        }
//        .addDisposableTo(disposeBag)


        meObservable_ = uberAPI.rx_request(.Me)

//        let observable = uberAPI.rx_get(.Places(placeId: "home"))
//        let observable = uberAPI.rx_get(
//            .Products(
//                latitude: 37.775818,
//                longitude: -122.418028
//            )
//        )

//        let observable = uberAPI.rx_post("15eaca99-a290-43f1-ad90-237d55434918")

        func getCurrentRequestId() -> Observable<String> {

            return uberAPI.rx_request(.RequestCurrent)
            .map { result in

                let json = JSON(result)
                let requestId = json["request_id"].stringValue
                print(requestId)

                return requestId
            }
        }

        func postRequest(requestId: Observable<String>){
            requestId.map { requestId in
                self.uberAPI.rx_post(requestId)
            }
            .subscribe { event in
                print(event)
            }
            .addDisposableTo(disposeBag)
        }

//        getCurrentRequestId()
//        .map {
//            print($0)
//        }
//        .subscribe { event in
////            uberAPI.rx_post(event)
//            print(event)
//        }
//        .addDisposableTo(disposeBag)

    }

    func setupProfile() {
        photoImageView.backgroundColor = UIColor.redColor()
        photoImageView.layer.cornerRadius = 32
        photoImageView.clipsToBounds = true

        meObservable_
//            .subscribe { event in
//                print(event.error != nil)
//            }
//        .map {
//            return $0["picture"] as! String
//        }
        .subscribeNext { (meDetails) in
            print(meDetails)
            self.fullName.text = "\(meDetails["first_name"]!) \(meDetails["last_name"]!)"
//            self.fullName.sizeToFit()
            self.photoImageView.kf_setImageWithURL(NSURL(string: meDetails["picture"] as! String)!)
        }
        .addDisposableTo(disposeBag)
    }

    func setupMap() {

        mapView.frame = view.bounds
        mapView.animateToZoom(10)
        view.insertSubview(mapView, atIndex: 0)
    }

    func setupLocationManager() {


            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()

//        print(CLLocationManager.locationServicesEnabled())
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        print(userLocation)
    }

    func showAuth() {

        let authViewController = AuthViewController()
        authViewController.modalPresentationStyle = .OverCurrentContext

        presentViewController(authViewController, animated: true, completion: nil)
    }
}
