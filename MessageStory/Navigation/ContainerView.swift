//
//  ContainerView.swift
//  MessageStory
//
//  Created by Александр Рахимов on 28.04.2023.
//

import SwiftUI

struct ContainerView: View {
    
    @EnvironmentObject private var navigationState: NavigationState
    
    var body: some View {
        NavigationStack(path: $navigationState.path) {
            let vm = ChatViewModel()
           
            ChatView(chatViewModel: vm)
                .withNavigationDestination()
        }
    }
}
