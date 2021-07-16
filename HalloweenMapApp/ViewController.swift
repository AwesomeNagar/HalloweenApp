//
//  ViewController.swift
//  GoogleMapProject
//
//  Created by Suhas N on 6/4/21.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController, StartDelegate, TimeDelegate {
    let buffer: CGFloat = 10
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var houseName: UILabel?
    var candyButton: UIButton?
    var forwardButton: UIButton?
    var availableButton: UIButton?
    
    var loadOnce = false
    var user: UserProfile?
    var mapDel: MapDelegate!
    var placesClient: GMSPlacesClient!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient.shared()
        
        user = UserProfile()
        
        forwardButton = UIButton(frame: bufferedRect(x:0,y:view.frame.maxY-100 ,width: view.frame.maxX,height: 100))
        forwardButton?.setTitle("Go To Map", for: .normal)
        forwardButton?.backgroundColor = .black
        forwardButton?.addTarget(self, action: #selector(forwardButtonClicked), for: .touchUpInside)
        self.view.addSubview(forwardButton!)
        
        houseName = UILabel(frame: bufferedRect(x: 0, y: 100, width: view.frame.maxX, height: 100))
        houseName?.textAlignment = .center
        self.view.addSubview(houseName!)
        
        candyButton = UIButton(frame: bufferedRect(x:0,y:250 ,width: view.frame.maxX,height: 100))
        candyButton?.setTitle("What Are You Giving?", for: .normal)
        candyButton?.backgroundColor = .red
        candyButton?.addTarget(self, action: #selector(candyButtonClicked), for: .touchUpInside)
        self.view.addSubview(candyButton!)
        
        availableButton = UIButton(frame: bufferedRect(x:0,y:400 ,width: view.frame.maxX,height: 100))
        availableButton?.setTitle("Set Availability", for: .normal)
        availableButton?.backgroundColor = .systemYellow
        availableButton?.addTarget(self, action: #selector(availableButtonClicked), for: .touchUpInside)
        self.view.addSubview(availableButton!)
        
        super.viewDidLoad()
        let backbutton = UIButton(frame: bufferedRect(x:0,y: 0 ,width: 120,height: 60))
        backbutton.setTitle("Back", for: .normal)
        backbutton.backgroundColor = .black
        backbutton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        self.view.addSubview(backbutton)
        
        
    }
    
    func candiesSet(_ arr: [String]) {
        user?.setCandies(arr: arr)
    }
    func setStart(_ hour: Int, _ min: Int) {
        user?.setStart(hour: hour, min: min)
    }
    func setEnd(_ hour: Int, _ min: Int) {
        user?.setEnd(hour: hour, min: min)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if loadOnce {
            return
        }
        let alert = UIAlertController(title: "House Address", message: "Please Enter Your House Address", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            
            // Specify the place data types to return.
            let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
              UInt(GMSPlaceField.placeID.rawValue))
            autocompleteController.placeFields = fields

            // Specify a filter.
            let filter = GMSAutocompleteFilter()
            filter.type = .address
            autocompleteController.autocompleteFilter = filter

            // Display the autocomplete view controller.
            self.present(autocompleteController, animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
        loadOnce = true
        
    }
    
    @objc func forwardButtonClicked(_ sender: Any) {
        let homeView = self.storyboard?.instantiateViewController(withIdentifier: "MapView") as! MapViewController
        homeView.modalPresentationStyle = .fullScreen
        let token = GMSAutocompleteSessionToken.init()
        let placeFields: GMSPlaceField = [.name, .formattedAddress, .coordinate, .placeID]
        placesClient?.fetchPlace(fromPlaceID: (user?.location?.placeID)!,
                                 placeFields: placeFields,
                                 sessionToken: token, callback: {
          (place: GMSPlace?, error: Error?) in
          if let error = error {
            print("An error occurred: \(error.localizedDescription)")
            return
          }

          if let place = place {
            print("The selected place is: \(String(describing: place.name)), \(String(describing: place.coordinate))")
            self.user?.setLoc(place: place)
            homeView.setUser(userProf: self.user!)
          }
        })
        self.present(homeView, animated: true)



            
            
        
        
    }
    @objc func candyButtonClicked(_ sender: Any) {
        let homeView = self.storyboard?.instantiateViewController(withIdentifier: "CandyView") as! CandyViewController
        homeView.modalPresentationStyle = .fullScreen
        homeView.delegate = self
        present(homeView, animated: true)
    }
    @objc func availableButtonClicked(_ sender: Any) {
        let availableView = self.storyboard?.instantiateViewController(withIdentifier: "AvailableView") as! AvailableViewController
        availableView.modalPresentationStyle = .fullScreen
        availableView.delegate = self
        //availableView.delegate = self
        present(availableView, animated: true)
    }
    @objc func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    func bufferedRect(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect{
        return CGRect(x: x+buffer, y: y+buffer, width: width-2*buffer, height: height-2*buffer)
    }

}
extension ViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    houseName?.text = "Address: \(place.name!)"
    //print(place.addressComponents)
//    print("Place name: \(place.name)")
//    print("Place ID: \(place.placeID)")
//    print("Place attributions: \(place.attributions)")
    self.user?.setLoc(place: place)
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

}


