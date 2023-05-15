//
//  MessageStoryApp.swift
//  MessageStory
//
//  Created by Александр Рахимов on 28.04.2023.
//

import SwiftUI

@main
struct MessageStoryApp: App {
    let navigationState = NavigationState()
    var body: some Scene {
        WindowGroup {
            GeometryReader { proxy in
                ContainerView()
                    .environmentObject(navigationState)
                    .environment(\.mainWindowSize, proxy.size)
            }
        }
    }
}

private struct MainWindowSizeKey: EnvironmentKey {
    static let defaultValue: CGSize = .zero
}

extension EnvironmentValues {
    var mainWindowSize: CGSize {
        get { self[MainWindowSizeKey.self] }
        set { self[MainWindowSizeKey.self] = newValue }
    }
}
