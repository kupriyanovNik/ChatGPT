//
//  ChatMessage.swift
//  ChatGPT
//
//  Created by Никита on 03.03.2023.
//

import Foundation

struct ChatMessage {
    let id: String
    let content: String
    let dateCreated: Date
    let sender: MessageSender
}

enum MessageSender {
    case me
    case gpt
}

extension ChatMessage {
    static let sampleMessages: [ChatMessage] = [
        .init(id: UUID().uuidString, content: "sample message from me", dateCreated: Date(), sender: .me),
        .init(id: UUID().uuidString, content: "sample message from gpt", dateCreated: Date(), sender: .gpt),
        .init(id: UUID().uuidString, content: "sample message from me", dateCreated: Date(), sender: .me),
        .init(id: UUID().uuidString, content: "sample message from gpt", dateCreated: Date(), sender: .gpt)
    ]
}
