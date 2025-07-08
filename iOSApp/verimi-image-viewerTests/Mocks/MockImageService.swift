//
//  MockImageService.swift
//  verimi-image-viewerTests
//
//  Created by Raul Sulaimanov on 07.07.25.
//

@testable import verimi_image_viewer
import Foundation

final class MockImageService: ImageServiceProtocol {
    var fetchedPages: [(page: Int, limit: Int)] = []
    var result: [DTOImage] = []

    func fetchImages(page: Int, limit: Int) async throws -> [DTOImage] {
        fetchedPages.append((page, limit))
        return result
    }
}
