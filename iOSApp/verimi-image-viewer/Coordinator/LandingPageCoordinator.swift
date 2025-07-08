//
//  LandingPageCoordinator.swift
//  Image Viewer
//
//  Created by Raul Sulaimanov on 05.07.25.
//

import Combine
import SwiftUI

enum LandingPageRoute: Hashable {
    case details(dto: DTOImage)
}

final class LandingPageCoordinator: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()
    
    func showDetails(dto: DTOImage) {
        path.append(LandingPageRoute.details(dto: dto))
    }
}
