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

    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case getLoginSession
        case deleteLoginSession
        case getStudentLocation
        case postStudentLocation
        case getUserName(uniqueKey: String)
        
        var stringValue: String {
            switch self {
            case .getLoginSession, .deleteLoginSession: return Endpoints.base + "/session"
            case .getStudentLocation: return Endpoints.base + "/StudentLocation" + "?limit=100&order=-updatedAt"
            case .postStudentLocation: return Endpoints.base + "/StudentLocation"
            case .getUserName(let uniqueKey): return Endpoints.base + "/users/\(uniqueKey)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    

    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = 5..<data!.count
            let newData = data!.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
            
        }
        completion()
        task.resume()
        print("done")
    }
    

    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        print("logging in")
        let loginData = UserLogin(username: username, password: password)
        
 
        let body = UserRequest(loginRequest: loginData)
        
        taskForPOSTRequest(url: Endpoints.getLoginSession.url, delChars:true, responseType: Userinfo.self, body: body) { response, error in
            if let response = response {
                print(response)
                AuthUser.key = response.account.key
                print(response.account.key)
                completion(true, nil)
                print("login complete")
                
            } else {
                print("errot")
                completion(false, error)
            }
        }

        
    }
    
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, delChars:Bool, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
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
            var newData = data
            if (delChars) {
                let range = 5..<data.count
                newData = data.subdata(in: range) /* subset response data! */
            }
            
            print(String(data: newData, encoding: .utf8)!)
            
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
        
        //let myReq = "https://onthemap-api.udacity.com/v1/users/" + AuthUser.key
        
        taskForGETRequest(url:Endpoints.getUserName(uniqueKey: AuthUser.key).url, delChars:true, responseType: UdacityUser.self)
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
    
    
    class func getMapData(completion: (@escaping ( Error?) -> Void) ) {
        
        taskForGETRequest(url:Endpoints.getStudentLocation.url,  delChars:false, responseType: Results.self)
        { response, error in
            if let response = response {
                var newMap = MapPosition(firstName: "", lastName: "", longitude: 0.00, latitude: 0.00, mediaURL: "", mapString: "")
        //initialize students array
                studentPosition.removeAll()
                print(response as Any)
                print(response.results[1])
                for (_, value) in response.results.enumerated()
                {
                    let firstName = value.firstName
                    let lastName  = value.lastName
                    let longitude = value.longitude
                    let latitude  = value.latitude
                    let mediaURL  = value.mediaURL
                    let mapString = value.mapString
                    
                    print(firstName);
                    print(lastName);
                    print(longitude);
                    print(latitude);
                    print(mediaURL);
                    
                    print(mapString)
                    newMap = MapPosition(firstName: firstName, lastName: lastName, longitude: longitude, latitude: latitude, mediaURL: mediaURL, mapString: mapString)
                    studentPosition.append(newMap)
                    print(studentPosition.count)
              }
             completion(nil)
            }
            else {
               print(error!)
               completion(error)
            }

        }
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
    
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, delChars:Bool, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }


            var newData = data
            if (delChars) {
                let range = 5..<data.count
                newData = data.subdata(in: range) /* subset response data! */
            }
            
            print(String(data: newData, encoding: .utf8)!)
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(OnTheMapResponse.self, from: data) as Error
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
    }
    
 
    class func addNewMapData(newPlaceText: String, newPlace: CLLocationCoordinate2D, newUrl: String, completion: (@escaping ( Error?) -> Void) ) {
        print("here in new map location")
        
        let newLat = String(newPlace.latitude)
        let newlong = String(newPlace.longitude)
        
        let body = UserLocation(uniqueKey: AuthUser.key, firstName: AuthUser.nickname, lastName: AuthUser.last_name, mapString: newPlaceText, mediaURL: newUrl, latitude: Float(newLat) as! Float, longitude: Float(newlong) as! Float)
        
        taskForPOSTRequest(url: Endpoints.postStudentLocation.url, delChars:false, responseType: UserLocationResponse.self, body: body) { response, error in
            if let response = response {
                print(response)
                completion(nil)
                
            } else {
                print("errot")
                completion(error)
            }
        }

    }

    
    
}
