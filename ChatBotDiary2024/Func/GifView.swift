//
//  GifView.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/07/29.
//

import Foundation
import SwiftyGif
import SwiftUI


struct GifView: UIViewRepresentable {
    let gifName: String
    let width: CGFloat
    let height: CGFloat
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.frame.size = CGSize(width: width, height: height)
        
        do {
            let gif = try UIImage(gifName: gifName)
            imageView.setGifImage(gif, loopCount: -1)
        } catch {
            print("Failed to load gif: \(error)")
        }
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {}
}
