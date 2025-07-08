//
//  RootCoordinatorView.swift
//  Image Viewer
//
//  Created by Raul Sulaimanov on 05.07.25.
//

import SwiftUI
import SwiftData

struct RootCoordinatorView: View {
    @Environment(\.modelContext) private var modelContext

    @StateObject private var coordinator = LandingPageCoordinator()
    private var imageService = ImageService(networkService: NetworkService.shared)

    @State private var favoritesStore: FavoritesStore? = nil
    @State private var landingVM: LandingPageVM? = nil

    var body: some View {
        Group {
            if let landingVM, let favoritesStore {
                NavigationStack(path: $coordinator.path) {
                    LandingPageView(viewModel: landingVM)
                        .navigationDestination(for: LandingPageRoute.self) { route in
                            switch route {
                            case .details(let dto):
                                detailsView(imageDTO: dto, store: favoritesStore)
                            }
                        }
                }
            } else {
                ProgressView()
                    .task {
                        initializeViewModels()
                    }
            }
        }
    }

    @MainActor
    private func initializeViewModels() {
        let useCase = FavoriteDTOImageStoringUseCase(context: modelContext)
        let store = FavoritesStore(useCase: useCase)
        let vm = LandingPageVM(
            imageService: imageService,
            favoritesStore: store,
            coordinator: coordinator
        )
        self.favoritesStore = store
        self.landingVM = vm
    }

    private func detailsView(imageDTO: DTOImage, store: FavoritesStore) -> some View {
        let vm = DetailsViewModel(imageDTO: imageDTO, favoritesStore: store)
        return DetailsView(viewModel: vm)
    }
}
