//
//  MessageModel.swift
//  MessageStory
//
//  Created by Александр Рахимов on 28.04.2023.
//

import Foundation

class Message: Identifiable, Codable {
    var uuid = UUID()
    let isFromMe: Bool
    let text: String
    var character: Character?
    var date = Date()
    
    init(isFromMe: Bool, text: String, character: Character?) {
        self.isFromMe = isFromMe
        self.text = text
        self.character = character
    }
}

extension Message: Hashable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.date == rhs.date
    }
    
    public func hash(into hasher: inout Hasher) {
             hasher.combine(ObjectIdentifier(self))
        }
}
