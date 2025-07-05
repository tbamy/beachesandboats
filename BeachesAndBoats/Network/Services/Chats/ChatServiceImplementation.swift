//
//  ChatServiceImplementation.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 06/02/2025.
//

import Foundation
import Moya

class ChatServiceImplementation: Provider<ChatsTarget>, ChatsService {
    func startConversation(request: StartConversationRequest, completion: @escaping (Result<StartConversationResponse, ErrorResponse>) -> Void) {
        provider.request(.startConversation(request)) { completion(self.handleResult(result: $0))}
    }
    
    func sendChat(request: SendChatRequest, completion: @escaping (Result<SendChatResponse, ErrorResponse>) -> Void) {
        provider.request(.sendChat(request)) { completion(self.handleResult(result: $0))}
    }
    
    func getConversations(completion: @escaping (Result<GetConversationsResponse, ErrorResponse>) -> Void) {
        provider.request(.getConversations) { completion(self.handleResult(result: $0))}
    }
    
    func getMessageHistory(conversationId: String, completion: @escaping (Result<GetMessageHistoryResponse, ErrorResponse>) -> Void) {
        provider.request(.getMessageHistory(conversationId: conversationId)) { completion(self.handleResult(result: $0))}
    }
    
    
}
