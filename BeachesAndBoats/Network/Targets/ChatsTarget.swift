//
//  ChatsTarget.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 06/02/2025.
//

import Foundation
import Moya

enum ChatsTarget{
    case startConversation(StartConversationRequest)
    case sendChat(SendChatRequest)
    case getConversations
    case getMessageHistory(conversationId: String)
}

extension ChatsTarget: BaseTarget{
    var path: String {
        switch self {

        case .startConversation:
            return Urls.startConversation.rawValue
        case .sendChat(_):
            return Urls.sendChat.rawValue
        case .getConversations:
            return Urls.getConservations.rawValue
        case .getMessageHistory(let conversationId):
            return String(format: Urls.getMessageHistory.rawValue, conversationId)
        }
    }
    
    var method: Moya.Method {
        switch self {

        case .startConversation(_):
            return .post
        case .sendChat(_):
            return .post
        case .getConversations:
            return .get
        case .getMessageHistory:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {

        case .startConversation(let request):
            return .requestJSONEncodable(request)
        case .sendChat(let request):
            return .requestJSONEncodable(request)
        case .getConversations:
            return .requestPlain
        case .getMessageHistory(let conversationId):
            return .requestPlain
        }
    }
    
    
}
