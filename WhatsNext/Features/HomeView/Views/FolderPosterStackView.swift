//
//  FolderPosterStackView.swift
//  WhatsNext
//
//  Created by Bensu Özyurt on 30.10.2026.
//

import SwiftUI

struct FolderPosterStackView: View {
    let folderImageURL: String?
    let previewPosterURLs: [String]
    
    // Stack layout angles and offsets
    private let stackTransforms: [(rotation: Double, x: CGFloat, y: CGFloat, scale: CGFloat)] = [
        (-7.0, -8, 4, 0.90),  // Back card tilted left
        (6.0, 8, 2, 0.95),   // Middle card tilted right
        (0.0, 0, 0, 1.0)     // Front card straight
    ]

    var body: some View {
        ZStack {
            if let folderImageURL, let url = URL(string: folderImageURL) {
                // 1. Custom folder image if user uploaded one
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        placeholderCard(systemIcon: "photo")
                    }
                }
                .frame(maxWidth: .infinity)
                .aspectRatio(0.72, contentMode: .fit) // Standard movie poster ratio (2:3)
                .clipShape(RoundedRectangle(cornerRadius: FormatConfig.Layout.cornerRadius))
            } else if !previewPosterURLs.isEmpty {
                // 2. Stack of movie posters
                let displayItems = Array(previewPosterURLs.prefix(3).reversed())
                
                ForEach(Array(displayItems.enumerated()), id: \.offset) { index, posterURL in
                    let transform = stackTransforms[safe: index] ?? (0.0, 0, 0, 1.0)
                    
                    singlePosterCard(urlString: posterURL)
                        .scaleEffect(transform.scale)
                        .rotationEffect(.degrees(transform.rotation))
                        .offset(x: transform.x, y: transform.y)
                        .shadow(color: .black.opacity(0.18), radius: 6, x: 0, y: 3)
                }
            } else {
                // 3. Fallback layered placeholders when folder is empty
                ForEach(0..<3, id: \.self) { index in
                    let transform = stackTransforms[index]
                    
                    placeholderCard(systemIcon: index == 2 ? "film.stack" : nil)
                        .scaleEffect(transform.scale)
                        .rotationEffect(.degrees(transform.rotation))
                        .offset(x: transform.x, y: transform.y)
                        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                }
            }
        }
        .frame(height: 190) // Fixed height for consistent grid alignment
        .padding(.vertical, 8)
    }

    // Single poster card view
    private func singlePosterCard(urlString: String) -> some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            default:
                placeholderCard(systemIcon: "popcorn.fill")
            }
        }
        .frame(width: 125, height: 175)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
    }

    // Stylized placeholder card
    private func placeholderCard(systemIcon: String?) -> some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(
                LinearGradient(
                    colors: [
                        FormatConfig.Colors.cardBackground,
                        FormatConfig.Colors.cardBackground.opacity(0.7)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 125, height: 175)
            .overlay(
                Group {
                    if let systemIcon {
                        Image(systemName: systemIcon)
                            .font(.system(size: 28))
                            .foregroundStyle(FormatConfig.Colors.primary.opacity(0.7))
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
    }
}

// Array safe index helper
private extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
