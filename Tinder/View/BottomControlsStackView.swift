//
//  BottomControlsStackView.swift
//  Tinder
//
//  Created by Sungwoong Kang on 2022/01/15.
//

import UIKit

class BottomControlsStackView: UIStackView {
    // MARK: - Properties
    
    let refreshButton = UIButton(type: .system)
    let dislikeButton = UIButton(type: .system)
    let superlikeButton = UIButton(type: .system)
    let likeButton = UIButton(type: .system)
    let boostlikeButton = UIButton(type: .system)
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        distribution = .fillEqually
        
        refreshButton.setImage(UIImage(named: "refresh_circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        dislikeButton.setImage(UIImage(named: "dismiss_circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        superlikeButton.setImage(UIImage(named: "super_like_circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        likeButton.setImage(UIImage(named: "like_circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        boostlikeButton.setImage(UIImage(named: "boost_circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        
        [refreshButton, dislikeButton,
         superlikeButton, likeButton, boostlikeButton].forEach { view in
            addArrangedSubview(view)
        }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
