//
//  ImageSaver.swift
//  MessageStory
//
//  Created by Александр Рахимов on 28.04.2023.
//

import Foundation
import SwiftUI

class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}

extension View {
    func takeScreenshot(width: CGFloat, height: CGFloat) -> UIImage {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: width, height: height))
        let hosting = UIHostingController(rootView: self)
        hosting.view.frame = window.frame
        window.addSubview(hosting.view)
        window.makeKeyAndVisible()
        return hosting.view.screenShot
  }
}

extension UIView {
   var screenShot: UIImage {
       let rect = self.bounds
       UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
       let context: CGContext = UIGraphicsGetCurrentContext()!
       self.layer.render(in: context)
       let capturedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
       UIGraphicsEndImageContext()
       return capturedImage
   }
}
