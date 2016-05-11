//
//  MainViewController.swift
//  Rebu
//
//  Created by Oisín Lavery on 5/2/16.
//  Copyright © 2016 Oisin Lavery. All rights reserved.
//

import UIKit
import RxSwift

import GoogleMaps
import Kingfisher


class MainViewController: UIViewController, CLLocationManagerDelegate {

    let disposeBag = DisposeBag()

    let uberAuth = UberAuth.sharedInstance
    let uberAPI = UberAPI.sharedInstance

    var meObservable: Observable<AnyObject>!

    let locationManager = CLLocationManager()
    let mapView = GMSMapView()
    var marker = GMSMarker()

    var authView: UIView!

    @IBOutlet var photoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        authView = Views.AuthView.getView()
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
        meObservable = uberAPI.rx_get(.Me)
    }

    func setupProfile() {
        photoImageView.backgroundColor = UIColor.redColor()
        photoImageView.layer.cornerRadius = 50
        photoImageView.clipsToBounds = true

        meObservable.subscribeNext { next in

            let imageUrlString = next["picture"] as! String
            self.photoImageView.kf_setImageWithURL(NSURL(string: imageUrlString)!)

        }
        .addDisposableTo(disposeBag)
    }

    func setupMap() {

        mapView.frame = view.bounds
        mapView.animateToZoom(10)
        view.insertSubview(mapView, atIndex: 0)

        marker.title = "My Marker"
        marker.map = mapView
    }

    func setupLocationManager() {

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let userLocation = locations[0]
//        let camera = GMSCameraUpdate.setTarget(userLocation.coordinate)

//        mapView.animateWithCameraUpdate(camera)
        marker.position = userLocation.coordinate
    }

    func showAuth() {

        let authViewController = AuthViewController()
        authViewController.modalPresentationStyle = .OverCurrentContext

        presentViewController(authViewController, animated: true, completion: nil)
    }
}
