//
//  CharactersViewModel.swift
//  MessageStory
//
//  Created by Александр Рахимов on 29.04.2023.
//

import Foundation

protocol CharactersViewModelProtocol: ObservableObject {
    var storage: (any StorageProtocol) { get set }
    func updateCharactersView()
    func filteredCharacters(for search: String) -> [Character]
}

class CharactersViewModel: CharactersViewModelProtocol {
    @Published var isCharacterUpdate = false
    var storage: any StorageProtocol = Storage.shared
    
    func updateCharactersView() {
        self.isCharacterUpdate = storage.isCharacterUpdate
    }
    
    func filteredCharacters(for search: String) -> [Character] {
        guard search != "" else { return storage.characters }
        let filteredCharacters = storage.characters.filter { $0.name.hasPrefix(search) }
        isCharacterUpdate.toggle()
        return filteredCharacters
    }
}
