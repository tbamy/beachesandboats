//
//  StartConversationVM.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 07/02/2025.
//

import Foundation
import RxSwift

class StartConversationVM{
    private let disposeBag = DisposeBag()
    private let chatService: ChatsService
    let output = PublishSubject<Output>()
    
    enum Input {
        case startConversation(StartConversationRequest)
    }
    
    enum Output {
        case startConversationSuccess(StartConversationResponse)
        case startConversationFailed(ErrorResponse)
    }
    
    
    init(chatService: ChatsService = ChatServiceImplementation()) {
        self.chatService = chatService
    }
    
    func transform(input: PublishSubject<Input>) {
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .startConversation(let request):
                self?.startConversation(request: request)
            }
        }).disposed(by: disposeBag)
    }
    
    func startConversation(request: StartConversationRequest) {
        chatService.startConversation(request: request, completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.startConversationSuccess(response))
            case .failure(let error):
                self?.output.onNext(.startConversationFailed(error))
            }
        })
    }
}
