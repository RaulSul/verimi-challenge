//
//  FavoritesStore.swift
//  verimi-image-viewer
//
//  Created by Raul Sulaimanov on 07.07.25.
//

import Foundation

@MainActor
class FavoritesStore: ObservableObject {
    @Published private(set) var favorites: [DTOImage] = []
    private let useCase: FavoriteDTOImageStoringUseCaseProtocol

    init(useCase: FavoriteDTOImageStoringUseCaseProtocol) {
        self.useCase = useCase
        reloadFavorites()
    }

    func toggleFavorite(_ dto: DTOImage) {
        do {
            if let _ = try useCase.loadModel(by: dto.id) {
                useCase.delete(dto)
            } else {
                useCase.store(dto)
            }
            reloadFavorites()
        } catch {
            print("Favorite toggle error: \(error)")
        }
    }

    func isFavorited(_ dto: DTOImage) -> Bool {
        favorites.contains(where: { $0.id == dto.id })
    }

    func reloadFavorites() {
        do {
            favorites = try useCase.loadAllFavorites()
        } catch {
            print("Reloading favorites failed: \(error)")
        }
    }
}
