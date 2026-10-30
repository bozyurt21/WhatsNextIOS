//
//  HomeViewModel.swift
//  WhatsNext
//
//  Created by Bensu Özyurt on 29.10.2026.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@Observable
class HomeViewModel {
    var folders: [Folder] = []
    var isLoading: Bool = false
    var errorMessage: String?

    private var db: Firestore {
        Firestore.firestore()
    }

    func fetchFolders() async {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        isLoading = true
        errorMessage = nil

        do {
            // Query folders where the current user is owner OR a collaborator
            let snapshot = try await db.collection("folders")
                .whereField("collaboratorIds", arrayContains: currentUserId)
                .order(by: "createdAt", descending: true)
                .getDocuments()

            self.folders = try snapshot.documents.compactMap { doc in
                try doc.data(as: Folder.self)
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
