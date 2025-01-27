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
    
    let vm = BookingConfigurationVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<BookingConfigurationVM.Input>()
    
    let user = UserSession.shared.userDetails?.id
    
    var accessCode: String?
    var amount: Float?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Confirm Booking"
        
        bind()
        LoadingModal.show()
        input.onNext(.getBookingConfiguration)
        setup()
    }

    @IBAction func makePaymentTapped(_ sender: Any) {
        if var bookingRequest = booking{
            bookingRequest.amount = amount ?? 0
            bookingRequest.userId = user ?? ""
            bookingRequest.beachHouseRoomId = roomId ?? ""
            print(bookingRequest)
            
            LoadingModal.show()
            vm.createBeachHouseBooking(request: bookingRequest)
        }
    }
    
    @IBAction func editTimeBtnTapped(_ sender: Any) {
        if let bookingRequest = booking{
            LoadingModal.show()
            vm.createBeachHouseBooking(request: bookingRequest)
        }
    }
    
    @IBAction func editGuestBtnTapped(_ sender: Any) {
        if let bookingRequest = booking{
            LoadingModal.show()
            vm.createBeachHouseBooking(request: bookingRequest)
        }
    }
    
    @IBAction func editDateBtnTapped(_ sender: Any) {
        HorizonCalendarModal.show { [weak self] startDate, endDate in
            guard let self = self else { return }
            if endDate == nil{
                if let startDate = startDate{
                    print("\(startDate)")
                }
            }else{
                if let startDate = startDate, let endDate = endDate{
                    print("\(startDate) - \(endDate)")
                    
                }
            }
        }
    }
    
    
    func validateRequest() -> Bool{
        if let beachHouseRoomId = booking?.beachHouseRoomId, let userId = booking?.userId, let checkingDate = booking?.checkingDate, let checkoutDate = booking?.checkoutDate, let checkingTime = booking?.checkingTime, let checkoutTime = booking?.checkoutTime, let amount = booking?.amount, let units = booking?.units{
            return true
        }
        
        return false
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
        print(configuration)
        
        configureButtons()
        let startDateString = booking?.checkingDate ?? ""
        let endDateString = booking?.checkoutDate ?? ""
        let checkingTime = listing?.checkInFrom ?? ""
        let checkoutTime = listing?.checkOutTo ?? ""
        let guests = room?.noOfOccupant ?? 0
        
        let nights = calculateNights(from: startDateString, to: endDateString) ?? 0
        
        datesLabel.text = "\(startDateString.convertToShorterDateFormat() ?? "") - \(endDateString.convertToShorterDateFormat() ?? "") (\(nights) Nights)"
//        timeLabel
        if let price = room?.pricePerNight {
            timeLabel.text = "\(checkingTime) - \(checkoutTime)"
            guestLabel.text = "\(guests) Guests"
            costLabel.text = "\(price ?? 0) x \(nights)Nights"
            let totalCost = (price ?? 0) * Float(nights)
            let configurationCost = configuration?.roomCleaningFee ?? 0
            let serviceCost = configuration?.houseServiceFee ?? 0
            costAmountLabel.text = "₦ \(totalCost)"
            cleaningFeeLabel.text = "₦ \(configurationCost)"
            serviceFeeLabel.text = "₦ \(serviceCost)"
            cancellationPolicyLabel.text = configuration?.cancellationPolicy
            let finalTotal = totalCost + serviceCost + configurationCost
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
}
