//
//  ImageService.swift
//  Image Viewer
//
//  Created by Raul Sulaimanov on 05.07.25.
//

import Foundation

protocol ImageServiceProtocol {
    func fetchImages(page: Int, limit: Int) async throws -> [DTOImage]
}

final class ImageService: ImageServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let baseURLString = "https://picsum.photos/v2/list"

    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }

    func fetchImages(page: Int = 1, limit: Int = 10) async throws -> [DTOImage] {
        guard let url = URL(string: "\(baseURLString)?page=\(page)&limit=\(limit).webp") else {
            throw NetworkError.invalidURL
        }

        return try await networkService.fetch(from: url)
    }
}
