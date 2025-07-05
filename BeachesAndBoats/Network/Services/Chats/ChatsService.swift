//
//  ChatsService.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 06/02/2025.
//

import Foundation

protocol ChatsService {
    func startConversation(request: StartConversationRequest , completion: @escaping(Result<StartConversationResponse, ErrorResponse>) -> Void)
    func sendChat(request: SendChatRequest , completion: @escaping(Result<SendChatResponse, ErrorResponse>) -> Void)
    func getConversations(completion: @escaping(Result<GetConversationsResponse, ErrorResponse>) -> Void)
    func getMessageHistory(conversationId: String, completion: @escaping(Result<GetMessageHistoryResponse, ErrorResponse>) -> Void)
    
}
