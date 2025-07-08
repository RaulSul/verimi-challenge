//
//  FavoriteDTOImageStoringUseCase.swift
//  verimi-image-viewer
//
//  Created by Raul Sulaimanov on 07.07.25.
//

import Foundation
import SwiftData

protocol FavoriteDTOImageStoringUseCaseProtocol {
    func store(_ dto: DTOImage)
    func delete(_ dto: DTOImage)
    func loadAllFavorites() throws -> [DTOImage]
    func loadModel(by id: String) throws -> DTOImage?
}

final class FavoriteDTOImageStoringUseCase: FavoriteDTOImageStoringUseCaseProtocol {
    var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    public func store(_ dto: DTOImage) {
        let model = FavoriteImage(
            id: dto.id,
            author: dto.author,
            downloadUrl: dto.downloadUrl
        )
        
        context.insert(model)
        
        do {
            try context.save()
        } catch {
            print("Failed to store favorite. Error: \(error)")
        }
    }
    
    public func delete(_ dto: DTOImage) {
        if let storedModel = fetchFavoriteEntity(by: dto.id) {
            context.delete(storedModel)
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to store favorite. Error: \(error)")
        }
    }
    
    public func loadAllFavorites() throws -> [DTOImage] {
        let descriptor = FetchDescriptor<FavoriteImage>(
            sortBy: [SortDescriptor(\.id, order: .forward)]
        )
        
        let favorites = try context.fetch(descriptor)
        return favorites.map {
            DTOImage(id: $0.id, author: $0.author, downloadUrl: $0.downloadUrl)
        }
    }
    
    public func loadModel(by id: String) throws -> DTOImage? {
        if let model = fetchFavoriteEntity(by: id) {
            return DTOImage(id: model.id, author: model.author, downloadUrl: model.downloadUrl)
        } else {
            return nil
        }
    }
}

private extension FavoriteDTOImageStoringUseCase {
    func fetchFavoriteEntity(by id: String) -> FavoriteImage? {
        let descriptor = FetchDescriptor<FavoriteImage>(
            predicate: #Predicate { $0.id == id }
        )
        
        return try? context.fetch(descriptor).first
    }
}
