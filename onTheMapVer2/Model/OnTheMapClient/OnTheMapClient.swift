//
//  File.swift
//  onTheMapVer2
//
//  Created by Hema on 10/16/19.
//  Copyright © 2019 Hema. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
class OnTheMapClient {
    
    struct AuthUser {
        static var nickname = ""
        static var last_name = ""
        static var key = ""
      }
   
    struct CurrentLocation {
        static var newLat = 0
        static var newLong = 0
    }
    

    
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let myBody =  "{\"udacity\": {\"username\": \"" + username + "\", \"password\": \"" + password + "\"}}"
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = myBody.data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {print("Your request returned a status code other than 2xx!")
                completion(false, error)
                return
            }
            
            
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
            
            do {
                let decoder = JSONDecoder()
                let myInfo:Userinfo
                do {
                    
                    myInfo = try decoder.decode(Userinfo.self, from: newData)
                    print(myInfo)
                    print(myInfo.account.key)
                    AuthUser.key = myInfo.account.key
                    print(myInfo.session.id)
                    completion(true, nil)
                    
                    
                } catch {
                    
                    completion(false, error)
                }
            }
            
            
        }
        task.resume()
        
    }
    
    
    class   func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {print("Your request returned a status code other than 2xx!")
                completion(nil, error)
                return
            }
            
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
            print("after get name")
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    print("here")
                    print(responseObject)
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(OnTheMapResponse.self, from: newData) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
        
    }
    
    
    class func getUserName(completion: @escaping (Bool, Error?) -> Void) {
        print("testing get call")
        
        let myReq = "https://onthemap-api.udacity.com/v1/users/" + AuthUser.key
        //var request1 = URLRequest(url: URL(string: myReq)!)
        print(myReq)
        
        taskForGETRequest(url:URL(string: myReq)!, responseType: UdacityUser.self)
        { response, error in
            print("in new user get name")
            if let response = response {
                print(response.last_name)
                print(response.nickname)
                
                AuthUser.last_name = response.last_name
                AuthUser.nickname = response.nickname
                print("after response")
                completion(true, nil)
                
            } else {
                print(error!)
                completion(false, error)
            }
        }
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        print("in login response")
        print(success)
        if success {
            print("success")
        } else {
            print("error")
        }
    }
    
    
    
    class func getMapData(completion: (@escaping ( Error?) -> Void) )  {
        
        // Do any additional setup after loading the view.
        var newMap = MapPosition(firstName: "", lastName: "", longitude: 0.00, latitude: 0.00, mediaURL: "", mapString: "")
        //initialize students array
        studentPosition.removeAll()
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completion(error)
                return
            }
            
            
            print(String(data: data, encoding: .utf8)!)
            
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
            } catch {
                completion(error)
                return
            }
            
            guard let locationData = parsedResult["results"] as? [NSDictionary] else {
                completion(error)
                return
            }
            
            
            
            /* Store all "Matchmaking" categories */
            for locationInfo in locationData {
                
                guard let firstName = locationInfo["firstName"] as? String else {
                    completion(error)
                    return
                }
                print(firstName);
                guard let lastName = locationInfo["lastName"] as? String else {
                    completion(error)
                    return
                }
                print(lastName);
                
                guard let longitude = locationInfo["longitude"] as? Double else {
                    completion(error)
                    return
                }
                print(longitude);
                
                guard let latitude = locationInfo["latitude"] as? Double else {
                    completion(error)
                    return
                }
                print(latitude);
                guard let mediaURL = locationInfo["mediaURL"] as? String else {
                    completion(error)
                    return

                }
                print(mediaURL);
                guard let mapString = locationInfo["mapString"] as? String else {
                   completion(error)
                    return
                }
                print(mapString);
                
                newMap.firstName = firstName
                newMap.lastName = lastName
                newMap.longitude = longitude
                newMap.latitude = latitude
                newMap.mediaURL = mediaURL
                newMap.mapString = mapString
                
                studentPosition.append(newMap)
                print(studentPosition.count)

            }
            completion(nil)
        }
        task.resume()
        
        
        
    }
    
    class  func getCoord(placename: String, completion: (@escaping (NewLocation, Error?) -> Void) )   {
            let latitude: CLLocationDegrees = 0.0
            let longitude: CLLocationDegrees = 0.0
            var newLocation = NewLocation(longitude: latitude, latitude: longitude)
        
            DispatchQueue.main.async {
                CLGeocoder().geocodeAddressString(placename, completionHandler: { (placemarks, error) -> Void in
                if error != nil {
                    
                    completion(newLocation, error)
                }
                if placemarks!.count > 0 {
                    let placemark = placemarks?[0]
                    let location = placemark?.location
                    print(location?.coordinate as Any)
                    let coordinate = location?.coordinate
                    
                    newLocation.latitude = coordinate!.latitude
                    newLocation.longitude = coordinate!.longitude
                    completion(newLocation, nil)
                }
                else {
                    completion(newLocation, error)
                }
                
            })
        }
        
        
    }

    class func addNewMapData(newPlaceText: String, newPlace: CLLocationCoordinate2D, newUrl: String, completion: (@escaping ( Error?) -> Void) ) {
        print("here in new map location")
        
        let newLat = String(newPlace.latitude)
        let newlong = String(newPlace.longitude)
        let someBody = "{\"uniqueKey\": \"" + AuthUser.key + "\", \"firstName\": \"" +  AuthUser.nickname + "\", \"lastName\": \"" +  AuthUser.last_name
        let someBody1 = "\",\"mapString\": \"" + newPlaceText
        let someBody2 = "\", \"mediaURL\": \"" +  newUrl
        let someBody3 =  "\", \"latitude\": " + newLat
        let someBody4 = ", \"longitude\": " + newlong +  "}"
        let completebody = someBody + someBody1 + someBody2 + someBody3 + someBody4
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = completebody.data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {print("Your request returned a status code other than 2xx!")
                completion(error)
                return
            }
            print(String(data: data, encoding: .utf8)!)
            completion(nil)
        }
        task.resume()

    }

    
    
}
