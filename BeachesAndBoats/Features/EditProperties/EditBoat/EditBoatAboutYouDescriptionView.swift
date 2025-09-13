//
//  EditBoatAboutYouDescriptionView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/09/2025.
//

import UIKit
import RxSwift

class EditBoatAboutYouDescriptionView: BaseViewControllerPlain {
    var coordinator: HostingServiceMenuCoordinator?
    
    @IBOutlet weak var descriptionLabel: TextViewField!
    
    var boatData: BoatDatas?
    var createBoatListing: CreateBoatListingRequest?
    var boatType: String?
    
    var disposeBag = DisposeBag()
    var vm = EditBoatViewModel()
    var id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Boats"
        
        bindNetwork()
        checkAndLoadSavedListing()
    }
    
    private func checkAndLoadSavedListing() {
        if let savedListing = createBoatListing {
            print("=== LOADING SAVED BOAT LISTING ===")
            print("About owner: \(savedListing.aboutOwner ?? "No description")")
            
            // Use the saved listing
//            createBoatListing = savedListing
            
            // Populate field with saved data
            descriptionLabel.text = savedListing.aboutOwner ?? ""
            
            print("Loaded saved boat listing successfully")
            print("===============================")
        } else {
            print("No saved boat listing found, starting fresh")
        }
    }
    
    
    @IBAction func saveAndExit(_ sender: Any) {
        guard let id = id else { return }
        
        if var createBoatListing = createBoatListing{
            createBoatListing.aboutOwner = descriptionLabel.text
            
            self.createBoatListing = createBoatListing
            print(createBoatListing)
            
            LoadingModal.show(title: "Updating Record...")
            vm.editBoat(createBoatListing, id: id)
            
        }
        
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


}
