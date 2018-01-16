//                           Name: Hera Siddiqui
//                           
//  Tested in iPhone 7
//  For the difficult parts took ideas from the net
//  MapViewController.swift
//  Assignment4
//
//  Created by Admin on 10/13/17.
//  Copyright © 2017 Hera Siddiqui. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate  {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000
    let initialLocation = CLLocation(latitude: 32.715736, longitude:-117.161087 )
    
    @IBOutlet weak var exitContainer: UIView!
    @IBOutlet weak var locationsContainer: UIView!
    @IBOutlet weak var sourceTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    
    var user:CLLocation?
    var start:CLLocationCoordinate2D?
    let geoCoder = CLGeocoder()
    let request = MKDirectionsRequest()
    var source = ""
    var destination = ""
    var sourceMapItem:MKMapItem?
    var destinationMapItem:MKMapItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationsContainer.isHidden = true
        exitContainer.isHidden = true
        centerMapOnLocation(location: initialLocation)
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        configureLocationServices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureLocationServices()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    /*************** centers initial ie San Diego on map******************/
    func centerMapOnLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(1,1)
        let coordinateRegion = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    /************* Fun to set User in center *************/
    func centerMapOnUserLocation() {
        guard let userCoordinate = locationManager.location?.coordinate else {
            return
        }
        user = locationManager.location
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(userCoordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    /*******************calls func centermaponuser when authorization changes**************************/
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerMapOnUserLocation()
    }
    /******************** grabs the latest location*****************************/
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
        }
        
    }
    /********************* If error in finding location *************************/
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func configureLocationServices(){
        if (authorizationStatus == .notDetermined || authorizationStatus == .restricted || authorizationStatus == .denied){
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        else {
            return
        }
    }
    /*******************  centers user otherwise alerts that location not enabled ************/
    @IBAction func centerUserPosition(_ sender: UIButton) {
        if CLLocationManager.locationServicesEnabled() {
            centerMapOnUserLocation()
        }
        else {
            print("not enabled")
            let alert = UIAlertController(title: "Location Services Disabled", message: "You can turn on location services in settings", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(yesAction)
            present(alert, animated: true, completion: nil)
        }
    }
    /************************* when Directions button is pressed *************************/
    @IBAction func directionsBetweenTwoLocations(_ sender: UIButton) {
        locationsContainer.isHidden = false
        locationsContainer.backgroundColor = .cyan
        if (authorizationStatus == .authorizedWhenInUse) {
            guard let user = locationManager.location else {
                return
            }
            geoCoder.reverseGeocodeLocation(user, completionHandler: {(placemarks,error) in
                if (error != nil){
                    // alert that ad
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let placemark = placemarks! as [CLPlacemark]
                if placemark.count > 0 {
                    let placemark = placemarks![0]
                    var addressString : String = ""
                    if placemark.subLocality != nil {
                        addressString = addressString + placemark.subLocality! + ", "
                    }
                    if placemark.thoroughfare != nil {
                        addressString = addressString + placemark.thoroughfare! + ", "
                    }
                    if placemark.locality != nil {
                        addressString = addressString + placemark.locality! + ", "
                    }
                    if placemark.country != nil {
                        addressString = addressString + placemark.country! + ", "
                    }
                    if placemark.postalCode != nil {
                        addressString = addressString + placemark.postalCode! + " "
                    }
                    self.sourceTextField.text = addressString
                }
            })
            destinationTextField.becomeFirstResponder()
        }
    }
    
    /************************** Finding directions between locations **************************/
    @IBAction func directionsBetweenUserEntered(_ sender: UIButton) {
        hideKeyboard()
        if (sourceTextField.text?.isEmpty)!{
            let alert = UIAlertController(title: "Source Not Entered", message: "Enter an address in source field", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(yesAction)
            present(alert, animated: true, completion: nil)
            sourceTextField.becomeFirstResponder()
        }
        else if (destinationTextField.text?.isEmpty)!{
            let alert = UIAlertController(title: "Destination Not Entered", message: "Enter an address in destination field", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(yesAction)
            present(alert, animated: true, completion: nil)
            destinationTextField.becomeFirstResponder()
        }
        else {
            source = sourceTextField.text!
            destination = destinationTextField.text!
            forwardGeocoding(address: source,completion: {success, coordinate in
                if success {
                    self.destination = self.destinationTextField.text!
                    let sourceGeocoded = coordinate
                    self.start = coordinate
                    let sourcePlacemark = MKPlacemark(coordinate: sourceGeocoded!)
                    self.sourceMapItem = MKMapItem(placemark: sourcePlacemark)
                    
                    self.forwardGeocoding(address: self.destinationTextField.text!,completion: {success, coordinate1 in
                        if success {
                            let destinationGeocoded = coordinate1
                            // Do sth with your coordinates
                            let destinationPlacemark = MKPlacemark(coordinate: destinationGeocoded!)
                            self.destinationMapItem = MKMapItem(placemark: destinationPlacemark)
                            self.request.source = self.sourceMapItem
                            self.request.destination = self.destinationMapItem
                            self.request.requestsAlternateRoutes = false
                            let directions = MKDirections(request: self.request)
                            directions.calculate(completionHandler: {(response, error) in
                                if error != nil {
                                    let alert = UIAlertController(title: "Could not find directions", message: "Could not find directions for given locations", preferredStyle: .alert)
                                    let yesAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                    alert.addAction(yesAction)
                                    self.present(alert, animated: true, completion: nil)
                                    print("Error getting directions: \(error!.localizedDescription)")
                                } else {
                                    self.showRoute(response!)
                                }
                            })
                        } else {
                            let alert = UIAlertController(title: "Destination does not Exist", message: "Enter a valid address in destination field", preferredStyle: .alert)
                            let yesAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alert.addAction(yesAction)
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                    
                    // Do sth with your coordinates
                }  else {
                    let alert = UIAlertController(title: "Source does not Exist", message: "Enter a valid address in source field", preferredStyle: .alert)
                    let yesAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(yesAction)
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    /***************** cancel button is pressed *********************************/
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        hideKeyboard()
        locationsContainer.isHidden = true
        exitButtonPressed(sender)
    }
    /****************************** function for route *************************/
    func showRoute(_ response: MKDirectionsResponse) {
        locationsContainer.isHidden = true
        exitContainer.isHidden = false
        for route in response.routes {
            mapView.add(route.polyline,level: MKOverlayLevel.aboveRoads)
           /* for step in route.steps {
                print(step.instructions)
                print(step.distance)
            }*/
        }
        let region = MKCoordinateRegionMakeWithDistance(start!,2000, 2000)
        mapView.setRegion(region, animated: true)
    }
    /******************** func for overlays **********************/
    func mapView(_ mapView: MKMapView, rendererFor
        overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }
    /*********************** getting coordinates from user entered address ******************/
    func forwardGeocoding (address: String, completion: @escaping (Bool, CLLocationCoordinate2D?) -> () ) {
        geoCoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                completion(false,nil)
                return
            }
            if let placemark = placemarks?.first {
                self.start = placemark.location?.coordinate
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                completion(true, coordinates)
            }
        })
    }
    /***************** Exit button *************************/
    @IBAction func exitButtonPressed(_ sender: Any) {
        locationsContainer.isHidden = true
        exitContainer.isHidden = true
        sourceTextField.text = ""
        destinationTextField.text = ""
        mapView.removeOverlays(mapView.overlays)
    }
    func hideKeyboard() {
        view.endEditing(false)
    }
}

