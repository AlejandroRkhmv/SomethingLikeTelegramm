//
//  ChatModel.swift
//  MessageStory
//
//  Created by Александр Рахимов on 28.04.2023.
//

import SwiftUI

class Chat: ObservableObject, Identifiable, Codable {
    var uuid = UUID()
    @Published var name = ""
    @Published var color = Color.white
    @Published var image = UIImage()
    
    init() {}
    
    private enum KeysForCoding: CodingKey {
        case uuid
        case name
        case color
        case image
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: KeysForCoding.self)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(name, forKey: .name)
        try container.encode(color, forKey: .color)
        if let data = image.jpegData(compressionQuality: 1.0) {
            try container.encode(data, forKey: .image)
        }
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: KeysForCoding.self)
        uuid = try! container.decode(UUID.self, forKey: .uuid)
        name = try! container.decode(String.self, forKey: .name)
        color = try! container.decode(Color.self, forKey: .color)
        let dataImage = try? container.decode(Data.self, forKey: .image)
        if dataImage != nil {
            let decodedImage = UIImage(data: dataImage!) ?? UIImage()
            image = decodedImage
        } else {
            image = UIImage()
        }
    }
}

extension Chat: Equatable {
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

extension Chat: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

fileprivate extension Color {
    typealias SystemColor = UIColor
    
    var colorComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        guard SystemColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        return (r, g, b, a)
    }
}

extension Color: Codable {
    enum CodingKeys: String, CodingKey {
        case red, green, blue
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let r = try container.decode(Double.self, forKey: .red)
        let g = try container.decode(Double.self, forKey: .green)
        let b = try container.decode(Double.self, forKey: .blue)
        
        self.init(red: r, green: g, blue: b)
    }

    public func encode(to encoder: Encoder) throws {
        guard let colorComponents = self.colorComponents else {
            return
        }
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(colorComponents.red, forKey: .red)
        try container.encode(colorComponents.green, forKey: .green)
        try container.encode(colorComponents.blue, forKey: .blue)
    }
}


