//
//  HomePageView.swift
//  WhatsNext
//
//  Created by Bensu Özyurt on 29.10.2026.
//

import SwiftUI

struct HomePageView: View {
    @State private var viewModel = HomeViewModel()
    @State private var showCreateListSheet = false
    @State private var showProfileSheet = false
    
    init(viewModel: HomeViewModel = HomeViewModel()) {
            _viewModel = State(initialValue: viewModel)
    }

    // Two-column grid matching the wireframe sketch
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Folder Grid
                    if viewModel.isLoading {
                        ProgressView("Loading lists...")
                            .frame(maxWidth: .infinity, minHeight: 200)
                    } else if viewModel.folders.isEmpty {
                        emptyStateView
                    } else {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.folders) { folder in
                                NavigationLink(value: folder) {
                                    FolderCardView(folder: folder)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("🍿What's Next")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Top Right: Profile Button
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { showProfileSheet = true }) {
                        Image(systemName: "person.crop.circle")
                            .font(.title3)
                            .foregroundStyle(FormatConfig.Colors.primary)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showCreateListSheet = true }) {
                        Label("Create List", systemImage: "plus")
                            .font(FormatConfig.Fonts.button)
                    }
                }
            }
            // Navigation destination when tapping a folder (matches lower sketch)
            .navigationDestination(for: Folder.self) { folder in
                // Placeholder for FolderDetailView (Screen with Random & Vote buttons)
                Text("Folder Detail: \(folder.title)")
                    .navigationTitle(folder.title)
            }
            // Sheet triggers
            .sheet(isPresented: $showCreateListSheet) {
                // Placeholder for CreateListScreen
                Text("Create List Screen (Next Step)")
            }
            .sheet(isPresented: $showProfileSheet) {
                // Placeholder for Profile Screen
                Text("Profile Screen (Next Step)")
            }
            .task {
                await viewModel.fetchFolders()
            }
        }
    }

    // Empty state when user has no lists yet
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "folder.badge.plus")
                .font(.system(size: 50))
                .foregroundStyle(FormatConfig.Colors.primary)
            Text("No Movie Lists Yet")
                .font(FormatConfig.Fonts.boldText)
                .foregroundStyle(FormatConfig.Colors.primary)
            Text("Tap '+ Create List' to start organizing movies with friends.")
                .font(FormatConfig.Fonts.caption)
                .foregroundStyle(FormatConfig.Colors.mutedText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}
#Preview("With Folders") {
    let mockVM = HomeViewModel()
    mockVM.folders = Folder.sampleFolders
    mockVM.isLoading = false
    
    return HomePageView(viewModel: mockVM)
}

#Preview("Empty State") {
    let emptyVM = HomeViewModel()
    emptyVM.folders = []
    emptyVM.isLoading = false
    
    return HomePageView(viewModel: emptyVM)
}
