//                              Name: Hera Siddiqui
//                              
//  Tested in iPhone 7
//  For the difficult parts took ideas from the net
//  SportsViewController.swift
//  Assignment4
//
//  Created by Admin on 10/13/17.
//  Copyright © 2017 Hera Siddiqui. All rights reserved.
//

import UIKit

class SportsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var sportsPicker: UIPickerView!
    @IBOutlet weak var sportsSlider: UISlider!
    
    var countryAndSports:Dictionary<String,Array<String>>?
    var country:Array<String>? //Sorted list of keys from typesAndFood var selectedType:String?
    var selectedCountry:String?
    var sports:Array<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let data:Bundle = Bundle.main
        let sportsPlist:String? = data.path(forResource: "Sports", ofType: "plist")
        if sportsPlist != nil {
            countryAndSports = (NSDictionary.init(contentsOfFile: sportsPlist!) as! Dictionary)
            country = countryAndSports?.keys.sorted()
            selectedCountry = country![0]
            sports = countryAndSports![selectedCountry!]!.sorted()
            sportsPicker.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard (country != nil) && sports != nil else {
            return 0
        }
        switch component {
        case 0:
            return country!.count
        case 1:
            return sports!.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard (country != nil) && sports != nil else {
            return "None"
        }
        switch component {
        case 0:
            return country![row]
        case 1:
            return sports![row]
        default:
            return "None"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard (country != nil) && sports != nil else {
            return
        }
        if (component == 0 ) {
            selectedCountry = country![row]
            sports = countryAndSports![selectedCountry!]!.sorted()
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            sportsSlider.value = 0
        }
        print("picked component \(component) row \(row)")
        
        if (component == 1) {
            let elements = pickerView.numberOfRows(inComponent: 1)
            let selectedElement = sportsPicker.selectedRow(inComponent: 1)
            let sliderValue = Float(( selectedElement * 200)/(elements - 1))
            sportsSlider.setValue(sliderValue, animated: true)
        }
    }
    
    @IBAction func sportsSliderValueChanged(_ sender: UISlider) {
        let elements = sportsPicker.numberOfRows(inComponent: 1)
        let element = Int((Int(sportsSlider.value) * (elements - 1)) / 200)
        sportsPicker.selectRow(element, inComponent: 1, animated: true)
    }
}

