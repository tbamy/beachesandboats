//
//  ChatVM.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 08/02/2025.
//

import RxSwift

class ChatVM {
    private let disposeBag = DisposeBag()
    private let chatService: ChatsService
    private let pusherService: PusherManager
    let output = PublishSubject<Output>()
    
    enum Input {
        case sendChat(SendChatRequest)
        case getChatHistory(conversationId: String)
    }
    
    enum Output {
        case sendChatSuccess(SendChatResponse)
        case sendChatFailed(ErrorResponse)
        case newMessageReceived(SendChatResponseData)
        
        case getMessageHistorySuccess(GetMessageHistoryResponse)
        case getMessageHistoryFailed(ErrorResponse)
    }
    
    init(conversationId: String, chatService: ChatsService = ChatServiceImplementation(), pusherService: PusherManager = PusherManager.shared) {
        self.chatService = chatService
        self.pusherService = pusherService
        pusherService.setupPusher(conversationId: conversationId) // Subscribe to the conversation
        observePusherUpdates()
    }
    
    func transform(input: PublishSubject<Input>) {
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .sendChat(let request):
                self?.sendChat(request: request)
            case .getChatHistory(let conversationId):
                self?.getMessageHistory(conversationId: conversationId)
            }
        }).disposed(by: disposeBag)
    }
    
    func sendChat(request: SendChatRequest) {
        chatService.sendChat(request: request, completion:  { [weak self] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.sendChatSuccess(response))
            case .failure(let error):
                self?.output.onNext(.sendChatFailed(error))
            }
        })
    }
    
    func getMessageHistory(conversationId: String) {
        chatService.getMessageHistory(conversationId: conversationId, completion:  { [weak self] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.getMessageHistorySuccess(response))
            case .failure(let error):
                self?.output.onNext(.getMessageHistoryFailed(error))
            }
        })
    }
    
    private func observePusherUpdates() {
        pusherService.newMessageObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] newMessage in
                self?.output.onNext(.newMessageReceived(newMessage))
            })
            .disposed(by: disposeBag)
    }
}

