//
//  EditPropertyAddressView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 23/07/2025.
//

import UIKit
import MapKit
import CoreLocation

class EditPropertyAddressView: BaseViewControllerPlain {

    var coordinator: HostingServiceMenuCoordinator?
    
    @IBOutlet weak var countryField: InputField!
    @IBOutlet weak var stateField: DropDown!
    @IBOutlet weak var streetField: InputField!
    @IBOutlet weak var cityField: InputField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    let geocoder = CLGeocoder()
    var property: BeachHouseListing?
    var beachData: BeachDatas?
    var states: [PickerItem]?
    var createBeachListing: CreateBeachListingRequest?
    var cityName: String?
    var stateName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Property"
        setup()
        
    }
    
    func setup(){
        
        statesData()
        countryField.text = "Nigeria"
        countryField.textField.isEnabled = false
        
        stateField.text = createBeachListing?.state ?? ""
        streetField.text = createBeachListing?.streetName ?? ""
        cityField.text = createBeachListing?.city ?? ""
        
        stateField.items = states ?? []
        
        stateField.itemChanged = { [weak self] item in
            self?.validateState()
            self?.stateName = self?.stateField.text
            self?.zoomToState()
        }
        
        streetField.textChanged = { [weak self] _, _, _ in
            self?.validateStreet()
        }
        
        cityField.textChanged = { [weak self] _, _, _ in
            self?.validateCity()
        }
        
        mapView.isUserInteractionEnabled = true
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMapTap)))

    }

    
    func zoomToState() {
        guard let state = stateName, !state.isEmpty else { return }
        geocoder.geocodeAddressString(state) { [weak self] placemarks, error in
            if let coordinate = placemarks?.first?.location?.coordinate {
                let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 20000, longitudinalMeters: 20000)
                self?.mapView.setRegion(region, animated: true)
            }
        }
    }

    @objc func handleMapTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let locationInView = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)
        
        // Remove existing annotations
        mapView.removeAnnotations(mapView.annotations)
        
        // Add new annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Selected Location"
        mapView.addAnnotation(annotation)
        
        // Save to model
        createBeachListing?.latitude = coordinate.latitude
        createBeachListing?.longitude = coordinate.longitude
        
        print("Selected Coordinates: \(coordinate.latitude), \(coordinate.longitude)")
    }

            

    
    @IBAction func nextTapped(_ sender: Any) {
        if let beachData = beachData{
            if var createBeachListing = createBeachListing{
                createBeachListing.country = countryField.text
                createBeachListing.state = stateField.text
                createBeachListing.city = cityField.text
                createBeachListing.streetName = streetField.text
                
                self.createBeachListing = createBeachListing
                print(createBeachListing)
                
                coordinator?.pop()
            }
         
            
            
        }
    }
    
}


extension EditPropertyAddressView{
    func validateState(){
        let _ = stateField.validate(rules: [Rule(.isEmpty, "Select a state")])
    }
    
    func validateStreet(){
        let validateStreet = streetField.validate(rules: [Rule(.isEmpty, "Enter street address")])
        
        nextBtn.isEnabled = validateStreet
    }
    
    func validateCity(){
        let _ = cityField.validate(rules: [Rule(.isEmpty, "Enter City")])
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
