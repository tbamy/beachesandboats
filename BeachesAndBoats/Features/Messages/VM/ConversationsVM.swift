//
//  ConversationsVM.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 20/02/2025.
//

import Foundation
import RxSwift

class ConversationsVM{
    private let disposeBag = DisposeBag()
    private let chatsService: ChatsService
    let output = PublishSubject<Output>()
    
    enum Input {
        case getConversations
    }
    
    enum Output {
        case getConversationsSuccess(GetConversationsResponse)
        case getConversationsFailed(ErrorResponse)
    }
    
    init(chatsService: ChatsService = ChatServiceImplementation()) {
        self.chatsService = chatsService
    }
    
    func transform(input: PublishSubject<Input>) {
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .getConversations:
                self?.getConversations()
            }
        }).disposed(by: disposeBag)
    }
    
    func getConversations() {
        chatsService.getConversations(completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.getConversationsSuccess(response))
            case .failure(let error):
                self?.output.onNext(.getConversationsFailed(error))
            }
        })
    }
}
