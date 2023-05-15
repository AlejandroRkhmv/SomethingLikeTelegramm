//
//  NavigationState.swift
//  MessageStory
//
//  Created by Александр Рахимов on 28.04.2023.
//

import SwiftUI

class NavigationState: ObservableObject {
    @Published var path = NavigationPath()
    
    // MARK: - open new screen
    func navigate(to navigationDestination: NavigationDestination) {
        path.append(navigationDestination)
    }
    
    // MARK: - close current screen
    func dismiss() {
        path.removeLast()
    }
}
