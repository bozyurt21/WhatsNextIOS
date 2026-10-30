//
//  Folder.swift
//  WhatsNext
//
//  Created by Bensu Özyurt on 29.10.2026.
//

import Foundation
import FirebaseFirestore

struct FolderCollaborator: Codable, Hashable, Identifiable {
    var id: String { userId }
    var userId: String
    var displayName: String?
    var photoURL: String?
}

struct Folder : Identifiable, Codable, Hashable {
    @DocumentID var id : String?
    let title : String
    var ownerId : String
    var collaboratorIds : [String]
    var folderImageURL : String?
    var previewPosterURL : [String] = []
    var createdAt : Date = Date()
    var itemCount : Int = 0
    
    static let sampleFolders: [Folder] = [
            Folder(id: "1",
                   title: "Friday Movie Night",
                   ownerId: "user1",
                   collaboratorIds: ["u1", "u2", "u3"],
                   folderImageURL: nil,
                   previewPosterURL: [
                    "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg",
                    "https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg",
                    "https://image.tmdb.org/t/p/w500/fiVW06jE7z9YnO4trhaMEdclSiC.jpg"
                    ],
                   itemCount: 12),
            
            Folder(id: "2",
                   title: "Binge Watch Series",
                   ownerId: "user1",
                   collaboratorIds: ["u1", "u4"],
                   folderImageURL: nil,
                   itemCount: 5),
            
            Folder(id: "3",
                   title: "Horror Spooktacular",
                   ownerId: "user2",
                   collaboratorIds: ["u1", "u2"],
                   folderImageURL: nil,
                   itemCount: 8)
    ]
    
}
