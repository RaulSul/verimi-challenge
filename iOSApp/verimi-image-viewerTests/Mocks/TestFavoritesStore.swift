//
//  TestFavoritesStore.swift
//  verimi-image-viewerTests
//
//  Created by Raul Sulaimanov on 07.07.25.
//
@testable import verimi_image_viewer
import Foundation
import SwiftData

final class TestFavoritesStore: FavoritesStore {
    init(context: ModelContext) {
        let useCase = FavoriteDTOImageStoringUseCase(context: context)
        super.init(useCase: useCase)
    }
}
