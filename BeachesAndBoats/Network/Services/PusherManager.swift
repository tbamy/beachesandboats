//
//  PusherManager.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 07/02/2025.
//

import Foundation
import PusherSwift
import RxSwift

class PusherManager {
    static let shared = PusherManager()
    
    private var pusher: Pusher!
    private var channel: PusherChannel?
    private let newMessageSubject = PublishSubject<SendChatResponseData>() // RxSwift subject
    
    var newMessageObservable: Observable<SendChatResponseData> {
        return newMessageSubject.asObservable()
    }

    
    private init() {
        setupPusherClient()
    }
    
    private func setupPusherClient() {
        let options = PusherClientOptions(
            host: .cluster("mt1")
        )
        
        pusher = Pusher(
            key: "798ee60511bc0993018e",
            options: options
        )
        
        pusher.connect()
    }

    func setupPusher(conversationId: String) {
        // Unsubscribe from previous channel if any
        if let existingChannel = channel {
            pusher.unsubscribe(existingChannel.name)
        }
        
        // Subscribe to the new channel using the conversation ID
        channel = pusher.subscribe("\(conversationId)")
        
        channel?.bind(eventName: "chat") { [weak self] event in
            guard let self = self, let eventData = event.data?.data(using: .utf8) else { return }

            do {
                let message = try JSONDecoder().decode(SendChatResponseData.self, from: eventData)
                self.newMessageSubject.onNext(message) // Emit message through RxSwift
            } catch {
                print("Error decoding message: \(error)")
            }
        }
    }
}
