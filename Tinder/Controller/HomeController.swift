//
//  HomeController.swift
//  Tinder
//
//  Created by Sungwoong Kang on 2022/01/15.
//

import UIKit
import Firebase

class HomeController: UIViewController {
    
    // MARK: - Properties
    
    private let topStack = HomeNavigationStackView()
    private let bottomStack = BottomControlsStackView()
    
    private var viewModels = [CardViewModel]() {
        didSet { configureCards() }
    }
    
    private let deckView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        view.layer.cornerRadius = 5
        return view
    }()
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        configureUI()
        fetchUsers()
    }
    
    // MARK: - API
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { user in
            print("DEBUG: User is \(user.name)")
            print("DEBUG: User email is \(user.email)")
        }
    }
    
    func fetchUsers() {
        Service().fetchUsers { users in
            self.viewModels = users.map({ CardViewModel(user: $0) })
        }
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            presentLoginController()
        } else {
            print("DEBUG: User is logged in..")
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            presentLoginController()
        } catch {
            print("DEBUG: Failed to Sign out..")
        }
    }
    
    // MARK: - Helpers
    
    func configureCards(){
        viewModels.forEach { viewModel in
            let cardView = CardView(viewModel: viewModel)
            deckView.addSubview(cardView)
            cardView.fillSuperview()
        }        
    }
    
    func configureUI(){
        view.backgroundColor = .white
        
        topStack.delegate = self
        
        let stack = UIStackView(arrangedSubviews: [
        topStack, deckView, bottomStack])
        stack.axis = .vertical
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                    bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        stack.bringSubviewToFront(deckView)
    }
    
    func presentLoginController() {
        DispatchQueue.main.async {
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
}

extension HomeController: HomeNavigationStackViewDelegate {
    func showSettings() {
        let controller = SettingsController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func showMessages() {
        print("DEBUG: Show Messages from home Controller..")
    }
    
    
}
