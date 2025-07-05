//
//  ChatView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 07/02/2025.
//

import UIKit
import RxSwift

class ChatView: BaseViewControllerPlain {
    
    var coordinator: Coordinator?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: InputField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var hostImage: UIImageView!
    @IBOutlet weak var bookingImage: UIImageView!
    @IBOutlet weak var bookingTitleLabel: UILabel!
    @IBOutlet weak var bookingDateLabel: UILabel!
    @IBOutlet weak var bookingPriceLabel: UILabel!
    @IBOutlet weak var bookingView: UIView!
    
    var conversationId: String?
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
    
    var chatResponse: SendChatResponseData?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let conversationId = conversationId {
            vm = ChatVM(conversationId: conversationId)
        }
        setup()
        bind()
    }
    
    func setup() {
        bookingView.isHidden = true
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

    func textFieldChanged() {
//        sendButton.isUserInteractionEnabled = !(messageTextField.text.isEmpty)
        sendButton.isEnabled = !(messageTextField.text.isEmpty)
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
                            time: ""
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
                            time: ""
                        )
                        self.messages.append(newMessage)
                        self.tableView.reloadData()
                        self.scrollToBottom()
                    }

                case .getMessageHistorySuccess(let response):
                    print("Loaded: \(response)")
                    self.messages = response.data?.data.map { messageData in
                            ChatMessage(
                                message: messageData.message,
                                name: messageData.senderName,
                                time: messageData.createdAt
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
        cell.configure(with: messages[indexPath.row])
        return cell
    }
}

struct ChatMessage: Codable{
    let message: String?
    let name: String?
    let time: String?
}
