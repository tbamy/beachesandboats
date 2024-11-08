//
//  PropertyAddressView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/10/2024.
//

import UIKit
import MapKit
import CoreLocation

class PropertyAddressView: BaseViewControllerPlain {

    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var countryField: InputField!
    @IBOutlet weak var stateField: DropDown!
    @IBOutlet weak var streetField: InputField!
    @IBOutlet weak var cityField: InputField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    let geocoder = CLGeocoder()
    var beachData: BeachDatas?
    var states: [PickerItem]?
    var createBeachListing: CreateBeachListingRequest?
    var cityName: String?
    var stateName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beaches Houses"
        setup()
        
    }
    
    func setup(){
        stepOneProgress.setProgress(0.50, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
        statesData()
        countryField.text = "Nigeria"
        countryField.textField.isEnabled = false
        stateField.items = states ?? []
        
//        stateField.textChanged = { [weak self] _, _, _ in
//            self?.validate()
//        }
//        
//        streetField.textChanged = { [weak self] _, _, _ in
//            self?.validate()
//        }
//        
//        cityField.textChanged = { [weak self] _, _, _ in
//            self?.validate()
//        }
//                
//        nextBtn.isEnabled = false
    }

//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == cityField || textField == stateField {
//            stateName = stateField.text
//            cityName = cityField.text
//            searchLocation()
//        }
//    }
    
    func searchLocation() {
        guard let city = cityName, !city.isEmpty,
              let state = stateName, !state.isEmpty else {
            print("No state or City")
            // Handle empty input (e.g., show an alert)
            return
        }
        
        let address = "\(city), \(state)"
        
        geocoder.geocodeAddressString(address) { [weak self] (placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?.first, let location = placemark.location else {
                print("No location found")
                return
            }
            
            let coordinate = location.coordinate
            self?.mapView.setRegion(MKCoordinateRegion(center: coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000), animated: true)

            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(city), \(state)"
            self?.mapView.addAnnotation(annotation)
        }
    }
            

    
    @IBAction func nextTapped(_ sender: Any) {
        if let beachData = beachData{
            let request = CreateBeachListingRequest(category_id: createBeachListing?.category_id ?? "", sub_cat_id: createBeachListing?.sub_cat_id ?? "", guest_booking_id: createBeachListing?.guest_booking_id ?? "", name: createBeachListing?.name ?? "", description: createBeachListing?.description ?? "", country: countryField.text, state: stateField.text, city: cityField.text, street_address: streetField.text, from_when: "", to_when: "", amenities: [], preferred_languages: [""], brief_introduction: "", house_rules: [], check_in_start: "", check_in_end: "", check_out_start: "", check_out_end: "", roominfo: [], full_apartment_cost: 0, full_apartment_discount: 0, full_apartment_amount_to_earn: 0)
            
            coordinator?.gotoPropertyAvailableDatesView(beachData: beachData, createBeachListingData: request)
        }
    }
}


extension PropertyAddressView{
    func validate(){
        let validateState = stateField.validate(rules: [Rule(.isEmpty, "Select a state")])
        let validateStreet = streetField.validate(rules: [Rule(.isEmpty, "Enter your street address")])
        let validateCity = cityField.validate(rules: [Rule(.isEmpty, "Enter your City")])
        
        nextBtn.isEnabled = validateCity && validateState && validateStreet
    }
    
    func statesData(){
        states = [
            PickerItem(name: "Abia", value: "Abia"),
            PickerItem(name: "Adamawa", value: "Adamawa"),
            PickerItem(name: "Akwa Ibom", value: "Akwa Ibom"),
            PickerItem(name: "Anambra", value: "Anambra"),
            PickerItem(name: "Bauchi", value: "Bauchi"),
            PickerItem(name: "Bayelsa", value: "Bayelsa"),
            PickerItem(name: "Benue", value: "Benue"),
            PickerItem(name: "Borno", value: "Borno"),
            PickerItem(name: "Cross River", value: "Cross River"),
            PickerItem(name: "Delta", value: "Delta"),
            PickerItem(name: "Ebonyi", value: "Ebonyi"),
            PickerItem(name: "Edo", value: "Edo"),
            PickerItem(name: "Ekiti", value: "Ekiti"),
            PickerItem(name: "Enugu", value: "Enugu"),
            PickerItem(name: "FCT - Abuja", value: "FCT - Abuja"),
            PickerItem(name: "Gombe", value: "Gombe"),
            PickerItem(name: "Imo", value: "Imo"),
            PickerItem(name: "Jigawa", value: "Jigawa"),
            PickerItem(name: "Kaduna", value: "Kaduna"),
            PickerItem(name: "Kano", value: "Kano"),
            PickerItem(name: "Katsina", value: "Katsina"),
            PickerItem(name: "Kebbi", value: "Kebbi"),
            PickerItem(name: "Kogi", value: "Kogi"),
            PickerItem(name: "Kwara", value: "Kwara"),
            PickerItem(name: "Lagos", value: "Lagos"),
            PickerItem(name: "Nasarawa", value: "Nasarawa"),
            PickerItem(name: "Niger", value: "Niger"),
            PickerItem(name: "Ogun", value: "Ogun"),
            PickerItem(name: "Ondo", value: "Ondo"),
            PickerItem(name: "Osun", value: "Osun"),
            PickerItem(name: "Oyo", value: "Oyo"),
            PickerItem(name: "Plateau", value: "Plateau"),
            PickerItem(name: "Rivers", value: "Rivers"),
            PickerItem(name: "Sokoto", value: "Sokoto"),
            PickerItem(name: "Taraba", value: "Taraba"),
            PickerItem(name: "Yobe", value: "Yobe"),
            PickerItem(name: "Zamfara", value: "Zamfara")
        ]

    }
}
