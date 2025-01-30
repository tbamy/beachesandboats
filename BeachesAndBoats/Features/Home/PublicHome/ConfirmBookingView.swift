//
//  ConfirmBookingView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 02/01/2025.
//

import UIKit
import RxSwift

class ConfirmBookingView: BaseViewControllerPlain {
    
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
    
    var room: BookingRoom?
    var roomId: String?
    var listing: Listing?
    var booking: CreateBeachHouseBookingRequest?
    var configuration: BookingConfigurationData?
    var checkInTime: String?
    var checkOutTime: String?
    var numberOfGuests: Int?
    var startDate: String?
    var endDate: String?
    
    
    let vm = BookingConfigurationVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<BookingConfigurationVM.Input>()
    
    let user = UserSession.shared.userDetails?.id
    
    var accessCode: String?
    var amount: Float?
    
    
    var picker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Confirm Booking"
        
        bind()
        LoadingModal.show()
        input.onNext(.getBookingConfiguration)
    }

    @IBAction func makePaymentTapped(_ sender: Any) {
        if var bookingRequest = booking{
            bookingRequest.amount = amount ?? 0
            bookingRequest.userId = user ?? ""
            bookingRequest.beachHouseRoomId = roomId ?? ""
            bookingRequest.checkingTime = checkInTime?.toBackendTime() ?? ""
            bookingRequest.checkoutTime = checkOutTime?.toBackendTime() ?? ""
            bookingRequest.numberOfPeople = numberOfGuests ?? 1
            
            bookingRequest.units = 1 //temporary, would update
            
            print(bookingRequest)
            
            LoadingModal.show()
            vm.createBeachHouseBooking(request: bookingRequest)
        }
    }
    
    @IBAction func editTimeBtnTapped(_ sender: Any) {
        showTimePicker(title: "Select Check-in Time") { [weak self] selectedTime in
            guard let self = self else { return }
            self.checkInTime = selectedTime
            self.showTimePicker(title: "Select Check-out Time") { selectedTime in
                self.checkOutTime = selectedTime
                self.timeLabel.text = "\(self.checkInTime ?? "") - \(self.checkOutTime ?? "")"
            }
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
                    self.startDate = startDate.toFormattedDate()
                    self.endDate = startDate.toFormattedDate()
                }
            }else{
                if let startDate = startDate, let endDate = endDate{
                    print("\(startDate) - \(endDate)")
                    self.startDate = startDate.toFormattedDate()
                    self.endDate = endDate.toFormattedDate()
                }
            }
        }
    }
    
    func setupPicker(){
        picker.timeZone = .current
        picker.datePickerMode = .time
        picker.locale = Locale(identifier: "en_US_POSIX") // Ensures consistent AM/PM handling
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        

    }
    
    func calculateNights(from startDateString: String, to endDateString: String, format: String = "MM/dd/yyyy") -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        print("From: \(startDateString) - To: \(endDateString)")
        guard let startDate = dateFormatter.date(from: startDateString),
              let endDate = dateFormatter.date(from: endDateString) else {
            return nil
        }
        
        guard endDate > startDate else { return nil }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        return components.day
    }
    
    func setup(){
        
        configureButtons()
        
        room = listing?.rooms?.first { $0.id == roomId }

        startDate = booking?.checkingDate ?? ""
        endDate = booking?.checkoutDate ?? ""
        checkInTime = listing?.checkInFrom
        checkOutTime = listing?.checkOutTo
        numberOfGuests = room?.noOfOccupant ?? 0
        
        let nights = calculateNights(from: startDate ?? "", to: endDate ?? "") ?? 0
        
        datesLabel.text = "\(startDate?.convertToShorterDateFormat() ?? "") - \(endDate?.convertToShorterDateFormat() ?? "") (\(nights) Nights)"
//        timeLabel
        if let price = room?.pricePerNight {
            timeLabel.text = "\(checkInTime ?? "") - \(checkOutTime ?? "")"
            guestLabel.text = "\(numberOfGuests ?? 0) Guests"
            costLabel.text = "₦\(price ?? 0) x \(nights) Nights"
            let totalCost = (price ?? 0) * Float(nights)
//            let configurationCost = configuration?.roomCleaningFee ?? 0
            let serviceCost = configuration?.houseServiceFee ?? 0
            costAmountLabel.text = "₦ \(totalCost)"
//            cleaningFeeLabel.text = "₦ \(configurationCost)"
            serviceFeeLabel.text = "₦ \(serviceCost)"
            cancellationPolicyLabel.text = configuration?.cancellationPolicy
            let finalTotal = totalCost + serviceCost
            totalAmountLabel.text = "₦ \(finalTotal)"
            amount = finalTotal
        }
        

    }
    
    func configureButtons(){
        editDateBtn.configureButtonTitle(title: "Edit")
        editDateBtn.setTitleColor(.B_B, for: .normal)
        
        editTimeBtn.configureButtonTitle(title: "Edit")
        editTimeBtn.setTitleColor(.B_B, for: .normal)
        
        editGuestBtn.configureButtonTitle(title: "Edit")
        editGuestBtn.setTitleColor(.B_B, for: .normal)
    }
    
    func bind(){
        vm.transform(input: input)
        
        vm.output.subscribe(onNext: { [weak self] data in
            LoadingModal.dismiss()
            switch data {
            case .getBookingConfigurationSuccess(let response):
                self?.configuration = response.data
                self?.setup()
                print(self?.configuration)
                
            case .getBookingConfigurationFailed(let error) :
                MiddleModal.show(title: error.message ?? "", type: .error)
            case .createBeachHouseBookingSuccess(let response):
                self?.accessCode = response.data?.paymentData?.accessCode
                self?.coordinator?.gotoMakePayment(accessCode: self?.accessCode ?? "")
            case .createBeachHouseBookingFailed(let error):
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
        let alert = UIAlertController(title: "Select Number of Guests", message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        
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
            self.guestLabel.text = "\(self.numberOfGuests ?? 1) Guests"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

}

extension ConfirmBookingView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10 // Maximum number of guests
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1) Guests"
    }
}

