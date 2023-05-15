//
//  Storage.swift
//  MessageStory
//
//  Created by Александр Рахимов on 29.04.2023.
//

import Foundation
import Combine

protocol StorageProtocol: ObservableObject {
    var messages: [Message] { get set }
    var characters: [Character] { get set }
    var isMessagesUpdated: Bool { get set }
    var isCharacterUpdate: Bool { get set }
    func add(message: Message)
    func create(character: Character)
    func update(messages: [Message])
    func changeCharacterInStorage(character: Character)
    func delete(character: Character)
    func update(character: Character)
}

class Storage: StorageProtocol {
    static let shared = Storage()
    private init() {
        loadMessages()
        loadCharacters()
    }
    
    @Published var isMessagesUpdated = false
    @Published var isCharacterUpdate = false
    
    @Published var messages = [Message]() {
        didSet {
            self.isMessagesUpdated.toggle()
        }
    }
    
    @Published var characters = [Character]() {
        didSet {
            self.isCharacterUpdate.toggle()
        }
    }
    
    func add(message: Message) {
        self.messages.append(message)
        save(messages: self.messages)
    }
    
    func update(messages: [Message]) {
        self.messages = messages
        save(messages: self.messages)
    }
    
    func create(character: Character) {
        self.characters.append(character)
        save(characters: self.characters)
    }
    
    func update(character: Character) {
        if characters.contains(character) {
            changeCharacterInStorage(character: character)
        }
    }
    
    func changeCharacterInStorage(character: Character) {
        guard let indexOfCharacter = self.characters.firstIndex(of: character) else { return }
        self.characters[indexOfCharacter] = character
        save(characters: self.characters)
    }
    
    func delete(character: Character) {
        guard let indexOfCharacter = self.characters.firstIndex(of: character) else { return }
        self.characters.remove(at: indexOfCharacter)
        save(characters: self.characters)
    }
    
    private func save(characters: [Character]) {
        let defaults = UserDefaults.standard
        let key = Keys.keyForCharacters.rawValue
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(characters) else { return }
        defaults.set(data, forKey: key)
    }
    
    private func loadCharacters() {
        let defaults = UserDefaults.standard
        let key = Keys.keyForCharacters.rawValue
        let decoder = JSONDecoder()
        guard let data = defaults.object(forKey: key) as? Data else { return }
        guard let characters = try? decoder.decode([Character].self, from: data) else { return }
        self.characters = characters
    }
    
    private func save(messages: [Message]) {
        let defaults = UserDefaults.standard
        let key = Keys.keyForMessages.rawValue
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(messages) else { return }
        defaults.set(data, forKey: key)
    }
    
    private func loadMessages() {
        let defaults = UserDefaults.standard
        let key = Keys.keyForMessages.rawValue
        let decoder = JSONDecoder()
        guard let data = defaults.object(forKey: key) as? Data else { return }
        guard let messages = try? decoder.decode([Message].self, from: data) else { return }
        self.messages = messages
    }
}

enum Keys: String {
    case keyForCharacters
    case keyForMessages
}
