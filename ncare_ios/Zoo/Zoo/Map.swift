//
//  Map.swift
//  Zoo
//
//  Created by Никита Казанцев on 16.11.2019.
//  Copyright © 2019 sudox.kazantsev.com. All rights reserved.
//


import Foundation

import UIKit
import MapKit
protocol MapViewDelegate{
 func saveLocation(placemark: MKPlacemark)
}
class MapViewController: UIViewController, UIGestureRecognizerDelegate {
 
 var delegate:MapViewDelegate!
 
 var mapView: MKMapView!
 
 // MARK: - Search
 
 fileprivate var searchBar: UISearchBar!
 fileprivate var localSearchRequest: MKLocalSearch.Request!
 fileprivate var localSearch: MKLocalSearch!
 fileprivate var localSearchResponse: MKLocalSearch.Response!
 
 // MARK: - Map variables
 
 fileprivate var annotation: MKAnnotation!
 fileprivate var isCurrentLocation: Bool = false
 
 var selectedPin: MKPlacemark?
// MARK: - UIViewController's methods
 
 override func viewDidLoad() {
  super.viewDidLoad()
  
  mapView = MKMapView()
  
  let leftMargin:CGFloat = 0
        let topMargin:CGFloat = 20
        let mapWidth:CGFloat = view.frame.size.width
        let mapHeight:CGFloat = view.frame.size.height - 0
        
        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
  mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
    mapView.showsUserLocation = false
    
  self.view.addSubview(mapView)
  
  searchBar = UISearchBar(frame: CGRect(x: 0, y: -30, width: mapWidth, height: 60))
  searchBar.delegate = self
  self.view.addSubview(searchBar)
  
    let button = UIButton(frame: CGRect(x: view.frame.size.width / 2 - 100, y: view.frame.size.height - 220, width: 200, height: 50))
    button.backgroundColor = .black
    button.alpha = 0.2
    button.layer.cornerRadius = 15
    button.setTitle("Use current location", for: .normal)
    
    button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

    self.view.addSubview(button)

    
    
    let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(longpress(gestureRecognizer:)))

            uilpgr.minimumPressDuration = 1.5

            mapView.addGestureRecognizer(uilpgr)




    }
    
    @objc func buttonAction(sender: UIButton!) {
        mapView.showsUserLocation = true
        let mycoords = MKPointAnnotation()
        

        mycoords.title = "Current location"
        mycoords.coordinate = CLLocationCoordinate2D(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
        self.mapView.removeAnnotations(self.mapView.annotations)
        mapView.addAnnotation(mycoords)
        
        convertLatLongToAddress(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
        
        
    }
    
    public func getloc() ->String
    {
        if let _ = annotation
        {
            return annotation.description
        }
        return " "
    }
    
    


    
    @objc func longpress(gestureRecognizer: UIGestureRecognizer) {

    if gestureRecognizer.state == UIGestureRecognizer.State.began {

            let touchPoint = gestureRecognizer.location(in: self.mapView)

            let newCoordinate = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)


            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            // location save
            print(location)
        
        convertLatLongToAddress(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
            var title = ""

            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in

                if error != nil {

                    print(error)

                } else {

                    if let placemark = placemarks?[0] {

                        if placemark.subThoroughfare != nil {

                            title += placemark.subThoroughfare! + " "

                        }

                        if placemark.thoroughfare != nil {

                            title += placemark.thoroughfare! + " "

                        }



                    }

                }

                if title == "" {

                    title = "\(NSDate())"

                }

                let annotation = MKPointAnnotation()

                annotation.coordinate = newCoordinate

                annotation.title = title

                self.mapView.removeAnnotations(self.mapView.annotations)


                self.mapView.addAnnotation(annotation)



            })

        }

    }
 }
    
    
    



 
extension MapViewController:MKMapViewDelegate{
 
 func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
  guard !(annotation is MKUserLocation) else { return nil }
  let reuseId = "pin"
  var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
  if pinView == nil {
   pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
  }
pinView?.pinTintColor = UIColor.orange
  pinView?.canShowCallout = true
  let smallSquare = CGSize(width: 30, height: 30)
  let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
  
  button.setBackgroundImage(UIImage(systemName: "plus.square"), for: .normal)
  button.addTarget(self, action: #selector(savedPin), for: .touchUpInside)
  
  pinView?.leftCalloutAccessoryView = button
  
  return pinView
 }
 
 @objc func savedPin(){
  guard let delegate = delegate, let placemark = selectedPin else { return}
  delegate.saveLocation(placemark: placemark)
 }
}
extension MapViewController:UISearchBarDelegate{
 // MARK: - UISearchBarDelegate
 func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
  if self.mapView.annotations.count != 0 {
   annotation = self.mapView.annotations[0]
   self.mapView.removeAnnotation(annotation)
  }
  
  localSearchRequest = MKLocalSearch.Request()
  localSearchRequest.naturalLanguageQuery = searchBar.text
  localSearch = MKLocalSearch(request: localSearchRequest)
  localSearch.start { (localSearchResponse, error) -> Void in
   if localSearchResponse == nil {
    return self.showAlert()
   }
   
   guard let mapItem = localSearchResponse?.mapItems.first else {
    return self.showAlert()
   }
   
   let placemark = mapItem.placemark
   
   self.addPin( placemark: placemark)
   self.selectedPin = placemark
  }
 }
 
 func showAlert(){
  let alert = UIAlertController(title: nil, message:"Place not found", preferredStyle: .alert)
  alert.addAction(UIAlertAction(title: "Try again", style: .default) { _ in })
  self.present(alert, animated: true){}
 }
 
 func addPin(placemark: MKPlacemark){
  let annotation = MKPointAnnotation()
  annotation.coordinate = placemark.coordinate
  annotation.title = placemark.name
  
  if let city = placemark.locality,
   let state = placemark.administrativeArea {
    annotation.subtitle = "\(city) \(state)"
  }
  
  addAnnotation(annotation: annotation)
 }
 
 func addAnnotation( annotation:MKPointAnnotation ){
  mapView.addAnnotation(annotation)
  let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
  let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
  mapView.setRegion(region, animated: true)
 }
    
    
    
    
    
    
}
 public func convertLatLongToAddress(latitude:Double,longitude:Double){

     let geoCoder = CLGeocoder()
     let location = CLLocation(latitude: latitude, longitude: longitude)
     
     geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
        
         // Place details
        var full_adr = ""
         var placeMark: CLPlacemark!
         placeMark = placemarks?[0]

         // Location name
         if let locationName = placeMark.location {
             print(locationName)
         }
         // Street address
         if let street = placeMark.thoroughfare {
             full_adr = full_adr + street + ", "
         }
         // City
         if let city = placeMark.subAdministrativeArea {
             print(city)
            full_adr = full_adr + city + ", "
         }
         // Zip code
         if let zip = placeMark.isoCountryCode {
             print(zip)
         }
         // Country
         if let country = placeMark.country {
             print(country)
            full_adr = full_adr + country + " "
         }
        if full_adr != ""
        {
        UserDefaults.standard.set(full_adr, forKey: "location_report")
        }
        else
        {
            UserDefaults.standard.set(String(latitude) + ":" + String(longitude), forKey: "location_report")
        }
        
        
     })
    
 }
