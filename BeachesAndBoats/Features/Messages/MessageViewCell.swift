//
//  MessageViewCell.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 31/12/2024.
//

import UIKit

// MARK: - Protocol for MessageViewCell delegate
protocol MessageViewCellDelegate: AnyObject {
    func didTapPaymentLink(for message: ChatMessage, at indexPath: IndexPath)
}

class MessageViewCell: UITableViewCell {
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: BoldLabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var paymentLinkStack: UIStackView!
    @IBOutlet weak var paymentLinkTitle: UILabel!
    @IBOutlet weak var paymentLinkBtn: UIButton!
    
    // MARK: - Delegate and properties
    weak var delegate: MessageViewCellDelegate?
    var chatMessage: ChatMessage?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with message: ChatMessage, at indexPath: IndexPath) {
        self.chatMessage = message
        self.indexPath = indexPath
        
        paymentLinkStack.isHidden = true
        
        let dateString = message.time
        let dateTime = dateString?.separateDateAndTime()
        let time = dateTime?.time
        let date = dateTime?.date
        
        let hasValidBookingDetail = message.bookingDetail?.name.isEmpty == false
        let hasValidPaymentData = message.paymentData != nil

        if hasValidBookingDetail && hasValidPaymentData {
            paymentLinkStack.isHidden = false
            paymentLinkTitle.text = "Payment link for \(message.bookingDetail?.name ?? "")"
            paymentLinkBtn.setUnderlinedTitle("Click here to make payment", for: .normal, color: .beachBlue, font: UIFont.systemFont(ofSize: 12))
        } else {
            paymentLinkStack.isHidden = true
        }

        userName.text = message.name
        timeLbl.text = time
        dateLbl.text = date
        messageLbl.text = message.message
    }
    
    @IBAction func paymentLinkTapped(_ sender: Any) {
        guard let chatMessage = chatMessage,
              let indexPath = indexPath else { return }
        
        // Notify delegate that payment link was tapped
        delegate?.didTapPaymentLink(for: chatMessage, at: indexPath)
    }
}
