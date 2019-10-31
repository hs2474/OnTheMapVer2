//
//  NewLocationViewController.swift
//  onTheMapVer2
//
//  Created by Hema on 10/24/19.
//  Copyright © 2019 Hema. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation


class NewLocationViewController: UIViewController, UINavigationControllerDelegate,  UITextFieldDelegate {

    @IBOutlet weak var pinLocation: MKMapView!
    var coordinate: CLLocationCoordinate2D!
    var newPlace: String!

    @IBOutlet weak var newURL: UITextField!
    // MARK: Life Cycle

override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print(coordinate as Any)
    pinLocation.delegate = self as? MKMapViewDelegate
    let newLocation = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000);
    let annotation = MKPointAnnotation()
    
    // Finally we place the annotation in an array of annotations.
    
    DispatchQueue.main.async {
        self.pinLocation.addAnnotation(annotation)
        self.pinLocation.setRegion(newLocation, animated: true)
        self.pinLocation.regionThatFits(newLocation)
    }
    
    
}

    override func viewDidAppear(_ animated: Bool) {
        guard coordinate != nil else {
            self.dismiss(animated: true, completion: nil)
            print( "Failed to Find Location")
            return
        }
        
        
    }
    
    @IBAction func submitLocation(_ sender: UIButton) {
        

        OnTheMapClient.addNewMapData(newPlaceText: newPlace!, newPlace: coordinate, newUrl: newURL.text!) {  error in
            if (error != nil) {
                self.showLoadFailure(message: error as! String)
            }
            else
            {
                DispatchQueue.main.async {
                    let nc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                    self.present(nc, animated: true, completion: nil)
                }

            }
        }
        
    }
    func showLoadFailure(message: String) {
        let alertVC = UIAlertController(title: "Could not get coordinates of location", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        //show(alertVC, sender: nil)
        self.present(alertVC, animated: true,  completion: nil)
        
    }
    
}
