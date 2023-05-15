//
//  EditPersonViewModel.swift
//  MessageStory
//
//  Created by Александр Рахимов on 29.04.2023.
//

import SwiftUI

protocol EditPersonViewModelProtocol: ObservableObject {
    var storage: (any StorageProtocol) { get set }
    func setANewPersonToStorage(character: Character)
    func deleteCharacter(character: Character)
}

class EditPersonViewModel: EditPersonViewModelProtocol {
    
    @Published var isCharacterUpdate = false
    var storage: any StorageProtocol = Storage.shared
    
    func setANewPersonToStorage(character: Character) {
        DispatchQueue.global(qos: .userInitiated).async {
            if self.storage.characters.contains(character) {
                self.storage.changeCharacterInStorage(character: character)
            } else {
                self.storage.create(character: character)
            }
        }
    }
    
    func deleteCharacter(character: Character) {
        DispatchQueue.global(qos: .userInitiated).async {
            if self.storage.characters.contains(character) {
                self.storage.delete(character: character)
            }
        }
    }
}
