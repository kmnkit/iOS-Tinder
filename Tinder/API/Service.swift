//
//  Service.swift
//  Tinder
//
//  Created by Sungwoong Kang on 2022/01/16.
//
import FirebaseStorage
import UIKit

struct Service {
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        
        COLLECTION_USERS.getDocuments { (snapshot, error) in
            snapshot?.documents.forEach({ document in
                let dictionary = document.data()
                let user = User(dictionary: dictionary)
                
                users.append(user)
                                
                if users.count == snapshot?.documents.count {
                    print("DEBUG: Document count is \(snapshot?.documents.count)")
                    print("DEBUG: Users array count is \(users.count)")
                    completion(users)
                }
            })
        }
    }
    
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        
        ref.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("DEBUG: Error Uploading image \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
}

