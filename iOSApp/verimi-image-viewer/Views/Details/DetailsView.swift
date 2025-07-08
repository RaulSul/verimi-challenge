//
//  DetailsView.swift
//  Image Viewer
//
//  Created by Raul Sulaimanov on 05.07.25.
//

import SwiftUI

struct DetailsView: View {
    @ObservedObject var viewModel: DetailsViewModel
    
    var body: some View {
        main()
    }
}
private extension DetailsView {
    @ViewBuilder
    func main() -> some View {
        VStack {
            Spacer()
            
            ImageItem(
                dto: viewModel.imageDTO,
                isFavorited: viewModel.isFavorite,
                contentMode: .fit,
                onFavoriteIconTapped: { viewModel.toggleFavorite() }
            )
            
            HStack {
                Text("Author: \(viewModel.imageDTO.author)")
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                
                Spacer()
            }
            Spacer()
        }
        .background(.black)
    }
}
