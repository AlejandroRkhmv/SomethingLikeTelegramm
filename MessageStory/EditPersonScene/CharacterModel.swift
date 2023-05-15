//
//  PersonModel.swift
//  MessageStory
//
//  Created by Александр Рахимов on 29.04.2023.
//

import SwiftUI

final class Character: ObservableObject, Identifiable, Codable {
    var uuid = UUID()
    @Published var name = ""
    @Published var position = 1
    @Published var messageColor = Color.white
    @Published var image = UIImage()
    @Published var chat = Chat()
    
    init() {}
    
    private enum KeysForCoding: CodingKey {
        case uuid
        case name
        case position
        case messageColor
        case image
        case chat
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: KeysForCoding.self)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(name, forKey: .name)
        try container.encode(position, forKey: .position)
        try container.encode(messageColor, forKey: .messageColor)
        if let data = image.jpegData(compressionQuality: 1.0) {
            try container.encode(data, forKey: .image)
        }
        try container.encode(chat, forKey: .chat)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: KeysForCoding.self)
        uuid = try container.decode(UUID.self, forKey: .uuid)
        name = try container.decode(String.self, forKey: .name)
        position = try container.decode(Int.self, forKey: .position)
        messageColor = try container.decode(Color.self, forKey: .messageColor)
        let imageData = try container.decode(Data.self, forKey: .image)
        let decodedImage = UIImage(data: imageData) ?? UIImage()
        image = decodedImage
        chat = try container.decode(Chat.self, forKey: .chat)
    }
}

extension Character: Equatable {
    static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

extension Character: Hashable {
    public func hash(into hasher: inout Hasher) {
             hasher.combine(ObjectIdentifier(self))
        }
}
