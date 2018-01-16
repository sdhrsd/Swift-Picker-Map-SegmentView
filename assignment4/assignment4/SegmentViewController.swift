//                               Name: Hera Siddiqui
//                               
//  Tested in iPhone 7
//  For the difficult parts took ideas from the net
//  SegmentViewController.swift
//  Assignment4
//
//  Created by Admin on 10/13/17.
//  Copyright © 2017 Hera Siddiqui. All rights reserved.
//

import Foundation
import UIKit

class SegmentViewController: UIViewController {
    
    @IBOutlet weak var segmentValue: UISegmentedControl!
    @IBOutlet weak var activitySwitch: UISwitch!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var alertMessageButton: UIButton!
    @IBOutlet weak var clearTextButton: UIButton!
    
        override func viewDidLoad() {
        super.viewDidLoad()
        progressSegment()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            progressSegment()
        case 1:
            textSegment()
        case 2:
            alertSegment()
        default:
            alertSegment()
        }
    }
    func progressSegment() {
        view.endEditing(false)
        activitySwitch.isHidden = false
        activityIndicator.isHidden = false
        textView.isHidden = true
        doneButton.isHidden = true
        clearTextButton.isHidden = true
        alertMessageButton.isHidden = true
        activitySwitch.isOn = false
        activityIndicator.stopAnimating()
    }
    func textSegment() {
        activitySwitch.isHidden = true
        activityIndicator.isHidden = true
        textView.isHidden = false
        doneButton.isHidden = false
        clearTextButton.isHidden = false
        alertMessageButton.isHidden = true
    }
    func alertSegment() {
        view.endEditing(false)
        activitySwitch.isHidden = true
        activityIndicator.isHidden = true
        textView.isHidden = true
        doneButton.isHidden = true
        clearTextButton.isHidden = true
        alertMessageButton.isHidden = false
    }
    
    @IBAction func switchToggled(_ sender: UISwitch) {
        if (sender.isOn) {
            activitySwitch.isOn = false
            activityIndicator.stopAnimating()
        }
        else if (!sender.isOn) {
            activitySwitch.isOn = true
            activityIndicator.startAnimating()
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        view.endEditing(false)
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        textView.text = ""
        textView.becomeFirstResponder()
    }
    
    @IBAction func alertMessageButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Alert Message", message: "Do you like the iPhone?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: nil)
        alert.addAction(yesAction)
        present(alert, animated: true, completion: nil)
        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(noAction)
    }
}
