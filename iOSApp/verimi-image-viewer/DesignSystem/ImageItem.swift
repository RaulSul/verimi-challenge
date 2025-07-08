//
//  IVImageView.swift
//  Image Viewer
//
//  Created by Raul Sulaimanov on 05.07.25.
//

import SwiftUI

struct ImageItem: View {
    enum SizeType {
        case small
        case normal
    }
    
    var dto: DTOImage
    var isFavorited: Bool = false
    var size: CGSize? = nil
    var type: SizeType = .normal
    var contentMode: ContentMode = .fill
    var onFavoriteIconTapped: (() -> Void)? = nil
    
    private var padding: CGFloat {
        switch type {
        case .small:
            return 4
        case .normal:
            return 12
        }
    }
    
    var body: some View {
        main()
            .overlay {
                ZStack(alignment: .topTrailing) {
                    main()
                    
                    if type == .small && isFavorited || type == .normal {
                        favoriteIcon()
                            .padding(.top, padding)
                            .padding(.trailing, padding)
                    }
                }
            }
    }
}

private extension ImageItem {
    @ViewBuilder
    func main() -> some View {
        if let imageUrl = dto.downloadUrl,
           let url = URL(string: imageUrl) {
            CachedAsyncImage(
                url: url,
                interpolation: type == .small ? .low : .high,
                contentMode: contentMode,
                size: size
            )
        }
    }
    
    @ViewBuilder
    func favoriteIcon() -> some View {
        var iconName: String {
            if type == .small {
                "star.fill"
            } else {
                isFavorited ? "star.fill" : "star"
            }
        }
        
        Image(systemName: iconName)
            .resizable()
            .scaledToFit()
            .foregroundColor(.yellow)
            .frame(
                width: type == .small ? 12 : 24,
                height: type == .small ? 12 : 24
            )
            .clipShape(Rectangle()) //to make it easier to tap
            .onTapGesture {
                if type == .normal {
                    onFavoriteIconTapped?()
                }
            }
        
    }
}
