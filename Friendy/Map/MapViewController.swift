//
//  MapViewController.swift
//  Friendy
//
//  Created by Gary Chen on 30/4/2018.
//  Copyright © 2018 Gary Chen. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase

class MapViewController: UIViewController {

    
    let locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    
    lazy var mapView: GMSMapView = {
        let v = GMSMapView()
        let location: CLLocation? = v.myLocation
        
        let camera = GMSCameraPosition.camera(withLatitude: 100, longitude: 100, zoom: 17.0)
        v.camera = camera
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isMyLocationEnabled = true
        v.delegate = self
        return v
    }()
    
    lazy var searchTextField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .white
        tf.layer.borderColor = UIColor.darkGray.cgColor
        tf.placeholder = "Search for hanging-out"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        imageView.image = UIImage(named: "map-pin")
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        paddingView.addSubview(imageView)
        tf.leftView = paddingView
        return tf
    }()
    
    let myLocationButton: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.white
        btn.setImage(#imageLiteral(resourceName: "location"), for: .normal)
        btn.layer.cornerRadius = 25
        btn.clipsToBounds = true
        btn.tintColor = UIColor.gray
        btn.imageView?.tintColor=UIColor.gray
        btn.addTarget(self, action: #selector(handleMyLocation), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()

    @objc func handleMyLocation() {
        let location: CLLocation? = mapView.myLocation
        if location != nil {
            mapView.animate(toLocation: (location?.coordinate)!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "list"), style: .plain, target: self, action: #selector(pushToList))
        
        self.title = "Map"
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        setupViews()
    }

    func setupViews() {
        view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 60).isActive = true
        
        view.addSubview(searchTextField)
        searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        searchTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        searchTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true

        
        view.addSubview(myLocationButton)
        myLocationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        myLocationButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        myLocationButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        myLocationButton.heightAnchor.constraint(equalTo: myLocationButton.widthAnchor).isActive = true
    }
    
    @objc func pushToList() {
        let listViewController = ListViewController(nibName: ViewControllerConstants.LIST, bundle: nil)
        listViewController.mapTabBarController = self.tabBarController
        navigationController?.pushViewController(listViewController, animated: false)
    }

}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
        let location = locations.last
        let lat = (location?.coordinate.latitude)!
        let long = (location?.coordinate.longitude)!
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        
        self.mapView.animate(to: camera)
    }
}

extension MapViewController: GMSMapViewDelegate {

}

extension MapViewController: UITextFieldDelegate {
    
}
