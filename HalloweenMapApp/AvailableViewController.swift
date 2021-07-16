//
//  AvailableViewController.swift
//  GoogleMapProject
//
//  Created by Suhas N on 6/18/21.
//


import UIKit
import GoogleMaps
class AvailableViewController: UIViewController {
    
    let buffer: CGFloat = 10
    var startTime: UIDatePicker!
    var endTime: UIDatePicker!
    var delegate: TimeDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        let backbutton = UIButton(frame: bufferedRect(x:0,y:view.frame.maxY-100 ,width: view.frame.maxX,height: 100))
        backbutton.setTitle("Back", for: .normal)
        backbutton.backgroundColor = .black
        backbutton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        self.view.addSubview(backbutton)
        
        let fromLabel = UILabel(frame: CGRect(x: 0, y: 100, width: view.frame.maxX/2, height: 100))
        fromLabel.text = "From:"
        fromLabel.textAlignment = .center
        self.view.addSubview(fromLabel)
        
        startTime = UIDatePicker(frame: CGRect(x: 50, y: fromLabel.frame.maxY, width: view.frame.maxX/2, height: 100))
        startTime.datePickerMode = .time
        startTime.addTarget(self, action: #selector(startTimeSet(_:)), for: .editingDidEnd)
        self.view.addSubview(startTime)
        
        let toLabel = UILabel(frame: CGRect(x: view.frame.maxX/2, y: fromLabel.frame.minY, width: view.frame.maxX/2, height: 100))
        toLabel.text = "To:"
        toLabel.textAlignment = .center
        self.view.addSubview(toLabel)
        //middle/2-width+startminX
        endTime = UIDatePicker(frame: CGRect(x: 235, y: toLabel.frame.maxY, width: view.frame.maxX/2, height: 100))
        endTime.datePickerMode = .time
        endTime.addTarget(self, action: #selector(endTimeSet(_:)), for: .editingDidEnd)
        self.view.addSubview(endTime)
    }
    
    @objc func buttonClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @objc func startTimeSet(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
            if let hour = components.hour, let min = components.minute {
                print("\(hour) \(min)")
                delegate?.setStart(hour, min)
            }
    }
    @objc func endTimeSet(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
            if let hour = components.hour, let min = components.minute {
                print("\(hour) \(min)")
                delegate?.setEnd(hour, min)
            }
    }
    func bufferedRect(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect{
        return CGRect(x: x+buffer, y: y+buffer, width: width-2*buffer, height: height-2*buffer)
    }
}
