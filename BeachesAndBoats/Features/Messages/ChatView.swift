//
//  ChatView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 07/02/2025.
//

import UIKit
import RxSwift

class ChatView: BaseViewControllerPlain {
    
    var coordinator: ExploreCoordinator?
    var chatcoordinator: MessagesCoordinator?
//    var data: StartConversationData?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: InputField!
    @IBOutlet weak var sendButton: UILabel!
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var hostImage: UIImageView!
    @IBOutlet weak var bookingImage: UIImageView!
    @IBOutlet weak var bookingTitleLabel: UILabel!
    @IBOutlet weak var bookingDateLabel: UILabel!
    @IBOutlet weak var bookingPriceLabel: UILabel!
    @IBOutlet weak var bookingView: UIView!
    
    var conversationId: String?
    var messages: [ChatMessage] = [] {
        didSet {
            tableView.reloadData()
            scrollToBottom()
        }
    }

    var vm: ChatVM!
    let disposeBag = DisposeBag()
    let input = PublishSubject<ChatVM.Input>()
    
    var chatResponse: SendChatResponseData?
//    var chatMessages: [ChatMessage]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let conversationId = conversationId else { return } // Ensure we have a conversationId
        vm = ChatVM(conversationId: conversationId) // Pass conversationId to VM

        setup()
        bind()
    }
    
    func setup() {
        bookingView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MessageViewCell", bundle: nil), forCellReuseIdentifier: "MessageViewCell")
        
//        sendButton.isEnabled = false // Disable initially
        sendButton.isUserInteractionEnabled = false
        sendButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendButtonTapped)))
        messageTextField.onTextChanged = { [weak self] _ in
            self?.textFieldChanged()
        }
    }

    func textFieldChanged() {
        sendButton.isUserInteractionEnabled = !(messageTextField.text.isEmpty)
//        sendButton.isEnabled = !(messageTextField.text.isEmpty)
    }

   @objc func sendButtonTapped(_ sender: Any) {
        guard let conversationId = conversationId else { return }
        let message = messageTextField.text
        
        let request = SendChatRequest(conversation_id: conversationId, message: message)
        input.onNext(.sendChat(request)) // Send chat message
        messageTextField.text = ""
//        sendButton.isEnabled = false
       sendButton.isUserInteractionEnabled = false
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
                
                case .sendChatFailed(let error):
                    print("Error: \(error)")

                case .newMessageReceived(let message):
//                    self.messages.append(message)
                    print("New message: \(message)")

                case .getMessageHistorySuccess(let response):
//                    self.messages = response.data?.data ?? [] // Ensure history loads correctly
                    print("Loaded: \(response)")

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
