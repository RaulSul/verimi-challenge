//
//  DetailsViewModelTests.swift
//  verimi-image-viewerTests
//
//  Created by Raul Sulaimanov on 07.07.25.
//

@testable import verimi_image_viewer
import XCTest
import SwiftData

@MainActor
final class DetailsViewModelTests: XCTestCase {
    var container: ModelContainer!
    var context: ModelContext!
    var favoritesStore: FavoritesStore!

    override func setUpWithError() throws {
        container = inMemoryContainer()
        context = ModelContext(container)
        favoritesStore = FavoritesStore(useCase: FavoriteDTOImageStoringUseCase(context: context))
    }

    override func tearDownWithError() throws {
        container = nil
        context = nil
        favoritesStore = nil
    }

    func testInitialFavoriteStateReflectsStore() {
        let image = DTOImage(id: "fav123", author: "John", downloadUrl: "url")
        favoritesStore.toggleFavorite(image)

        let detailsVM = DetailsViewModel(imageDTO: image, favoritesStore: favoritesStore)
        XCTAssertTrue(detailsVM.isFavorite)
    }

    func testToggleFavoriteTogglesCorrectly() {
        let image = DTOImage(id: "fav456", author: "Jane", downloadUrl: "url")
        let detailsVM = DetailsViewModel(imageDTO: image, favoritesStore: favoritesStore)

        XCTAssertFalse(detailsVM.isFavorite)

        detailsVM.toggleFavorite()
        XCTAssertTrue(detailsVM.isFavorite)
        XCTAssertTrue(favoritesStore.isFavorited(image))

        detailsVM.toggleFavorite()
        XCTAssertFalse(detailsVM.isFavorite)
        XCTAssertFalse(favoritesStore.isFavorited(image))
    }
}

private extension DetailsViewModelTests {
    func inMemoryContainer() -> ModelContainer {
        let schema = Schema([FavoriteImage.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try! ModelContainer(for: schema, configurations: [config])
    }
}
