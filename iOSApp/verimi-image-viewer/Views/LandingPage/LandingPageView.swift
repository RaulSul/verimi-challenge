//
//  LandingPageView.swift
//  Image Viewer
//
//  Created by Raul Sulaimanov on 05.07.25.
//

import SwiftUI

struct LandingPageView: View {
    @StateObject var viewModel: LandingPageVM
    
    @State private var columns = Array(
        repeating: GridItem(.fixed(100)),
        count: 3
    )
    
    var body: some View {
        main()
            .background(Color.white)
            .task {
                if viewModel.images.isEmpty {
                    await viewModel.refresh()
                }
            }
    }
}

private extension LandingPageView {
    @ViewBuilder
    func main() -> some View {
        TabView {
            imagesList()
                .tabItem {
                    Image(systemName: "tray")
                }
            
            favoriteImagesList()
                .tabItem {
                    Image(systemName: "star")
                        .foregroundStyle(.yellow)
                }
        }
    }
    
    @ViewBuilder
    func imagesList() -> some View {
        if viewModel.isInitialLoading {
            loadingView()
        } else {
            VStack {
                header(title: "General")
                    .padding(.top, 12)
                    .padding(.leading, 20)
                
                ScrollView {
                    VStack {
                        if viewModel.images.isEmpty {
                            Text("No images yet")
                                .font(.body)
                                .foregroundStyle(.gray)
                                .padding()
                            
                        } else {
                            LazyVGrid(columns: columns, spacing: 4) {
                                ForEach(viewModel.images, id: \.id) { dto in
                                    image(dto)
                                    .onAppear {
                                        if dto == viewModel.images.last {
                                            Task {
                                                await viewModel.loadNextPage()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    if viewModel.isPaginating {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .refreshable {
                    await viewModel.refresh()
                }
            }
        }
    }
    
    @ViewBuilder
    func favoriteImagesList() -> some View {
        VStack {
            header(title: "Favorites")
                .padding(.top, 12)
                .padding(.leading, 20)
            
            ScrollView {
                VStack {
                    if viewModel.favoriteImages.isEmpty {
                        Text("No favorites yet")
                            .font(.body)
                            .foregroundStyle(.gray)
                            .padding()
                        
                    } else {
                        LazyVGrid(columns: columns) {
                            ForEach(viewModel.favoriteImages, id: \.id) { dto in
                                image(dto)
                            }
                        }
                    }
                    
                    if viewModel.isPaginating {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
    }
    
    @ViewBuilder
    func header(title: String) -> some View {
        HStack {
            Text(title)
                .font(.largeTitle)
                .foregroundStyle(Color.gray)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    func image(_ dto: DTOImage) -> some View {
        ImageItem(
            dto: dto,
            isFavorited: viewModel.isImageFavorited(dto),
            size: CGSize(width: 100, height: 100),
            type: .small
        )
        .onTapGesture {
            viewModel.didTapDetails(dto: dto)
        }
    }
    
    @ViewBuilder
    func loadingView() -> some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
}
