//
//  ChatView.swift
//  MessageStory
//
//  Created by Александр Рахимов on 28.04.2023.
//

import SwiftUI

struct ChatView<Model>: View where Model: ChatViewModelProtocol {
    
    @Environment(\.mainWindowSize) var window
    @StateObject var chatViewModel: Model
    @State private var message = ""
    @State private var isFromMe = true
    @State private var selectedPersone = 0
    @State private var isAlertNewStoryShow = false
    @State private var isAlertSaveShow = false
    @State private var isBottomBarShow = true
    
    init(chatViewModel: Model) {
        _chatViewModel = StateObject(wrappedValue: chatViewModel)
    }
    
    // MARK: - main
    var body: some View {
        ZStack {
            VStack {
                navigationView
                 .frame(height: 70)
                scrollView
                    .padding(.horizontal, 16)
                    .background(chatViewModel.getChatForCharacters().color)
                BottomBar(chatViewModel: chatViewModel, message: $message, isFromMe: $isFromMe)
                    .opacity(isBottomBarShow ? 1 : 0)
                // MARK: - keyboard toolbar
                    .toolbar {
                        ToolbarItem(placement: .keyboard) {
                            ZStack {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(chatViewModel.storage.characters.sorted(by: { $0.position < $1.position })) { character in
                                            ZStack {
                                                Image(uiImage: character.image)
                                                    .resizable()
                                                    .frame(width: 30, height: 30)
                                                    .clipShape(Circle()).frame(width: 30, height: 30)
                                                // MARK: - change person logic
                                                    .onTapGesture {
                                                        if selectedPersone != character.position {
                                                            selectedPersone = character.position
                                                            isFromMe = false
                                                            chatViewModel.character = character
                                                        } else {
                                                            selectedPersone = 0
                                                            isFromMe = true
                                                        }
                                                        print(selectedPersone)
                                                    }
                                                Circle().strokeBorder(Color(ENColor.blueColor.rawValue).opacity(selectedPersone == character.position ? 1 : 0), style: .init(lineWidth: 3))
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 2)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 7)
                                .background(Color(ENColor.personViewBack.rawValue))
                                .padding(.horizontal, -16)
                            }
                        }
                    }
            }
            AlertNewStoryView(isAlertNewStoryShow: $isAlertNewStoryShow, selectedPersone: $selectedPersone, isFromMe: $isFromMe, chatViewModel: chatViewModel)
            AlertSaveView(isAlertSaveShow: $isAlertSaveShow, selectedPersone: $selectedPersone, isFromMe: $isFromMe, isBottomBarShow: $isBottomBarShow, chatViewModel: chatViewModel)
        }
        .background(chatViewModel.getChatForCharacters().color)
        .onAppear {
            chatViewModel.updateChatAfterSettingsChanges()
        }
    }
    
    var navigationView: some View {
        // MARK: - Navigation bar
        GeometryReader { geometry in
            let width = geometry.frame(in: .local).width
            let height = geometry.frame(in: .local).height
            ZStack(alignment: .top) {
                Rectangle()
                    .frame(height: 137)
                    .foregroundColor(Color(ENColor.navigationBarColor.rawValue))
                    .edgesIgnoringSafeArea(.top)
                Button {
                    isAlertNewStoryShow.toggle()
                } label: {
                    Text("New Story")
                        .font(.custom("Body/Regular", size: 17))
                }
                .position(x: width * 0.15, y: height * 0.5)
                // MARK: - Image and chat name
                VStack {
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color(ENColor.blueColor.rawValue))
                        Image(uiImage: chatViewModel.getChatForCharacters().image)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle()).frame(width: 50, height: 50)
                    }
                    Text(chatViewModel.getChatForCharacters().name)
                        .font(.custom("Caption2/Regular", size: 11))
                }
                .position(x: width * 0.5, y: height * 0.5)
                Button {
                    isBottomBarShow.toggle()
                    isAlertSaveShow.toggle()
                    let image = body.takeScreenshot(width: CGFloat(window.width), height: CGFloat(window.height))
                    let imageSaver = ImageSaver()
                    imageSaver.writeToPhotoAlbum(image: image)
                } label: {
                    Text("Save")
                        .font(.custom("Body/Regular", size: 17))
                }
                .position(x: width * 0.9, y: height * 0.5)
            }
        }
    }
    
    
    
    var scrollView: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                ScrollViewReader { proxy in
                    VStack {
                        ZStack(alignment: .bottom) {}.frame(maxHeight: .infinity)
                        ForEach(chatViewModel.getMessages(), id: \.id) { message in
                            if chatViewModel.needShow(message: message) {
                                Text(chatViewModel.dateFormatterFromMessages(date: message.date))
                                    .font(.custom("Caption2/Regular", size: 11))
                                    .foregroundColor(Color(ENColor.grayColor.rawValue))
                            }
                            HStack {
                                if !message.isFromMe {
                                    Image(uiImage: chatViewModel.character?.image ?? UIImage())
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle()).frame(width: 30, height: 30)
                                }
                                Text(message.text)
                                    .font(.custom("Body/Regular", size: 17))
                                    .foregroundColor(message.isFromMe ? .white : .black)
                                    .padding(.leading, 12)
                                    .padding(.trailing, 12)
                                    .padding(.top, 6)
                                    .padding(.bottom, 6)
                                    .background(content: {
                                        let messageColor = message.character?.messageColor
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 18)
                                                .foregroundColor(message.isFromMe ? Color(ENColor.blueColor.rawValue) : messageColor)
                                                .opacity(chatViewModel.needFigure(message: message) ? 0 : 1)
                                            BubleView()
                                                .foregroundColor(message.isFromMe ? Color(ENColor.blueColor.rawValue) : messageColor)
                                                .rotation3DEffect(message.isFromMe ? .degrees(180) : .zero, axis: (x: 0, y: 1, z: 0))
                                                .opacity(chatViewModel.needFigure(message: message) ? 1 : 0)
                                        }
                                    })
                                    .padding(.top, 1)
                                    .font(.system(size: 30))
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: message.isFromMe ? .trailing : .leading)
                            }
                        }
                        Spacer().id("spacer")
                            .frame(height: window.height * 0.5)
                    }
                    
                    .onChange(of: chatViewModel.getMessages(), perform: { _ in
                        withAnimation(.linear(duration: 5)) {
                            proxy.scrollTo("spacer", anchor: .bottom)
                            chatViewModel.isMessagesUpdated.toggle()
                        }
                    })
                }
            }
        }
    }
}

// MARK: - BottomBar
struct BottomBar: View {
    @EnvironmentObject private var navigationState: NavigationState
    var chatViewModel: any ChatViewModelProtocol
    var backgroundColor = Color.white
    @Binding var message: String
    @Binding var isFromMe: Bool
    
    var body: some View {
        VStack {
            Text("Choose a character and type a message to start")
                .font(.custom("Caption2/Medium", size: 11))
                .foregroundColor(Color(ENColor.grayColor.rawValue))
                .opacity(chatViewModel.storage.characters.count != 0 ? 0 : 1)
            HStack {
                
                // MARK: - settings button
                Button {
                    navigationState.navigate(to: .settingsView(character: chatViewModel.character ?? Character()))
                } label: {
                    Image(systemName: "gear")
                        .font(.system(size: 25))
                }
                
                // MARK: - person button
                Button {
                    navigationState.navigate(to: .charactersView)
                } label: {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 25))
                }
                
                // MARK: - textfield
                TextField("Send a message", text: $message)
                    .padding(.horizontal)
                    .overlay {
                        RoundedRectangle(cornerRadius: 18)
                            .strokeBorder(Color(ENColor.grayColor.rawValue), style: .init(lineWidth: 1))
                            .frame(height: 36)
                    }
                // MARK: - pull view model method
                    .onSubmit {
                        chatViewModel.sendlMessage(isFromMe: isFromMe, text: message)
                        message = ""
                    }
            }
            .foregroundColor(Color(ENColor.grayColor.rawValue))
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 10)
        }
    }
}

// MARK: - AlertANewStory
struct AlertNewStoryView: View {
    @Binding var isAlertNewStoryShow: Bool
    @Binding var selectedPersone: Int
    @Binding var isFromMe: Bool
    var chatViewModel: any ChatViewModelProtocol
    
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
                    Text("Are you sure you want to start a new story?")
                        .frame(height: 40)
                        .foregroundColor(.gray)
                        .font(.custom("Footnote / Regular", size: 13))
                    Divider()
                        .frame(width: widthScreen * 0.9, height: 1)
                    Button {
                        chatViewModel.removeMessages()
                        selectedPersone = 0
                        isFromMe = true
                        isAlertNewStoryShow.toggle()
                    } label: {
                        Text("New story")
                            .foregroundColor(.red)
                            .font(.custom("Title3/Regular", size: 20))
                    }
                    .frame(height: 55)
                    Divider()
                        .frame(width: widthScreen * 0.9, height: 1)
                    Button {
                        isAlertNewStoryShow.toggle()
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.blue)
                            .font(.custom("Title3/Regular", size: 20))
                    }
                    .frame(height: 60)

                }
            }
            .opacity(isAlertNewStoryShow ? 1 : 0)
        }
    }
}

// MARK: - AlertSave
struct AlertSaveView: View {
    @Binding var isAlertSaveShow: Bool
    @Binding var selectedPersone: Int
    @Binding var isFromMe: Bool
    @Binding var isBottomBarShow: Bool
    var chatViewModel: any ChatViewModelProtocol
    
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
                    Text("Your story was saved to Photos")
                        .frame(height: 40)
                        .foregroundColor(.gray)
                        .font(.custom("Footnote / Regular", size: 13))
                    Divider()
                        .frame(width: widthScreen * 0.9, height: 1)
                    Button {
                        isAlertSaveShow.toggle()
                        isBottomBarShow.toggle()
                    } label: {
                        Text("Continue")
                            .foregroundColor(.blue)
                            .font(.custom("Title3/Regular", size: 20))
                    }
                    .frame(height: 55)
                    Divider()
                        .frame(width: widthScreen * 0.9, height: 1)
                    Button {
                        chatViewModel.removeMessages()
                        selectedPersone = 0
                        isFromMe = true
                        isAlertSaveShow.toggle()
                        isBottomBarShow.toggle()
                    } label: {
                        Text("Create a new story")
                            .foregroundColor(.blue)
                            .font(.custom("Title3/Regular", size: 20))
                    }
                    .frame(height: 60)

                }
            }
            .opacity(isAlertSaveShow ? 1 : 0)
        }
    }
}


// MARK: - Buble
struct BubleView: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY - 10))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + 18))
        path.addArc(center: CGPoint(x: rect.minX + 9, y: rect.minY + 9), radius: 9, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - 9, y: rect.minY + 9), radius: 9, startAngle: .degrees(270), endAngle: .zero, clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 9))
        path.addArc(center: CGPoint(x: rect.maxX - 9, y: rect.maxY - 9), radius: 9, startAngle: .zero, endAngle: .degrees(90), clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX + 10, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX - 5, y: rect.maxY + 10))
        return path
    }
}
