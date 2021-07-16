//
//  StartDelegate.swift
//  GoogleMapProject
//
//  Created by Suhas N on 6/15/21.
//

protocol StartDelegate{
    func candiesSet(_ arr: [String])
}

protocol MapDelegate{
    func setUser(_ userProf: UserProfile)
}

protocol TimeDelegate{
    func setStart(_ hour: Int, _ min: Int)
    func setEnd(_ hour: Int, _ min: Int)
}
