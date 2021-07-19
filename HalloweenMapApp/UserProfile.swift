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
    var name: String = ""
    var owner: Bool?
    var location: GMSPlace?
    var candies: [String] = []
    var startHour: Int = 0      
    var startMin: Int = 0
    var endHour: Int = 23
    var endMin: Int = 59
    func setLoc(place: GMSPlace){
        location = place
    }
    func setStart(hour: Int, min: Int){
        startHour = hour
        startMin = min
    }
    func setEnd(hour: Int, min: Int){
        endHour = hour
        endMin = min
    }
    func setName(str: String){
        name = str
    }
    func isOwner(bool: Bool){
        owner = bool
    }
    func setCandies(arr: [String]){
        candies = arr
    }
}
