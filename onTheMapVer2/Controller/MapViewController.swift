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
 
    @IBAction func refreshLocation(_ sender: Any) {
        DispatchQueue.main.async {
            self.loadMapData()
        }
        
    }
    
    @IBAction func logout(_ sender: Any) {
        OnTheMapClient.logout {
            print("logged out")
            let loginController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
            self.present(loginController, animated: true, completion: nil)
            
        }
    }
    
    func showLoadFailure(message: String) {
        let alertVC = UIAlertController(title: "Map Load Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        //show(alertVC, sender: nil)
        self.present(alertVC, animated: true,  completion: nil)
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        print("pin was tapped")
        if let annotationSubtitle = view.annotation?.subtitle
        {
            print("User tapped on annotation with title: \(annotationSubtitle!)")

            let detailController = self.storyboard!.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            detailController.webData = (view.annotation?.subtitle)!
            
            self.present(detailController, animated: true, completion: nil)
        }
            
    }
    
    func  loadMapData() {
        print("start loading map")
        OnTheMapClient.getMapData() {error in
            if (error != nil) {
                self.showLoadFailure(message: error as! String)
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
    }

    
}
