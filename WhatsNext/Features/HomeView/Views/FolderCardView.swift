//
//  FolderCardView.swift
//  WhatsNext
//
//  Created by Bensu Özyurt on 29.10.2026.
//

import SwiftUI

struct FolderCardView: View {
    let folder: Folder

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Layered Poster Stack
            ZStack(alignment: .topTrailing) {
                FolderPosterStackView(
                    folderImageURL: folder.folderImageURL,
                    previewPosterURLs: folder.previewPosterURL
                )
                
                // Item count pill
                Text("\(folder.itemCount)")
                    .font(FormatConfig.Fonts.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.65))
                    .clipShape(Capsule())
                    .padding(6)
            }

            // Collaborators Avatars
            HStack(spacing: -6) {
                ForEach(0..<min(folder.collaboratorIds.count, 3), id: \.self) { _ in
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(FormatConfig.Colors.primary)
                        .background(Circle().fill(FormatConfig.Colors.background))
                }
                if folder.collaboratorIds.count > 3 {
                    Text("+\(folder.collaboratorIds.count - 3)")
                        .font(FormatConfig.Fonts.caption)
                        .foregroundStyle(FormatConfig.Colors.mutedText)
                        .padding(.leading, 8)
                }
            }

            // Folder Title
            Text(folder.title)
                .font(FormatConfig.Fonts.createFont(
                    fontName: FormatConfig.Fonts.boldTextName,
                    size: 15))
                .foregroundStyle(FormatConfig.Colors.primary)
                .lineLimit(1)
        }
        .padding(10)
        .background(FormatConfig.Colors.cardBackground.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: FormatConfig.Layout.cornerRadius))
    }
}
