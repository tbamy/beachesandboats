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
    var data: StartConversationData?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: InputField!
    @IBOutlet weak var sendButton: UILabel!
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var hostImage: UIImageView!
    @IBOutlet weak var bookingImage: UIImageView!
    @IBOutlet weak var bookingTitleLabel: UILabel!
    @IBOutlet weak var bookingDateLabel: UILabel!
    @IBOutlet weak var bookingPriceLabel: UILabel!
    
    var conversationId: String?
    var messages: [SendChatResponseData] = []
    
    var vm: ChatVM!
    let disposeBag = DisposeBag()
    let input = PublishSubject<ChatVM.Input>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let conversationId = conversationId else { return } // Ensure we have a conversationId
        vm = ChatVM(conversationId: conversationId) // Pass conversationId to VM

        bind()
        setup()
    }
    
    func setup(){
        
        
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UINib(nibName: "MessageViewCell", bundle: nil), forCellReuseIdentifier: "MessageViewCell")
    }

    @IBAction func sendButtonTapped(_ sender: UIButton) {
        guard let conversationId = conversationId else { return }
        let message = messageTextField.text
        let request = SendChatRequest(conversation_id: conversationId, message: message)
        input.onNext(.sendChat(request)) // Send chat message
        messageTextField.text = ""
    }
    
    func bind() {
        vm.transform(input: input)
        
        vm.output
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                switch data {
                case .sendChatSuccess(let response):
                    print("Sent: \(response)")
                
                case .sendChatFailed(let error):
                    print("Error: \(error)")

                case .newMessageReceived(let message):
                    self?.messages.append(message)
                    self?.tableView.reloadData()
                case .getMessageHistorySuccess(let response):
                    print("Sent: \(response)")
                case .getMessageHistoryFailed(let error):
                    print("Error: \(error)")
                }
            })
            .disposed(by: disposeBag)
    }
}


//extension ChatView: UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//    
//    
//}
