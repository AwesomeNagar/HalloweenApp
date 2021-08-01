//
//  UserProfile.swift
//  GoogleMapProject
//
//  Created by Suhas N on 6/15/21.
//

import UIKit
import GoogleMaps
import GooglePlaces

class UserProfile{
    var email: String = ""
    var owner: Bool?
    var location: GMSPlace?
    var candies: [String] = []
    var startHour: Int = 0      
    var startMin: Int = 0
    var endHour: Int = 23
    var endMin: Int = 59
    var placeId: String?
    init(emailAddress: String){
        email = emailAddress
    }
    func setLoc(place: GMSPlace){
        location = place
        placeId = place.placeID
    }
    func setPlaceId(id: String){
        placeId = id
    }
    func setStart(hour: Int, min: Int){
        startHour = hour
        startMin = min
    }
    func setEnd(hour: Int, min: Int){
        endHour = hour
        endMin = min
    }
    func isOwner(bool: Bool){
        owner = bool
    }
    func setCandies(arr: [String]){
        candies = arr
    }
    func addCandy(candy: String){
        candies.append(candy)
    }
}

//TODO Change GMSPlace into Lat Lng and Name of Place
