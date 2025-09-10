//
//  ChatView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 07/02/2025.
//

import UIKit
import RxSwift
import SDWebImage

class ChatView: BaseViewControllerPlain {
    
    var coordinator: MessagesCoordinator?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: InputField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var hostImage: UIImageView!
    @IBOutlet weak var bookingImage: UIImageView!
    @IBOutlet weak var bookingTitleLabel: UILabel!
    @IBOutlet weak var bookingDateLabel: UILabel!
    @IBOutlet weak var bookingView: UIView!
    @IBOutlet weak var generateInvoiceBtn: UIButton!
    
    var conversationId: String?
    var bookingId: String?
    var propertyType: String?
    var otherUser: String = ""
    var messages: [ChatMessage] = []
//    {
//        didSet {
//            tableView.reloadData()
//            scrollToBottom()
//        }
//    }

    var vm: ChatVM!
    let disposeBag = DisposeBag()
    let input = PublishSubject<ChatVM.Input>()
    let user = UserSession.shared.userDetails?.first_name
    let userRoles = UserSession.shared.userDetails?.roles
    let serviceRoles: [HostType] = [.chef, .dj, .bouncer]
    
    let invoiceVm = SendInvoiceVM()
    let invoiceInput = PublishSubject<SendInvoiceVM.Input>()
    
    var chatResponse: SendChatResponseData?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let conversationId = conversationId {
            vm = ChatVM(conversationId: conversationId)
        }
        setup()
        bind()
        bindInvoice()
    }
    
    func validateServiceRole() -> Bool {
        guard let userRoles = userRoles else { return false }
        
        let serviceRoleStrings = serviceRoles.map { $0.rawValue }
        return userRoles.contains { serviceRoleStrings.contains($0) }
    }
    
    func setup() {
        
        generateInvoiceBtn.setTitle("", for: .normal)
        generateInvoiceBtn.setImage(UIImage(named: "generateInvoice"), for: .normal)
        bookingView.isHidden = true
        generateInvoiceBtn.isHidden = !validateServiceRole()
        hostNameLabel.text = otherUser
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MessageViewCell", bundle: nil), forCellReuseIdentifier: "MessageViewCell")
        
        sendButton.isEnabled = false // Disable initially
//        sendButton.isUserInteractionEnabled = false
        sendButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendButtonTapped)))
        messageTextField.textChanged = { [weak self] _, _, _ in
            self?.textFieldChanged()
        }
    }
    
    
    func showBeachProperty(with data: BeachHouseBooking?){
        
        let bookingImageData = data?.beachHouse?.image ?? ""
        if let url = URL(string: bookingImageData.replacingOccurrences(of: "http://", with: "https://")) {
            bookingImage.sd_setImage(with: url, placeholderImage: UIImage(named: "dummy"))
        } else {
            bookingImage.image = UIImage(named: "dummy")
        }
        
        bookingTitleLabel.text = data?.beachHouse?.name
        bookingDateLabel.text = "\(data?.checkingDate.convertToShorterDateFormat() ?? "") - \(data?.checkoutDate.convertToShorterDateFormat() ?? "")"
    }
    
    func showBoatProperty(with data: BoatBooking?){
        
        let bookingImageData = data?.boat?.images?.first?.url ?? ""
        if let url = URL(string: bookingImageData.replacingOccurrences(of: "http://", with: "https://")) {
            bookingImage.sd_setImage(with: url, placeholderImage: UIImage(named: "dummy"))
        } else {
            bookingImage.image = UIImage(named: "dummy")
        }
        
        bookingTitleLabel.text = data?.boat?.name
        bookingDateLabel.text = data?.bookingDate?.convertToShorterDateFormat()
    }

    func textFieldChanged() {
//        sendButton.isUserInteractionEnabled = !(messageTextField.text.isEmpty)
        sendButton.isEnabled = !(messageTextField.text.isEmpty)
    }
    
    @IBAction func generateInvoiceTapped(_ sender: Any) {
        CreateInvoiceModal.show(on: self.view, completion: {[weak self] result in
            print(result)
            LoadingModal.show()
            let request = CreateInvoiceRequest(property_type: self?.propertyType ?? "", booking_id: self?.bookingId ?? "", amount: result.amount, agreement_description: result.note, conversation_id: self?.conversationId ?? "")
            self?.invoiceInput.onNext(.createInvoice(request))
        })
    }
    
   @objc func sendButtonTapped(_ sender: Any) {
        guard let conversationId = conversationId else { return }
        let message = messageTextField.text
        
        let request = SendChatRequest(conversation_id: conversationId, message: message)
        input.onNext(.sendChat(request)) // Send chat message
        messageTextField.text = ""
        sendButton.isEnabled = false
//       sendButton.isUserInteractionEnabled = false
    }
    
    func bind() {
        vm.transform(input: input)
        
        vm.output
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                
                switch data {
                case .sendChatSuccess(let response):
                    print("Sent: \(response)")
                    if let lastMessage = response.data?.lastMessage {
                        let newMessage = ChatMessage(
                            message: lastMessage,
                            name: user,
                            time: "",
                            bookingDetail: nil,
                            paymentData: nil
                        )
                        self.messages.append(newMessage)
                        self.tableView.reloadData()
                        self.scrollToBottom()
                    }
                case .sendChatFailed(let error):
                    print("Error: \(error)")

                case .newMessageReceived(let message):
//                    self.messages.append(message)
                    print("New message: \(message)")
                    if let lastMessage = message.lastMessage {
                        let newMessage = ChatMessage(
                            message: lastMessage,
                            name: user,
                            time: getCurrentDateTime(),
                            bookingDetail: nil,
                            paymentData: nil
                        )
                        self.messages.append(newMessage)
                        self.tableView.reloadData()
                        self.scrollToBottom()
                    }

                case .getMessageHistorySuccess(let response):
                    print("Loaded: \(response)")
                    self.messages = response.data?.data.reversed().map { messageData in
                        let provider = messageData.payload?.providerBookingDetail
                        
                        if let boatBooking = provider?.boatBooking {
                            self.showBoatProperty(with: boatBooking)
                            self.bookingView.isHidden = false
                        }else if let beachHouseBooking = provider?.beachHouseBooking {
                            self.showBeachProperty(with: beachHouseBooking)
                            self.bookingView.isHidden = false
                        }else{
                            self.bookingView.isHidden = true
                        }

                        let bookingDetails = InvoiceBookingDetails(
                            name: provider?.serviceProvider.firstName ?? "",
                            roles: provider?.serviceProvider.roles ?? [],
                            agreementDescription: provider?.agreementDescription ?? "",
                            bookingDate: provider?.bookingDate ?? "",
                            amount: provider?.amount ?? 0,
                            total: provider?.total ?? 0,
                            serviceProviderID: provider?.serviceProvider.id ?? ""
                        )

                        return ChatMessage(
                            message: messageData.message,
                            name: messageData.senderName,
                            time: messageData.createdAt,
                            bookingDetail: bookingDetails,
                            paymentData: messageData.payload?.paymentData
                        )
                    } ?? []

                    self.tableView.reloadData()
                    self.scrollToBottom()

                case .getMessageHistoryFailed(let error):
                    print("Error: \(error)")
                }
            })
            .disposed(by: disposeBag)
        
        // Fetch existing chat history
        if let conversationId = conversationId {
            input.onNext(.getChatHistory(conversationId: conversationId))
        }
    }
    
    func bindInvoice(){
        invoiceVm.transform(input: invoiceInput)
        
        invoiceVm.output.subscribe(onNext: {[weak self] event in
            guard let self = self else { return }

            LoadingModal.dismiss()
            switch event {
                
            case .createInvoiceSuccess(let response):
                let detail = response.data?.bookingDetail
                let bookingDetails = InvoiceBookingDetails(name: detail?.serviceProvider.firstName ?? "", roles: detail?.serviceProvider.roles ?? [], agreementDescription: detail?.agreementDescription ?? "", bookingDate: detail?.bookingDate ?? "", amount: detail?.amount ?? 0, total: detail?.total ?? 0, serviceProviderID: detail?.serviceProvider.id ?? "")
                
                let newMessage = ChatMessage(
                    message: "Here is the Payment invoice as requested",
                    name: user,
                    time: getCurrentDateTime(),
                    bookingDetail: bookingDetails,
                    paymentData: response.data?.paymentData ?? nil
                )
                self.messages.append(newMessage)
                self.tableView.reloadData()
                self.scrollToBottom()
            case .createInvoiceFailed(let error):
                MiddleModal.show(title: "Oops!", subtitle: error.message ?? "Unable to create invoice", type: .error)
            }
        }).disposed(by: disposeBag)
    }
    
    func scrollToBottom() {
        if !messages.isEmpty {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ChatView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageViewCell", for: indexPath) as! MessageViewCell
        
        cell.delegate = self
        cell.configure(with: messages[indexPath.row], at: indexPath)
        return cell
    }
    
    func getCurrentDateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: Date())
    }

}

extension ChatView: MessageViewCellDelegate {
    func didTapPaymentLink(for message: ChatMessage, at indexPath: IndexPath) {
        // Handle payment link tap
        print("Payment link tapped for message at row: \(indexPath.row)")
        navigateToPaymentPage(with: message)
    }
    
    private func navigateToPaymentPage(with message: ChatMessage) {
        guard let paymentData = message.paymentData, let bookingDetail = message.bookingDetail else { return }
        coordinator?.gotoConfirmServiceBookingView(paymentData: paymentData, bookingDetail: bookingDetail)
    }
}

public struct ChatMessage: Codable{
    let message: String?
    let name: String?
    let time: String?
    let bookingDetail: InvoiceBookingDetails?
    let paymentData: PaymentData?
}


struct InvoiceBookingDetails: Codable{
    let name: String
    let roles: [String]
    let agreementDescription: String
    let bookingDate: String
    let amount, total: Float
    let serviceProviderID: String
}
