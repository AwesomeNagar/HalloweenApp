//
//  MapViewController.swift
//  GoogleMapProject
//
//  Created by Suhas N on 6/4/21.
//

import UIKit
import GoogleMaps
class MapViewController: UIViewController {
    var database: Database = Database()
    var user: UserProfile?
    let buffer: CGFloat = 10
    var present: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func setUser(userProf: UserProfile){
       database.addUser(user: userProf)
       user = userProf
        let camera = GMSCameraPosition.camera(withLatitude: (user?.location?.coordinate.latitude)!, longitude: (user?.location?.coordinate.longitude)!, zoom: 36.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
        
      let calendar = Calendar.current
        let now = Date()
        let startTime = calendar.date(
            bySettingHour: (user?.startHour)!,
            minute: (user?.startMin)!,
          second: 0,
          of: now)!
        let endTime = calendar.date(
            bySettingHour: (user?.endHour)!,
            minute: (user?.endMin)!,
          second: 0,
          of: now)!
        if now >= startTime &&
          now <= endTime
        {
          present = true
        }
        
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: (user?.location?.coordinate.latitude)! , longitude: (user?.location?.coordinate.longitude)!)
        marker.title = user?.location?.name
        var snippet: String = ""
        for item in (user?.candies)! {
            snippet += "\(item) \n"
        }
        if present {
            marker.icon = GMSMarker.markerImage(with: .yellow)
        }else{
            marker.icon = GMSMarker.markerImage(with: .black)
        }
        marker.snippet = snippet
        marker.map = mapView
        
        let backbutton = UIButton(frame: bufferedRect(x:0,y:view.frame.maxY-100 ,width: view.frame.maxX,height: 100))
        backbutton.setTitle("Back", for: .normal)
        backbutton.backgroundColor = .black
        backbutton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        self.view.addSubview(backbutton)
    }
    @objc func buttonClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    func bufferedRect(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect{
        return CGRect(x: x+buffer, y: y+buffer, width: width-2*buffer, height: height-2*buffer)
    }
}
