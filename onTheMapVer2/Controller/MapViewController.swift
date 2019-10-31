//
//  mapViewController.swift
//  onTheMapVer2
//
//  Created by Hema on 10/19/19.
//  Copyright © 2019 Hema. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
class MapViewController: UIViewController, MKMapViewDelegate {

   
    @IBOutlet weak var mapView: MKMapView!
    
        override func viewWillAppear(_ animated: Bool) {
        
            super.viewWillAppear(animated)
                DispatchQueue.main.async {
                    self.loadMapData()
                }
    
        }
    
        override func viewDidLoad() {
            mapView.delegate = self
        }
    
        func  loadMapData() {
            print("start loading map")
            OnTheMapClient.getMapData() {error in
                if (error != nil) {
                    showLoadFailure(message: error as! String)
                }
                else
                {
                      printMap()
                }
            
        }

        
        func printMap() {
            var annotations = [MKPointAnnotation]();
            for (_, value) in studentPosition.enumerated() {
                let lat = CLLocationDegrees(value.latitude)
                let long = CLLocationDegrees(value.longitude)
                
                // The lat and long are used to create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                 // Here we create the annotation and set its coordiate, title, and subtitle properties
 
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(value.firstName) \(value.lastName)"
                annotation.subtitle = value.mediaURL
                
                // Finally we place the annotation in an array of annotations.
                annotations.append(annotation)
                
                
            }
            DispatchQueue.main.async {
                self.mapView.addAnnotations(annotations)
            }
            
        }
            
         
        func showLoadFailure(message: String) {
            let alertVC = UIAlertController(title: "Map Load Failed", message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            //show(alertVC, sender: nil)
            self.present(alertVC, animated: true,  completion: nil)
            
        }
        
        func mapView(mapView: MKMapView, didSelectView view: MKAnnotationView)
        {
           print("pin was tapped")
            
        }
 
       
       func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
                    
              let reuseId = "pin"
                    
              var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
                    
              if pinView == nil {
                    pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                    pinView!.canShowCallout = true
                    pinView!.pinTintColor = .red
                    pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIButton
              } else {
                   pinView!.annotation = annotation
              }
                   return pinView
        }
                
                
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
                   
               print("tapped here")
        }
   
       func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView)
            {
                
                    print("User tapped on annotation with ")
                
            }

       
    }
    @IBAction func refreshLocation(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.loadMapData()
        }
       
    }
    

    
}
