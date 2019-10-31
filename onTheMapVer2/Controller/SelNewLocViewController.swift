//
//  SelectNewLocationController.swift
//  onTheMapVer2
//
//  Created by Hema on 10/23/19.
//  Copyright © 2019 Hema. All rights reserved.
//


import UIKit
import CoreLocation

class SelNewLocViewController: UIViewController, UINavigationControllerDelegate,  UITextFieldDelegate {
    
    @IBOutlet weak var newLocation: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        print("detail view")
        configureTextField(newLocation, text: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
    }
    
    
    let onTheMapTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 25)!,
        NSAttributedString.Key.strokeWidth: -1.0
    ]
    
    func configureTextField(_ textField: UITextField, text: String) {
        textField.text = text
        textField.textAlignment = .center
        //textField.delegate = textFieldDelegate
        textField.defaultTextAttributes = onTheMapTextAttributes
    }
    
    @IBAction func addLocation(_ sender: UIButton) {

        OnTheMapClient.getCoord(placename: newLocation.text!) { NewLocation, error in
            if (error != nil) {
                self.showLoadFailure(message: error as! String)
            }
            else
            {
                print(NewLocation.longitude)
                let coordinate = CLLocationCoordinate2D(latitude: NewLocation.latitude, longitude: NewLocation.longitude)
                
                let nc = self.storyboard?.instantiateViewController(withIdentifier: "NewLocationViewController") as! NewLocationViewController
                nc.coordinate = coordinate
                nc.newPlace = self.newLocation.text
                self.present(nc, animated: true, completion: nil)

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
