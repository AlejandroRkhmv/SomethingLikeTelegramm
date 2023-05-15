//
//  SettingsView.swift
//  MessageStory
//
//  Created by Александр Рахимов on 28.04.2023.
//

import SwiftUI

struct SettingsView<Model>: View where Model: SettingsViewModelProtocol {
    
    @EnvironmentObject private var navigationState: NavigationState
    @State var chat: Chat
    @State var character: Character
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()
    @StateObject var settingsViewModel: Model
    
    init(settingsViewModel: Model, character: Character) {
        _settingsViewModel = StateObject(wrappedValue: settingsViewModel)
        self.character = character
        self.chat = character.chat
    }
    
    var body: some View {
        List {
            chatNameView
            chatImageView
            colorSettingsView
            senderCharacterView
        }
        .padding(.horizontal, 16)
        .listStyle(.inset)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Settings")
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
                    settingsViewModel.setChatToStorage(chat: self.chat, character: character)
                } label: {
                    Text("Save")
                }
            }
        }
    }
    
    var chatNameView: some View {
        HStack(spacing: 16) {
            Image("Icon-3")
            Text("Chat Name")
            Spacer()
            TextField("Birthday Chat", text: $chat.name)
                .multilineTextAlignment(TextAlignment.trailing)
                .frame(minWidth: chat.name.accessibilityFrame.width)
        }
    }
    
    var chatImageView: some View {
        DisclosureGroup {
            Button {
                self.isShowPhotoLibrary = true
            } label: {
                HStack {
                    Spacer()
                    Text("Choose chat Image")
                }
            }

        } label: {
            HStack(spacing: 16) {
                Image("Icon-4")
                Text("Chat Image")
                Spacer()
                Text("Choose")
                    .foregroundColor(Color(ENColor.grayColor.rawValue))
            }
        }
        .tint(Color(ENColor.grayColor.rawValue))
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $chat.image)
        }
    }
    
    var colorSettingsView: some View {
        DisclosureGroup {
            ColorPicker("", selection: $chat.color)
        } label: {
            HStack(spacing: 16) {
                Image("Icon-2")
                Text("Background color")
                Spacer()
                Text("Choose")
                    .foregroundColor(Color(ENColor.grayColor.rawValue))
            }
        }
        .tint(Color(ENColor.grayColor.rawValue))
    }
    
    var senderCharacterView: some View {
        DisclosureGroup {
            Picker("", selection: $character) {
                ForEach(settingsViewModel.storage.characters) { character in
                    Text("\(character.name)")
                }
            }
        } label: {
            HStack(spacing: 16) {
                Image("Icon-5")
                Text("Sender character")
                Spacer()
                Text("Choose")
                    .foregroundColor(Color(ENColor.grayColor.rawValue))
            }
        }
        .tint(Color(ENColor.grayColor.rawValue))
    }
}


// MARK: - for add picture from device
struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage
    @Environment(\.presentationMode) var presentationMode
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var parent: ImagePicker
    init(_ parent: ImagePicker) {
        self.parent = parent
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            parent.selectedImage = image
        }
        parent.presentationMode.wrappedValue.dismiss()
    }
}
