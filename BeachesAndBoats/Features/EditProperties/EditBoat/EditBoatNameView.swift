//
//  EditBoatNameView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/09/2025.
//

import UIKit
import RxSwift

class EditBoatNameView: BaseViewControllerPlain {

    var coordinator: HostingServiceMenuCoordinator?
    
    @IBOutlet weak var nameLabel: InputField!
    @IBOutlet weak var descriptionLabel: TextViewField!
    @IBOutlet weak var titleLabel: UILabel!
    
    var disposeBag = DisposeBag()
    var vm = EditBoatViewModel()
    var id: String?
    
    var boatData: BoatDatas?
    var createBoatListing: CreateBoatListingRequest?
    var details: GetBoatData?
    var boatType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Boats"
        
        checkAndLoadSavedListing()
        bindNetwork()
        setUp()
    }
    
    func setUp(){
        titleLabel.text = "What is the name and description of your \(boatType ?? "")?"

    }
    
    private func checkAndLoadSavedListing() {
        if let savedListing = details {
            print("=== LOADING SAVED BOAT LISTING ===")
            print("Boat name: \(savedListing.name)")
            print("Boat description: \(savedListing.description)")
            
            // Use the saved listing
//            createBoatListing = savedListing
            
            // Populate fields with saved data
            nameLabel.text = savedListing.name
            descriptionLabel.text = savedListing.description
            
            print("Loaded saved boat listing successfully")
            print("===============================")
        } else {
            print("No saved boat listing found, starting fresh")
        }
    }
    
    func checkTextFields() {
        print("Checking text fields...")
        let isNameFilled = !(nameLabel.text.isEmpty)
        let isDescriptionFilled = !(descriptionLabel.text.isEmpty)
        
        print("Description: \(descriptionLabel.text)")
        
    }

    func bindNetwork(){
        vm.output.subscribe(onNext: {[weak self] response in
            LoadingModal.dismiss()
            
            switch response {
            case .editBoatSuccessful(let response):
                print(response)
                MiddleModal.show(title: response.message ?? "", type: .success, onConfirm: { self?.coordinator?.popToBoatOptionsScreen() })
                
            case .editBoatFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
            
        }).disposed(by: disposeBag)
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        guard let id = id else { return }
        
        if createBoatListing == nil{
            createBoatListing = CreateBoatListingRequest()
        }
            createBoatListing?.name = nameLabel.text
            createBoatListing?.description = descriptionLabel.text
            
            print(createBoatListing)
            
        if let createBoatListing = createBoatListing {
            LoadingModal.show(title: "Updating Record...")
            vm.editBoat(createBoatListing, id: id)
            
            
        }

    }
    
}
