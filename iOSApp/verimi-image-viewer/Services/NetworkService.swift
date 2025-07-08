//
//  NetworkService.swift
//  Image Viewer
//
//  Created by Raul Sulaimanov on 05.07.25.
//

import Foundation

// MARK: - Protocol
protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(from url: URL?) async throws -> T
}

// MARK: - Error Enum
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
}

// MARK: - Service
final class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()

    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 15
        self.session = URLSession(configuration: config)
    }

    func fetch<T: Decodable>(from url: URL?) async throws -> T {
        guard let url else { throw NetworkError.invalidURL }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.invalidResponse
        }

        return try await Task.detached(priority: .userInitiated) {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        }.value
    }
}
