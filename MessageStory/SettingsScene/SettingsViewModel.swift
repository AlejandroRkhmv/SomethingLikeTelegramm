//
//  SettingsViewModel.swift
//  MessageStory
//
//  Created by Александр Рахимов on 30.04.2023.
//

import Foundation

protocol SettingsViewModelProtocol: ObservableObject {
    var storage: (any StorageProtocol) { get set }
    func setChatToStorage(chat: Chat, character: Character)
}

class SettingsViewModel: SettingsViewModelProtocol {
    @Published var isSettingsOfChatUpdate = false
    var storage: any StorageProtocol = Storage.shared
    
    func setChatToStorage(chat: Chat, character: Character) {
        DispatchQueue.global(qos: .userInitiated).async {
            character.chat = chat
            self.storage.update(character: character)
        }
        self.isSettingsOfChatUpdate.toggle()
    }
}
