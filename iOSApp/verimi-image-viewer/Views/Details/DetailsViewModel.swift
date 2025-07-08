//
//  DetailsViewModel.swift
//  Image Viewer
//
//  Created by Raul Sulaimanov on 05.07.25.
//

import Foundation

@MainActor
final class DetailsViewModel: ObservableObject {
    @Published var isFavorite: Bool = false
    
    let imageDTO: DTOImage
    private let favoritesStore: FavoritesStore

    init(imageDTO: DTOImage, favoritesStore: FavoritesStore) {
        self.imageDTO = imageDTO
        self.favoritesStore = favoritesStore
        self.isFavorite = favoritesStore.isFavorited(imageDTO)
    }

    func toggleFavorite() {
        favoritesStore.toggleFavorite(imageDTO)
        isFavorite = favoritesStore.isFavorited(imageDTO)
    }
}
