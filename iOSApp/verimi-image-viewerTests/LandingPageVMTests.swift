//
//  LandingPageVMTests.swift
//  verimi-image-viewerTests
//
//  Created by Raul Sulaimanov on 07.07.25.
//

@testable import verimi_image_viewer
import XCTest
import SwiftData

@MainActor
final class LandingPageVMTests: XCTestCase {
    var viewModel: LandingPageVM!
    var mockService: MockImageService!
    var favoritesStore: FavoritesStore!
    var container: ModelContainer!
    var context: ModelContext!

    override func setUp() async throws {
        mockService = MockImageService()
        container = inMemoryContainer()
        context = ModelContext(container)
        favoritesStore = FavoritesStore(useCase: FavoriteDTOImageStoringUseCase(context: context))
        viewModel = LandingPageVM(
            imageService: mockService,
            favoritesStore: favoritesStore,
            coordinator: nil
        )
    }

    override func tearDown() {
        mockService = nil
        container = nil
        context = nil
        favoritesStore = nil
        viewModel = nil
    }

    func testRefreshLoadsImagesAndClearsOldOnes() async {
        // Given
        let mockImage = DTOImage(id: "123", author: "Test", downloadUrl: "url")
        mockService.result = [mockImage]

        // When
        await viewModel.refresh()

        // Then
        let actualCount = viewModel.images.count

        XCTAssertEqual(actualCount, 1, "Expected 1 image, got \(actualCount)")
        XCTAssertEqual(viewModel.images.first?.id, "123")
    }

    func testLoadNextPageAppendsImages() async {
        // Given
        let first = DTOImage(id: "1", author: "A", downloadUrl: "url")
        let second = DTOImage(id: "2", author: "B", downloadUrl: "url")
        mockService.result = [first]

        await viewModel.loadNextPage()
        XCTAssertEqual(viewModel.images.count, 1)

        mockService.result = [second]
        await viewModel.loadNextPage()
        XCTAssertEqual(viewModel.images.count, 2)
    }

    func testToggleFavoriteAddsAndRemovesFavorite() {
        // Given
        let image = DTOImage(id: "fav1", author: "Author", downloadUrl: "url")

        // When
        viewModel.toggleFavorite(for: image)

        // Then
        XCTAssertTrue(viewModel.isImageFavorited(image))
        XCTAssertEqual(viewModel.favoriteImages.count, 1)

        viewModel.toggleFavorite(for: image) // Toggle again
        
        XCTAssertFalse(viewModel.isImageFavorited(image))
        XCTAssertEqual(viewModel.favoriteImages.count, 0)
    }

    func testIsImageFavoritedReturnsCorrectStatus() {
        let image = DTOImage(id: "123", author: "author", downloadUrl: "url")
        XCTAssertFalse(viewModel.isImageFavorited(image))
        viewModel.toggleFavorite(for: image)
        XCTAssertTrue(viewModel.isImageFavorited(image))
    }
}

extension LandingPageVMTests {
    func inMemoryContainer() -> ModelContainer {
        let schema = Schema([FavoriteImage.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try! ModelContainer(for: schema, configurations: [config])
    }
}
