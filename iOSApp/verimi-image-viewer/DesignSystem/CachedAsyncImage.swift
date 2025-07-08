//
//  CachedAsyncImage.swift
//  Image Viewer
//
//  Created by Raul Sulaimanov on 06.07.25.
//

import SwiftUI

final class ImageCache {
    static let shared = NSCache<NSURL, UIImage>()
}

struct CachedAsyncImage: View {
    var url: URL
    var interpolation: Image.Interpolation = .none
    var contentMode: ContentMode = .fit
    var size: CGSize? = nil

    @State private var image: UIImage?

    var body: some View {
        main()
    }
}

private extension CachedAsyncImage {
    @ViewBuilder
    func main() -> some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .interpolation(interpolation)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay {
                        ProgressView()
                    }
                    .task { await loadImage() }
            }
        }
        .frame(width: size?.width, height: size?.height)
        .clipped()
    }
    
    func loadImage() async {
        if let cached = ImageCache.shared.object(forKey: url as NSURL) {
            self.image = cached
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                ImageCache.shared.setObject(uiImage, forKey: url as NSURL)
                
                await MainActor.run { self.image = uiImage }
            }
        } catch {
            print("❌ Failed to load image from \(url): \(error)")
        }
    }
}

