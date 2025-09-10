//
//  ConfirmBoatBookingView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 06/02/2025.
//

import UIKit
import RxSwift

class ConfirmBoatBookingView: BaseViewControllerPlain {
    
    var coordinator: ExploreCoordinator?
    
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var editDateBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var editTimeBtn: UIButton!
    @IBOutlet weak var guestLabel: UILabel!
    @IBOutlet weak var editGuestBtn: UIButton!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var costAmountLabel: UILabel!
    @IBOutlet weak var cleaningFeeLabel: UILabel!
    @IBOutlet weak var serviceFeeLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var cancellationPolicyLabel: UILabel!
    
    @IBOutlet weak var cruiseLengthStack: UIStackView!
    @IBOutlet weak var cruiseLengthBtn: UIButton!
    @IBOutlet weak var cruiseLengthLabel: UILabel!
    
//    var room: BookingRoom?
    var boatId: String?
    var listing: GetBoatData?
    var booking: CreateBoatBookingRequest?
    var configuration: BookingConfigurationData?
    var bookingTime: String?
    var numberOfGuests: Int?
    var bookingDate: String?
    var cruiseLength: Int?
    
    
    let vm = BookingConfigurationVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<BookingConfigurationVM.Input>()
    
    let user = UserSession.shared.userDetails?.id
    
    var accessCode: String?
    var amount: Float?
    var selectedDestination: Destination?
    
    var totalCost: Float = 0
    var serviceCost: Float = 0
    var boatCapacity = 1
    
    var picker = UIDatePicker()
    
    var bookingResponse: BoatBookingResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Confirm Booking"
        
        bind()
        LoadingModal.show()
        input.onNext(.getBookingConfiguration)
    }
    
    func setup(){
        
        configureButtons()

        bookingDate = booking?.bookingDate ?? ""
        bookingTime = booking?.bookingTime ?? ""
        cruiseLength = booking?.cruiseLength ?? 0
        numberOfGuests = booking?.numberOfPeople ?? 1
        
//        if let adults = listing?.noOfAdults, let children = listing?.noOfChildren {
//            boatCapacity = (Int(adults) ?? 0) + (Int(children) ?? 0)
//        } else {
            boatCapacity = Int(listing?.noOfPassengers ?? "1") ?? 1
//        }

        
        
        datesLabel.text = "\(bookingDate?.convertToShorterDateFormat() ?? "")"
        if let price = selectedDestination?.price {
            timeLabel.text = bookingTime ?? ""
            guestLabel.text = "\(numberOfGuests ?? 1)"
            
            if booking?.bookingType == "TRIP"{
                cruiseLengthStack.isHidden = true
                costLabel.text = "Boat Fee (\(selectedDestination?.name ?? "")/trip)"
                totalCost = Float(price) ?? 0
            }else if booking?.bookingType == "CRUISE"{
                cruiseLengthStack.isHidden = false
                cruiseLengthLabel.text = "\(cruiseLength ?? 0) Hours"
                costLabel.text = "Boat Fee x \(cruiseLength ?? 0) Hours"
                totalCost = (Float(price) ?? 0) * Float(cruiseLength ?? 0)
                
            }
            
            serviceCost = configuration?.boatServiceFee ?? 0
            costAmountLabel.text = "₦ \(totalCost)"
//            cleaningFeeLabel.text = "₦ \(configurationCost)"
            cancellationPolicyLabel.text = configuration?.cancellationPolicy
            let serviceFee = (totalCost * serviceCost) / 100 
            let finalTotal = totalCost + serviceFee
            
            serviceFeeLabel.text = "₦ \(serviceFee.toAmount() ?? "0")"
            totalAmountLabel.text = "₦ \(finalTotal.toAmount() ?? "0")"
            amount = finalTotal
        }
        

    
        

    }

    @IBAction func makePaymentTapped(_ sender: Any) {
        if var bookingRequest = booking{
            bookingRequest.bookingTime = bookingTime ?? ""
            bookingRequest.bookingDate = bookingDate ?? ""
            bookingRequest.numberOfPeople = numberOfGuests ?? 1
            bookingRequest.cruiseLength = cruiseLength ?? 0
            
            print(bookingRequest)
            
            LoadingModal.show()
            vm.createBoatBooking(request: bookingRequest)
        }
    }
    
    @IBAction func editTimeBtnTapped(_ sender: Any) {
        showTimePicker(title: "Select Check-in Time") { [weak self] selectedTime in
            guard let self = self else { return }
            self.bookingTime = selectedTime.toBackendTime()
            timeLabel.text = bookingTime ?? ""
        }
    }
    
    
    @IBAction func editGuestBtnTapped(_ sender: Any) {
        showGuestPicker()
    }
    
    @IBAction func editDateBtnTapped(_ sender: Any) {
        HorizonCalendarModal.show { [weak self] startDate, endDate in
            guard let self = self else { return }
            if endDate == nil{
                if let startDate = startDate{
                    print("\(startDate)")
                    self.bookingDate = startDate.toBackendDate()
                    print("\(bookingDate)")
                    self.datesLabel.text = bookingDate?.convertToShorterDateFormat()
                }
            }
        }
    }
    
    @IBAction func cruiseLengthBtnTapped(_ sender: Any) {
        showCruiseLengthPicker()
    }
    
    func setupPicker(){
        picker.timeZone = .current
        picker.datePickerMode = .time
        picker.locale = Locale(identifier: "en_US_POSIX") // Ensures consistent AM/PM handling
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        

    }
    

    
    func configureButtons(){
        editDateBtn.configureButtonTitle(title: "Edit")
        editDateBtn.setTitleColor(.B_B, for: .normal)
        
        editTimeBtn.configureButtonTitle(title: "Edit")
        editTimeBtn.setTitleColor(.B_B, for: .normal)
        
        editGuestBtn.configureButtonTitle(title: "Edit")
        editGuestBtn.setTitleColor(.B_B, for: .normal)
        
        cruiseLengthBtn.configureButtonTitle(title: "Edit")
        cruiseLengthBtn.setTitleColor(.B_B, for: .normal)
    }
    
    func bind(){
        vm.transform(input: input)
        
        vm.boatOutput.subscribe(onNext: { [weak self] data in
            LoadingModal.dismiss()
            switch data {
            case .getBookingConfigurationSuccess(let response):
                self?.configuration = response.data
                self?.setup()
//                print(self?.configuration)
                
            case .getBookingConfigurationFailed(let error) :
                MiddleModal.show(title: error.message ?? "", type: .error)
            case .createBoatBookingSuccess(let response):
                self?.bookingResponse = response
                guard let booking = self?.bookingResponse else { return  }
                self?.coordinator?.gotoMakeBoatPayment(bookingResponse: booking)
            case .createBoatBookingFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
        }).disposed(by: disposeBag)
    }
    
    func showTimePicker(title: String, completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title, message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)

        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "en_US_POSIX") // Ensures consistent time format
        picker.calendar = Calendar(identifier: .gregorian) // Avoids unexpected locale behaviors
        picker.timeZone = TimeZone.current

        alert.view.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            picker.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            picker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 40),
            picker.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -40)
        ])

        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss" // Ensures 24-hour format
            formatter.locale = Locale(identifier: "en_US_POSIX") // Ensures correct formatting
            formatter.timeZone = TimeZone.current

            let timeString = formatter.string(from: picker.date)
            completion(timeString)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(confirmAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }


    func showGuestPicker() {
        let alert = UIAlertController(title: "Select Number of People", message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
        alert.view.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            picker.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            picker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 40),
            picker.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -40)
        ])
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            let selectedRow = picker.selectedRow(inComponent: 0)
            self.numberOfGuests = selectedRow + 1
            self.guestLabel.text = "\(self.numberOfGuests ?? 1)"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showCruiseLengthPicker() {
        let alert = UIAlertController(title: "Select Cruise Length", message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
        alert.view.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            picker.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            picker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 40),
            picker.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -40)
        ])
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            let selectedRow = picker.selectedRow(inComponent: 0)
            self.cruiseLength = selectedRow + 1
            self.cruiseLengthLabel.text = "\(self.numberOfGuests ?? 1) hours"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

}

extension ConfirmBoatBookingView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return boatCapacity > 0 ? boatCapacity : 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
}
