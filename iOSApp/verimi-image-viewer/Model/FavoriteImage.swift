//
//  FavoriteImage.swift
//  Image Viewer
//
//  Created by Raul Sulaimanov on 07.07.25.
//

import Foundation
import SwiftData

@Model
class FavoriteImage {
    var id: String
    var author: String
    var downloadUrl: String?

    init(id: String, author: String, downloadUrl: String?) {
        self.id = id
        self.author = author
        self.downloadUrl = downloadUrl
    }
}
