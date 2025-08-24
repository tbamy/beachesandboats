//
//  ConfirmServiceBookingView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 21/07/2025.
//

import UIKit
import RxSwift

class ConfirmServiceBookingView: BaseViewControllerPlain {
    
    var coordinator: ExploreCoordinator?
    
    @IBOutlet weak var additionalServiceTitleLabel: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var editDateBtn: UIButton!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var costAmountLabel: UILabel!
    @IBOutlet weak var cleaningFeeLabel: UILabel!
    @IBOutlet weak var serviceFeeLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var cancellationPolicyLabel: UILabel!
    @IBOutlet weak var agreementLabel: UILabel!
    
    var paymentData: PaymentData?
    var bookingDetail: InvoiceBookingDetails?
    
    var configuration: BookingConfigurationData?
    let serviceRoles: [HostType] = [.chef, .dj, .bouncer]
    var userRole: HostType?
    
    
    let vm = BookingConfigurationVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<BookingConfigurationVM.Input>()
    
    let user = UserSession.shared.userDetails?.id
    
    var accessCode: String?
    var amount: Float?
    
    var startDate: String?
    var endDate: String?
    
    
    var picker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Confirm Booking"
        
        bind()
        LoadingModal.show()
        input.onNext(.getBookingConfiguration)
    }
    
    func validateServiceRole() -> String? {
        guard let userRoles = bookingDetail?.roles else { return nil }
        
        let serviceRoleStrings = serviceRoles.map { $0.rawValue }
        return userRoles.first(where: { serviceRoleStrings.contains($0) })
    }
    
    func setup(){
        editDateBtn.isHidden = true
    
        additionalServiceTitleLabel.text = "Additional Services \(validateServiceRole()?.capitalized ?? "")"
        configureButtons()
        agreementLabel.text = "\(bookingDetail?.agreementDescription ?? "")"
        datesLabel.text = "\(bookingDetail?.bookingDate.convertToShortDateFormat() ?? "")"
        
        let thePrice = bookingDetail?.amount
//        print("The Price: \(thePrice)")
        
        if let price = thePrice {
            costLabel.text = "\(validateServiceRole()?.capitalized ?? "") fee (\(bookingDetail?.name ?? ""))"
            
            let serviceCost = configuration?.serviceFee ?? 0
            costAmountLabel.text = "₦ \(price.toAmount() ?? "0")"
//            cleaningFeeLabel.text = "₦ \(configurationCost)"
            cancellationPolicyLabel.text = configuration?.cancellationPolicy
            let serviceFee = (price * serviceCost) / 100
            let finalTotal = price + serviceFee
            serviceFeeLabel.text = "₦ \(serviceFee.toAmount() ?? "0")"
            totalAmountLabel.text = "₦ \(finalTotal.toAmount() ?? "0")"
            amount = finalTotal
        }
        

    }

    @IBAction func makePaymentTapped(_ sender: Any) {
        coordinator?.gotoMakeServicePayment(paymentData: paymentData, bookingDetail: bookingDetail)
    }
    
    
    @IBAction func editDateBtnTapped(_ sender: Any) {
        HorizonCalendarModal.show { [weak self] startDatee, endDatee in
            guard let self = self else { return }
            if endDatee == nil{
                if let startDatee = startDatee{
                    print("\(startDatee)")
                    self.startDate = startDatee.toFormattedDate()
                    self.endDate = startDatee.toFormattedDate()
                    datesLabel.text = "\(startDate?.convertToShortDateFormat() ?? "") - \(endDate?.convertToShortDateFormat() ?? "")"
                }
            }else{
                if let startDatee = startDatee, let endDatee = endDatee{
                    print("\(startDatee) - \(endDatee)")
                    self.startDate = startDatee.toFormattedDate()
                    self.endDate = endDatee.toFormattedDate()
                    datesLabel.text = "\(startDate?.convertToShortDateFormat() ?? "") - \(endDate?.convertToShortDateFormat() ?? "")"
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
    

    
    func configureButtons(){
        editDateBtn.configureButtonTitle(title: "Edit")
        editDateBtn.setTitleColor(.B_B, for: .normal)
        
    }
    
    func bind(){
        vm.transform(input: input)
        
        vm.output.subscribe(onNext: { [weak self] data in
            LoadingModal.dismiss()
            switch data {
            case .getBookingConfigurationSuccess(let response):
                self?.configuration = response.data
                self?.setup()
//                print(self?.configuration)
                
            case .getBookingConfigurationFailed(let error) :
                MiddleModal.show(title: error.message ?? "", type: .error)
                
            case .createBeachHouseBookingSuccess(_):
                break
            case .createBeachHouseBookingFailed(_):
               break
            }
        }).disposed(by: disposeBag)
    }





}

extension ConfirmServiceBookingView: UIPickerViewDelegate, UIPickerViewDataSource {
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

