//
//  LandingPageVM.swift
//  Image Viewer
//
//  Created by Raul Sulaimanov on 05.07.25.
//
import SwiftUI

@MainActor
final class LandingPageVM: ObservableObject {
    @Published var images: [DTOImage] = []
    @Published private(set) var favoriteImages: [DTOImage] = []
    
    @Published var isInitialLoading = false
    @Published var isPaginating = false
    
    private var currentPage = 1
    private let pageLimit = 15
    
    private let imageService: ImageServiceProtocol
    private let favoritesStore: FavoritesStore
    weak var coordinator: LandingPageCoordinator?
    
    init(
        imageService: ImageServiceProtocol,
        favoritesStore: FavoritesStore,
        coordinator: LandingPageCoordinator?
    ) {
        self.imageService = imageService
        self.favoritesStore = favoritesStore
        self.coordinator = coordinator
        
        // Bind favorites to local favoriteImages
        favoritesStore.$favorites
            .assign(to: &$favoriteImages)
    }
}

//MARK: Methods
extension LandingPageVM {
    func refresh() async {
        isInitialLoading = true
        currentPage = 1
        images = []
        
        defer { isInitialLoading = false }
        await loadNextPage()
    }
    
    func loadNextPage() async {
        guard !isPaginating else { return }
        isPaginating = true
        defer { isPaginating = false }
        
        do {
            let newImages = try await imageService.fetchImages(page: currentPage, limit: pageLimit)
            images += newImages
            currentPage += 1
        } catch {
            print("Error fetching page \(currentPage): \(error)")
        }
    }
    
    func didTapDetails(dto: DTOImage) {
        coordinator?.showDetails(dto: dto)
    }
    
    func toggleFavorite(for dto: DTOImage) {
        favoritesStore.toggleFavorite(dto)
    }
    
    func isImageFavorited(_ dto: DTOImage) -> Bool {
        favoritesStore.isFavorited(dto)
    }
}
