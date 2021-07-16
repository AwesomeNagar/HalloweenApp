//
//  CandyViewController.swift
//  GoogleMapProject
//
//  Created by Suhas N on 6/4/21.
//

import UIKit
import GoogleMaps
class CandyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    let buffer: CGFloat = 10
    var candySearch: UITextField!
    var candyDisplay: UITextView!
    var autocomplete: UITableView!
    let cellReuseIdentifier = "cell"
    var data: Database!
    var autocompleteOptions: [String]!
    var candies: [String]!
    var delegate: StartDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupToHideKeyboardOnTapOnView()
        
        candyDisplay = UITextView(frame: bufferedRect(x:0,y:view.frame.maxY-300 ,width: view.frame.maxX,height: 100))
        self.view.addSubview(candyDisplay)
        
        let addButton = UIButton(frame: bufferedRect(x:0,y:view.frame.maxY-200 ,width: view.frame.maxX,height: 100))
        addButton.setTitle("Add", for: .normal)
        addButton.backgroundColor = .black
        addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        self.view.addSubview(addButton)
        
        let backbutton = UIButton(frame: bufferedRect(x:0,y:view.frame.maxY-100 ,width: view.frame.maxX,height: 100))
        backbutton.setTitle("Done", for: .normal)
        backbutton.backgroundColor = .black
        backbutton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        self.view.addSubview(backbutton)
        
        
        candySearch = UITextField(frame: bufferedRect(x: 0, y: 0, width: view.frame.maxX, height: 200))
        candySearch?.placeholder = "Enter Candy Name"
        candySearch?.delegate = self
        candySearch?.addTarget(self, action: #selector(nameEdited(_:)), for: .editingChanged)
        self.view.addSubview(candySearch!)
        
        autocomplete = UITableView(frame: CGRect(x: 0, y: (candySearch?.frame.maxY)!, width: view.frame.maxX, height: 300))
        autocomplete.rowHeight = 60
        autocomplete.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        autocomplete?.dataSource = self
        autocomplete?.delegate = self
        autocomplete.isScrollEnabled = false
        self.view.addSubview(autocomplete)
        
        
        data = Database()
        autocompleteOptions = ["","","","",""]
        candies = []

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
        
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: cellReuseIdentifier)

        // set the text from the data model
        cell.textLabel?.text = self.autocompleteOptions![indexPath.row]
//        cell.textLabel?.text = "hello"
    
        return cell
    }
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.candySearch?.text = self.autocompleteOptions![indexPath.row]
        updateAutoComplete()
        
    }


    @objc func backButtonClicked(_ sender: Any) {
        delegate?.candiesSet(candies!)
        self.dismiss(animated: true)
    }
    @objc func addButtonClicked(_ sender: Any){
        candies?.append((self.candySearch?.text)!)
        self.candySearch!.text = ""
        self.candySearch?.placeholder = "Enter Candy Name"
        updateAutoComplete()
        if candies.count > 1 {
            self.candyDisplay.text = self.candyDisplay.text + ", "
        }
        self.candyDisplay.text = self.candyDisplay.text + candies![candies!.count-1]
    }
    func bufferedRect(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect{
        return CGRect(x: x+buffer, y: y+buffer, width: width-2*buffer, height: height-2*buffer)
    }
    
    @objc func nameEdited(_ sender: Any){
        updateAutoComplete()
    }
    func updateAutoComplete(){
        for i in 0...4 {
            autocompleteOptions![i] = (data?.top(substr: (self.candySearch?.text)!, row: i))!
        }
        self.autocomplete.reloadData()
    }
}
extension UIViewController
{
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
