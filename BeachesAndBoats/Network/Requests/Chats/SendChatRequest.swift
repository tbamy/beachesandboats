//
//  SendChatRequest.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 06/02/2025.
//

import Foundation

struct SendChatRequest: Codable{
    let conversation_id: String?
    let message: String?
}
