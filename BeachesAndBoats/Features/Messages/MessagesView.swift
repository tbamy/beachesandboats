//
//  MessagesView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 03/10/2024.
//

import UIKit
import RxSwift

class MessagesView: BaseViewControllerPlain {

    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var emptyMessageState: UIView!
    
    var coordinator: MessagesCoordinator?
    
    var vm = ConversationsVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<ConversationsVM.Input>()
    
    var messages: [GetConversationsData] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Message"
        setupTable()
        
        bind()
        
        LoadingModal.show()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input.onNext(.getConversations)
    }
    
    func setupTable() {
        emptyMessageState.isHidden = true
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(UINib(nibName: "ConversationsViewCell", bundle: nil), forCellReuseIdentifier: "ConversationsViewCell")
        chatTableView.reloadData()
        
        updateTableViewHeight(chatTableView, tableHeightConstraint)
    }
    
    func updateTableViewHeight(_ tableView: UITableView, _ tableViewHeightConstraint: NSLayoutConstraint) {
        tableView.layoutIfNeeded()
        let contentHeight = tableView.contentSize.height
        tableViewHeightConstraint.constant = contentHeight
        
        self.view.layoutIfNeeded()
    }
    
    func bind(){
        vm.transform(input: input)

        vm.output.subscribe(onNext: {[weak self] event in
            guard let self = self else { return }
            LoadingModal.dismiss()
            switch event {
            case .getConversationsSuccess(let response):
                self.messages = response.data ?? []
                if self.messages.isEmpty{
                    emptyMessageState.isHidden = false
                    chatTableView.isHidden = true
                }
                chatTableView.reloadData()
            case .getConversationsFailed(let error):
                MiddleModal.show(title: error.message ?? "", type: .error, onConfirm: { self.coordinator?.pop()} )
            }
        }).disposed(by: disposeBag)
    }
}

extension MessagesView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationsViewCell", for: indexPath) as! ConversationsViewCell
        //update the cell
        cell.configure(with: messages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mes = messages[indexPath.row]
//        let data = ChatMessage(message: mes.lastMessage, name: mes.otherUser.firstName, time: "")
        coordinator?.gotoChat(bookingId: mes.bookingID ?? "", otherUser: mes.otherUser?.firstName ?? "", conversationId: mes.id, propertyType: mes.propertyType ?? "")
    }
    
}
