//
//  User.swift
//  WhatsNext
//
//  Created by Bensu Özyurt on 18.10.2026.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct User : Identifiable, Codable, Hashable{
    @DocumentID var id: String?
    var userName: String?
    var email: String
    var profileImage: String?
    var createdAt: Date
    var sharedFolderIDs: [String]?
    
    init(from firebaseUser: FirebaseAuth.User) {
        self.id = firebaseUser.uid
        self.userName = firebaseUser.displayName
        self.email = firebaseUser.email ?? ""
        self.profileImage = firebaseUser.photoURL?.absoluteString
        self.createdAt = firebaseUser.metadata.creationDate ?? Date()
        self.sharedFolderIDs = []
    }
    
    var formattedName: String {
        if let userName, !userName.isEmpty {
            return userName
        }
        return email.components(separatedBy: "@").first ?? "User"
    }
    
    
}
