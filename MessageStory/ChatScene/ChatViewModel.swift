//
//  ChatViewModel.swift
//  MessageStory
//
//  Created by Александр Рахимов on 28.04.2023.
//

import Foundation

protocol ChatViewModelProtocol: ObservableObject {
    var storage: (any StorageProtocol) { get set }
    var isMessagesUpdated: Bool { get set }
    var character: Character? { get set }
    func sendlMessage(isFromMe: Bool, text: String)
    func dateFormatterFromMessages(date: Date) -> String
    func needShow(message: Message) -> Bool
    func removeMessages()
    func updateChatAfterSettingsChanges()
    func needFigure(message: Message) -> Bool
    func getMessages() -> [Message]
    func getChatForCharacters() -> Chat
}

class ChatViewModel: ChatViewModelProtocol {
    var storage: any StorageProtocol = Storage.shared
    @Published var isMessagesUpdated = false
    @Published private var isChatUpdated = false
    var character: Character?
    
    func sendlMessage(isFromMe: Bool, text: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard !text.isEmpty else { return }
            let message = Message(isFromMe: isFromMe, text: text, character: self.character)
            self.storage.add(message: message)
        }
    }
    
    func removeMessages() {
        DispatchQueue.global(qos: .userInitiated).async {
            let messagesWithoutDeletedMessages = self.storage.messages.filter { $0.character != self.character }
            self.storage.update(messages: messagesWithoutDeletedMessages)
        }
        self.isMessagesUpdated.toggle()
    }
    
    func updateChatAfterSettingsChanges() {
        DispatchQueue.main.async {
            self.isChatUpdated.toggle()
        }
    }
    
    func dateFormatterFromMessages(date: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        let componentsOfCurrentDate = calendar.dateComponents([.day, .weekday, .month, .year], from: currentDate)
        let componentsOfMessageDate = calendar.dateComponents([.day, .weekday, .month, .year], from: date)
        let componentsOfCurrentDateWithoutDay = calendar.dateComponents([.month, .year], from: currentDate)
        let componentsOfMessageDateWithoutDay = calendar.dateComponents([.month, .year], from: date)
        let dateFormatter = DateFormatter()
        
        if componentsOfMessageDate == componentsOfCurrentDate {
            dateFormatter.dateFormat = "HH:mm"
            return "Today " + dateFormatter.string(from: date)
        } else if componentsOfCurrentDate.day! - componentsOfMessageDate.day! == 1 && componentsOfCurrentDateWithoutDay == componentsOfMessageDateWithoutDay {
            dateFormatter.dateFormat = "HH:mm"
            return "Yesterday " + dateFormatter.string(from: date)
        } else {
            dateFormatter.dateFormat = "EEEE, MMM d, HH:mm"
            return dateFormatter.string(from: date)
        }
    }
    
    func needShow(message: Message) -> Bool {
        if message.character == nil {
            let charactersMessages = storage.messages.filter { $0.character == nil }
            guard charactersMessages.count > 1 else { return true }
            let minMessage = charactersMessages.min { $0.date < $1.date }
            return minMessage?.uuid == message.uuid
        } else {
            let charactersMessages = storage.messages.filter { $0.character?.uuid == message.character?.uuid }
            guard charactersMessages.count > 1 else { return true }
            let minMessage = charactersMessages.min { $0.date < $1.date }
            return minMessage?.uuid == message.uuid
        }
    }
    
    func needFigure(message: Message) -> Bool {
        if message.character == nil {
            let charactersMessages = storage.messages.filter { $0.character == nil }
            guard charactersMessages.count > 1 else { return true }
            let minMessage = charactersMessages.max { $0.date < $1.date }
            return minMessage?.uuid == message.uuid
        } else {
            let charactersMessages = storage.messages.filter { $0.character?.uuid == message.character?.uuid }
            guard charactersMessages.count > 1 else { return true }
            let minMessage = charactersMessages.max { $0.date < $1.date }
            return minMessage?.uuid == message.uuid
        }
    }
    
    func getMessages() -> [Message] {
        let messages = storage.messages.filter { $0.character == self.character }
        return messages
    }
    
    func getChatForCharacters() -> Chat {
        let character = storage.characters.first { $0 == self.character }
        guard let character = character else { return Chat() }
        return character.chat
    }
}
