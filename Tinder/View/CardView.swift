//
//  CardView.swift
//  Tinder
//
//  Created by Sungwoong Kang on 2022/01/15.
//

import UIKit
import SDWebImage

enum SwipeDirection: Int {
    case left = -1
    case right = 1
}

class CardView: UIView {
    
    // MARK: - Properties
    
    private let gradientLayer = CAGradientLayer()
    
    private let viewModel: CardViewModel
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
//        label.attributedText = viewModel.userInfoText
        return label
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "info_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    init(viewModel: CardViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        configureGestureRecognizers()
        
        imageView.sd_setImage(with: viewModel.imageUrl)
        
        infoLabel.attributedText = viewModel.userInfoText
                
        backgroundColor = .systemPurple
        layer.cornerRadius = 10
        clipsToBounds = true
        
        addSubview(imageView)
        imageView.fillSuperview()
        
        configureGradientLayer()
        
        addSubview(infoLabel)
        infoLabel.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        
        addSubview(infoButton)
        infoButton.setDimensions(height: 40, width: 40)
        infoButton.centerY(inView: infoLabel)
        infoButton.anchor(right: rightAnchor, paddingRight: 16)
        
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func handlePanGesture(sender: UIPanGestureRecognizer){
        switch sender.state {
        case .began:
            superview?.subviews.forEach({ $0.layer.removeAllAnimations() })
        case .changed:
            panCard(sender: sender)
        case .ended:
            resetCardPosition(sender: sender)
        default:
            break
        }
    }
    
    @objc func handleChangePhoto(sender: UITapGestureRecognizer) {
        let location = sender.location(in: nil).x
        let shouldShowNextPhoto = location > self.frame.width / 2
        
        if shouldShowNextPhoto {
            viewModel.showNextPhoto()
        } else {
            viewModel.showPreviousPhoto()
        }
    }
    
    // MARK: - Helpers
    
    // 카드를 움직인다.
    func panCard(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        let rotationalTransform = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransform.translatedBy(x: translation.x, y: translation.y)
    }
    
    // 카드를 원위치 시킨다.
    func resetCardPosition(sender: UIPanGestureRecognizer) {
        let direction: SwipeDirection = sender.translation(in: nil).x > 100 ? .right : .left
        let shouldDismissCard = abs(sender.translation(in: nil).x) > 100
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if shouldDismissCard {
                let xTranslation = CGFloat(direction.rawValue) * 1000 // 오른쪽이냐 왼쪽이냐에 따라 1000 또는 -1000 픽셀만큼 움직이기 때문에 화면 밖으로 나가는 것.
                let offScreenTransform = self.transform.translatedBy(x: xTranslation, y: 0)
                self.transform = offScreenTransform
            } else {
                self.transform = .identity
            }
        }) { _ in
            if shouldDismissCard { // dismiss된 카드의 경우
                self.removeFromSuperview() // 화면 밖으로 밀어낸 후에 슈퍼뷰에서 제거함으로써 아예 화면에서 없애버림.
            }
        }
    }
    
    func configureGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        layer.addSublayer(gradientLayer)
    }
    
    func configureGestureRecognizers() {
        // X는 오른쪽으로 가면 양수, 왼쪽으로 가면 음수
        // Y는 위로 가면 음수, 아래로 가면 양수
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleChangePhoto))
        addGestureRecognizer(tap)
    }
}
