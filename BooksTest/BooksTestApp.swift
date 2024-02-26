//
//  BooksTestApp.swift
//  BooksTest
//
//  Created by Chernov Kostiantyn on 22.02.2024.
//

import SwiftUI
import Firebase

@main
struct BooksTestApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
