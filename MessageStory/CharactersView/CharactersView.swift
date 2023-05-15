//
//  CharactersView.swift
//  MessageStory
//
//  Created by Александр Рахимов on 29.04.2023.
//

import SwiftUI

struct CharactersView<Model>: View where Model: CharactersViewModelProtocol {
    
    @Environment(\.mainWindowSize) var window
    @EnvironmentObject private var navigationState: NavigationState
    @StateObject var charactersViewModel: Model
    @State private var searchCharacterName = ""
    @State private var showenCharacters = [Character]()
    init(charactersViewModel: Model) {
        _charactersViewModel = StateObject(wrappedValue: charactersViewModel)
    }
    
    
    let imageColumns: [GridItem] = [
        .init(.flexible()),
        .init(.flexible()),
        .init(.flexible())
    ]
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color(ENColor.grayColor.rawValue))
                        .frame(width: window.width * 0.9, height: 36)
                        .position(x: window.width * 0.45, y: 20)
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .offset(x: window.width * 0.03)
                        Spacer()
                        Image(systemName: "mic.fill")
                            .resizable()
                            .frame(width: 10, height: 17)
                            .offset(x: -window.width * 0.03)
                    }
                    .foregroundColor(.gray)
                    .position(x: window.width * 0.45, y: 20)
                    .opacity(searchCharacterName.isEmpty ? 1 : 0)
                    
                    TextField("Search", text: $searchCharacterName)
                        .padding(.horizontal, 35)
                        .frame(width: window.width * 0.9, height: 36)
                        .position(x: window.width * 0.45, y: 20)
                        .onSubmit {
                            showenCharacters = charactersViewModel.filteredCharacters(for: searchCharacterName)
                        }
                }
                .frame(width: window.width * 0.9, height: 30)
                .padding(.horizontal, 16)
                
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: imageColumns, alignment: .center, spacing: 20, pinnedViews: [.sectionHeaders]) {
                        Persone(searchCharacterName: $searchCharacterName, showenCharacters: $showenCharacters, charactersViewModel: charactersViewModel)
                    }
                    .padding(.top, 25)
                }
            }
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Characters")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    navigationState.dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    navigationState.navigate(to: .editCharacterView(character: Character()))
                } label: {
                    Text("New")
                }
            }
        }
        .onAppear {
            showenCharacters = charactersViewModel.storage.characters
        }
    }
}

struct Persone: View {
    @EnvironmentObject private var navigationState: NavigationState
    @Binding var searchCharacterName: String
    @Binding var showenCharacters: [Character]
    var charactersViewModel: any CharactersViewModelProtocol
    
    var body: some View {
        
        Section {
            ForEach(showenCharacters) { character in
                Button {
                    navigationState.navigate(to: .editCharacterView(character: charactersViewModel.storage.characters.first { $0.uuid == character.uuid } ?? Character()))
                } label: {
                    VStack {
                        Image(uiImage: character.image)
                            .resizable()
                            .frame(width: 88, height: 88)
                            .clipShape(Circle()).frame(width: 88, height: 88)
                        Text(character.name)
                            .foregroundColor(Color(ENColor.grayColor.rawValue))
                            .font(.custom("Caption1 / Regular", size: 12))
                    }
                }
                
            }
        }
        
        .onAppear {
            charactersViewModel.updateCharactersView()
        }
    }
}
