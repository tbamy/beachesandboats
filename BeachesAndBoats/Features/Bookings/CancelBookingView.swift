//
//  CancelBookingView.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 28/02/2025.
//

import UIKit
import RxSwift

class CancelBookingView: UIViewController {

    @IBOutlet weak var cancelIcon: UIImageView!
    @IBOutlet weak var complaintField: UITextView!
    @IBOutlet weak var noticeLabel: UILabel!
    
    var coordinator: BookingsCoordinator?
    var bookingType: String?
    var bookingId: String?
    
    var vm = CancelBookingVM()
    let input = PublishSubject<CancelBookingVM.Input>()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gestureRecognizers()
        bind()
        setupUI()
    }
    
    func setupUI() {
        complaintField.layer.borderWidth = 1
        complaintField.layer.borderColor = UIColor.lightGray.cgColor
        complaintField.layer.cornerRadius = 8
    }
    
    func cancelBooking(){
        LoadingModal.show()
        let request = CancelBookingRequest(booking_id: bookingId ?? "", booking_type: bookingType ?? "", reason: complaintField.text ?? "")
        input.onNext(.cancelBoking(request))
    }
    
    func gestureRecognizers() {
        let cancel = UITapGestureRecognizer(target: self, action: #selector(cancelIconTapped))
        cancelIcon.isUserInteractionEnabled = true
        cancelIcon.addGestureRecognizer(cancel)
    }
    
    @objc func cancelIconTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func proceedBtnTapped(_ sender: Any) {
        if complaintField.hasText {
            MiddleModal.show(title: "Your cancelation request has been initiated", subtitle: "", type: .success, primaryText: "Done", dismissable: false, dismissOnConfirm: true, onConfirm: {
                self.dismiss(animated: true)
                self.coordinator?.start()
            })
        } else {
            MiddleModal.show(title: "Error", subtitle: "Kindly write a reason for cancellation", type: .error, primaryText: "Okay", dismissOnConfirm: true)
        }
    }
    
    
    func bind(){
        vm.transform(input: input)
        
        vm.output.subscribe(onNext: { [weak self] response in
            LoadingModal.dismiss()
            
            switch response {

            case .getBookingConfigurationSuccess(let response):
                self?.noticeLabel.text = response.data?.cancellationPolicy
            case .getBookingConfigurationFailed(_):
                self?.noticeLabel.text = "Please note that cancelling may result in penalties or fees. You will only recieve a refund of 50% of the amount paid."
                
            case .cancelBookingSuccess(let response):
                MiddleModal.show(title: "Success", subtitle: response.message ?? "Booking Successfully cancelled", type: .success, primaryText: "Okay", dismissOnConfirm: true)
            case .cancelBookingFailed(let error):
                MiddleModal.show(title: "Error", subtitle: error.message ?? "Could not process your request", type: .error, primaryText: "Try Again", dismissOnConfirm: true, onConfirm: { self?.cancelBooking()} )
            }
            
            
        }).disposed(by: disposeBag)
                
    }
    
}

