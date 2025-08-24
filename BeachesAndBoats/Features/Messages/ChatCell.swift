//
//  ChatCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 23/07/2025.
//

import UIKit

public class ChatCell: BaseXib {
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: BoldLabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var paymentLinkStack: UIStackView!
    @IBOutlet weak var paymentLinkTitle: UILabel!
    @IBOutlet weak var paymentLinkBtn: UIButton!
    
    var ontapped: (() -> Void)?
    
    public var message: ChatMessage? {
        didSet {
            setup()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        
        paymentLinkStack.isHidden = true
        
        let dateString = message?.time
        let dateTime = dateString?.separateDateAndTime()
        let time = dateTime?.time
        let date = dateTime?.date
        
        let hasValidBookingDetail = message?.bookingDetail?.name.isEmpty == false
        let hasValidPaymentData = message?.paymentData != nil

        if hasValidBookingDetail && hasValidPaymentData {
            paymentLinkStack.isHidden = false
            paymentLinkTitle.text = "Payment link for \(message?.bookingDetail?.name ?? "")"
            paymentLinkBtn.setUnderlinedTitle("Click here to make payment", for: .normal, color: .beachBlue, font: UIFont.systemFont(ofSize: 12))
        } else {
            paymentLinkStack.isHidden = true
        }

        userName.text = message?.name
        timeLbl.text = time
        dateLbl.text = date
        messageLbl.text = message?.message
    }
    
    @IBAction func paymentLinkTapped(_ sender: Any) {
        ontapped?()
    }
}

