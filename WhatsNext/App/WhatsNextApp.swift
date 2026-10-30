//
//  WhatsNextApp.swift
//  WhatsNext
//
//  Created by Bensu Özyurt on 17.10.2026.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        return true
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct WhatsNextApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var authViewModel: AuthViewModel

    init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        _authViewModel = State(initialValue: AuthViewModel())
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if authViewModel.is_authenticated {
                    HomePageView()
                } else {
                    AuthView()
                }
            }
            .environment(authViewModel)
        }
    }
}
