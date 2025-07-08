//
//  verimi_image_viewerApp.swift
//  verimi-image-viewer
//
//  Created by Raul Sulaimanov on 07.07.25.
//

import SwiftUI
import SwiftData

@main
struct verimi_image_viewerApp: App {
    
    var body: some Scene {
        WindowGroup {
            RootCoordinatorView()
        }
        .modelContainer(for: FavoriteImage.self)
    }
}
