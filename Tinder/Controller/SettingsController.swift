//
//  SettingsController.swift
//  Tinder
//
//  Created by Sungwoong Kang on 2022/01/17.
//

import UIKit

class SettingsController: UITableViewController {
    // MARK: - Properties
    private let headerView = SettingsHeader()
    private let imagePicker = UIImagePickerController()
    private var imageIndex = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Actions
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDone() {
        print("DEBUG: Handle did tap done...")
    }
    
    // MARK: - Helpers
    
    func setHeaderImage(_ image: UIImage?) {
        headerView.buttons[imageIndex].setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    func configureUI() {
        headerView.delegate = self
        imagePicker.delegate = self
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        
        tableView.separatorStyle = .none
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
    }
}

// MARK: - SettingsHeaderDelegate

extension SettingsController: SettingsHeaderDelegate {
    func settingsHeader(_ header: SettingsHeader, didSelect index: Int) {
        self.imageIndex = index
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        setHeaderImage(selectedImage)
        dismiss(animated: true, completion: nil)
    }
}
