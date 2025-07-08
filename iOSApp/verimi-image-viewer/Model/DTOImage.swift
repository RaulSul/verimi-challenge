//
//  DTOImage.swift
//  Image Viewer
//
//  Created by Raul Sulaimanov on 05.07.25.
//

import Foundation

struct DTOImage: Codable, Identifiable, Hashable {
    var id: String
    var author: String
    var downloadUrl: String?
}
