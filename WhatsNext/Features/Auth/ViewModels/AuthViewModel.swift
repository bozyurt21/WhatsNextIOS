//
//  AuthenticationViewModel.swift
//  WhatsNext
//
//  Created by Bensu Özyurt on 18.10.2026.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore
import FirebaseCore
import UIKit

@MainActor
@Observable
class AuthViewModel {
    var is_authenticated: Bool = false
    var user: User?
    var isLoading: Bool = false
    var errorMessage: String?
    
    private var db: Firestore {
        Firestore.firestore()
    }
    private var authListenerHandle: AuthStateDidChangeListenerHandle?
    
    init() {
            if FirebaseApp.app() != nil {
                setupAuthListener()
            }
        }
        
    func removeAuthListener() {
        if let handle = authListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
            authListenerHandle = nil
        }
    }
    
    deinit {
        MainActor.assumeIsolated {
            if let handle = self.authListenerHandle {
                Auth.auth().removeStateDidChangeListener(handle)
            }
        }
    }
    
    func setupAuthListener() {
        authListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, firebaseUser in
            Task { @MainActor in
                guard let self = self else { return }
                
                if let firebaseUser {
                    self.is_authenticated = true
                    // Fetch full User document from Firestore
                    await self.fetchCurrentUserData(userId: firebaseUser.uid)
                } else {
                    self.is_authenticated = false
                    self.user = nil
                }
            }
        }
    }
    
    // MARK: - Email Sign In
    func signInWithEmail(email: String, password: String) async throws {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        await fetchCurrentUserData(userId: result.user.uid)
    }
    
    // MARK: - Email Sign Up
    func signUpWithEmail(email: String, password: String, username: String) async throws {
        // 1. Create the Auth account
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        
        // 2. Set the displayName on Firebase Auth profile
        let changeRequest = result.user.createProfileChangeRequest()
        changeRequest.displayName = username
        try await changeRequest.commitChanges()
        
        // 3. Construct the User object matching your ER model
        var newUser = User(from: result.user)
        newUser.userName = username
        
        // 4. Save to Firestore "users" collection
        try await saveUserToFirestore(newUser)
        
        self.user = newUser
        self.is_authenticated = true
    }
    
    // MARK: - Google Sign In
    func signInWithGoogle() async throws {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        guard let idToken = result.user.idToken?.tokenString else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: result.user.accessToken.tokenString)
        let authResult = try await Auth.auth().signIn(with: credential)
        
        // Ensure user document exists in Firestore
        let userDoc = try await db.collection("users").document(authResult.user.uid).getDocument()
        
        if !userDoc.exists {
            var newUser = User(from: authResult.user)
            if newUser.userName == nil || newUser.userName?.isEmpty == true {
                newUser.userName = authResult.user.displayName ?? "User"
            }
            try await saveUserToFirestore(newUser)
            self.user = newUser
        } else {
            self.user = try userDoc.data(as: User.self)
        }
        
        self.is_authenticated = true
    }
    
    // MARK: - Sign Out
    func signOut() throws {
        try Auth.auth().signOut()
        GIDSignIn.sharedInstance.signOut()
        self.user = nil
        self.is_authenticated = false
    }
    
    // MARK: - Firestore Helpers
    func fetchCurrentUserData(userId: String) async {
        do {
            let document = try await db.collection("users").document(userId).getDocument()
            if document.exists {
                self.user = try document.data(as: User.self)
            }
        } catch {
            print("Failed to fetch user data: \(error.localizedDescription)")
        }
    }
    
    private func saveUserToFirestore(_ user: User) async throws {
        guard let userId = user.id else { return }
        try db.collection("users").document(userId).setData(from: user, merge: true)
    }
}
