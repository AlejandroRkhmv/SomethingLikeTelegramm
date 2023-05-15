//
//  NavigationDestination.swift
//  MessageStory
//
//  Created by Александр Рахимов on 28.04.2023.
//

import SwiftUI

enum NavigationDestination: Hashable {
    case settingsView(character: Character)
    case charactersView
    case editCharacterView(character: Character)
}

extension View {
    func withNavigationDestination() -> some View {
        self.navigationDestination(for: NavigationDestination.self) { destination in
            switch destination {
            case .settingsView(let character):
                let settingsViewModel = SettingsViewModel()
                SettingsView(settingsViewModel: settingsViewModel, character: character)
            case .charactersView:
                let charactersViewModel = CharactersViewModel()
                CharactersView(charactersViewModel: charactersViewModel)
            case .editCharacterView(let character):
                let editPersonViewModel = EditPersonViewModel()
                EditCharacterView(editPersonViewModel: editPersonViewModel, character: character)
            }
        }
    }
}

