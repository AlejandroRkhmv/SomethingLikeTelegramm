//
//  EditPersonView.swift
//  MessageStory
//
//  Created by Александр Рахимов on 28.04.2023.
//

import SwiftUI

struct EditCharacterView<Model>: View where Model: EditPersonViewModelProtocol {
    
    @EnvironmentObject private var navigationState: NavigationState
    @StateObject var editPersonViewModel: Model
    @State var character: Character
    @State private var isShowPhotoLibrary = false
    @State private var isAlertRemoveShow = false
    init(editPersonViewModel: Model,  character: Character) {
        _editPersonViewModel = StateObject(wrappedValue: editPersonViewModel)
        self.character = character
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 43) {
                    // MARK: - Image
                    ZStack {
                        Circle()
                            .frame(width: 118, height: 118)
                            .foregroundColor(Color(ENColor.grayColor.rawValue))
                        Image(systemName: "questionmark.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color(ENColor.blueColor.rawValue))
                        Image(uiImage: character.image)
                            .resizable()
                            .frame(width: 118, height: 118)
                            .clipShape(Circle()).frame(width: 118, height: 118)
                    }
                    VStack(alignment: .leading) {
                        Text(character.name)
                            .bold()
                            .font(.custom("Title2 / Bold", size: 22))
                        Text("Character # \(character.position)")
                            .foregroundColor(Color(ENColor.grayColor.rawValue))
                            .font(.custom("Subheadline/Regular", size: 15))
                        
                        HStack(spacing: 50) {
                            Button {
                                isShowPhotoLibrary = true
                            } label: {
                                Text("Upload photo")
                                    .font(.custom("Subheadline/Bold", size: 15))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 4)
                            }
                            .background(RoundedRectangle(cornerRadius: 14).foregroundColor(Color(ENColor.blueColor.rawValue)))
                            .sheet(isPresented: $isShowPhotoLibrary) {
                                ImagePicker(sourceType: .photoLibrary, selectedImage: $character.image)
                            }
                            
                            Button {
                                isAlertRemoveShow.toggle()
                            } label: {
                                Image(systemName: "minus.circle")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.red)
                            }
                            
                        }
                        .padding(.top, 45)
                    }
                }
                
                Text("Settings")
                    .font(.custom("Title2 / Bold", size: 22))
                    .bold()
                    .padding(.top, 30)
                
                List {
                    personeNameView
                    colorMessageView
                    positionInView
                }
                .padding(.horizontal, 16)
                .listStyle(.inset)
                
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Edit")
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
                        editPersonViewModel.setANewPersonToStorage(character: character)
                    } label: {
                        Text("Save")
                    }
                }
            }
            AlertRemoveView(isAlertRemoveShow: $isAlertRemoveShow, character: $character, editPersonViewModel: editPersonViewModel)
        }
    }
    
    var personeNameView: some View {
        HStack(spacing: 16) {
            Image("Icon-3")
            Text("Name")
            Spacer()
            TextField("William", text: $character.name)
                .multilineTextAlignment(TextAlignment.trailing)
                .frame(minWidth: character.name.accessibilityFrame.width)
        }
    }
    
    var colorMessageView: some View {
        DisclosureGroup {
            ColorPicker("", selection: $character.messageColor)
        } label: {
            HStack(spacing: 16) {
                Image("Icon-2")
                Text("Message color")
                Spacer()
                Text("Choose")
                    .foregroundColor(Color(ENColor.grayColor.rawValue))
            }
        }
        .tint(Color(ENColor.grayColor.rawValue))
    }
    
    var positionInView: some View {
        DisclosureGroup {
            Picker("", selection: $character.position) {
                ForEach(1..<30) { position in
                    if position > 1 {
                        Text("\(position - 1)")
                    }
                }
            }
        } label: {
            HStack(spacing: 16) {
                Image("Icon-6")
                Text("Position in menu")
                Spacer()
                Text("Choose")
                    .foregroundColor(Color(ENColor.grayColor.rawValue))
            }
        }
        .tint(Color(ENColor.grayColor.rawValue))
    }
}

// MARK: - AlertRemove character
struct AlertRemoveView: View {
    @Binding var isAlertRemoveShow: Bool
    @Binding var character: Character
    var editPersonViewModel: any EditPersonViewModelProtocol
    
    var body: some View {
        GeometryReader { geometry in
            
            let widthScreen = geometry.frame(in: .local).width
            let heightScreen = geometry.frame(in: .local).height
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: CGFloat(widthScreen) * 0.9, height: 200)
                    .foregroundColor(Color(ENColor.navigationBarColor.rawValue).opacity(0.95))
                    .blur(radius: 3)
                    .position(x: widthScreen * 0.5, y: heightScreen * 0.5)
                VStack {
                    Text("Are you sure you want to remove it?")
                        .frame(height: 40)
                        .foregroundColor(.gray)
                        .font(.custom("Footnote / Regular", size: 13))
                    Divider()
                        .frame(width: widthScreen * 0.9, height: 1)
                    Button {
                        editPersonViewModel.deleteCharacter(character: self.character)
                        self.character = Character()
                        isAlertRemoveShow.toggle()
                    } label: {
                        Text("Remove")
                            .foregroundColor(.red)
                            .font(.custom("Title3/Regular", size: 20))
                    }
                    .frame(height: 55)
                    Divider()
                        .frame(width: widthScreen * 0.9, height: 1)
                    Button {
                        isAlertRemoveShow.toggle()
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.blue)
                            .font(.custom("Title3/Regular", size: 20))
                    }
                    .frame(height: 60)
                }
            }
            .opacity(isAlertRemoveShow ? 1 : 0)
        }
    }
}
