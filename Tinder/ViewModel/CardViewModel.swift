//
//  CardViewModel.swift
//  Tinder
//
//  Created by Sungwoong Kang on 2022/01/16.
//

import UIKit

class CardViewModel {
    
    let user: User
    
    let userInfoText: NSAttributedString
    
    private var imageIndex = 0
    
    let imageUrl: URL?
        
    init(user: User) {
        self.user = user
        let attributedText = NSMutableAttributedString(string: user.name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy), .foregroundColor: UIColor.white])
        attributedText.append(NSAttributedString(string: "  \(user.age)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .heavy), .foregroundColor: UIColor.white]))
        self.userInfoText = attributedText
        
        self.imageUrl = URL(string: user.profileImageUrl)
    }
    
    func showNextPhoto() {
//        guard imageIndex < user.images.count - 1 else {
//            print("DEBUG: Image index is trying to go out of bounds..")
//            return
//        }
//        imageIndex += 1
//        print("DEBUG: Image index is \(imageIndex)")
//        self.imageToShow = user.images[imageIndex]
    }
    
    func showPreviousPhoto() {
        guard imageIndex > 0 else { return }
        imageIndex -= 1
//        self.imageToShow = user.images[imageIndex]
    }
}
